{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.flatpak-themes;
  all-themes = builtins.concatLists (with cfg; [icons themes fonts packages]);
  themes-join = pkgs.symlinkJoin {
    name = "home-themes";
    paths = all-themes;
  };
in {
  options.home.flatpak-themes = let
    mkThemeOption = name: examplePkg: descriptionTxt:
      mkOption {
        type = types.listOf types.package;
        default = [];
        example = {
          ${name} = [examplePkg];
        };
        description = descriptionTxt;
      };
  in {
    themes-join = mkOption {
      type = types.package;
      default = themes-join;
      readOnly = true;
    };
    enable = mkEnableOption "flatpak-themes";
    icons = mkThemeOption "icons" "bibata-icon-ice" ''
      Option to expose icons to flatpak, exposes /share/icons
    '';
    themes = mkThemeOption "themes" "dracula-theme" ''
      Option to expose themes to flatpak, exposes /share/themes
    '';
    fonts = mkThemeOption "fonts" "font-awesome" ''
      Option to expose fonts to flatpak, exposes /share/fonts
    '';
    packages = mkThemeOption "packages" "dracula-theme" ''
      Option to expose packages to flatpak, exposes the whole /share
    '';
  };

  config = mkIf cfg.enable {
    home.activation.expose-themes-flatpak = lib.hm.dag.entryAfter ["linkGeneration"] ''
      THEMES="${builtins.concatStringsSep ";" all-themes}"
      THEMES_NAME="${builtins.concatStringsSep ";" (builtins.map (theme: theme.name) all-themes)}"
      HOME_FILES="${config.home-files}/.local/share"
      HOME_THEMES="${themes-join}/share"
      THEMES="$THEMES;$HOME_FILES;$HOME_THEMES"

      edit_paths() {
      	local paths=$*
      	local themes_to_add
      	local result_paths=""
      	local pure_path
      	local path

      	pass() {
          local tmp=()
          for i in ''${themes_to_add[*]}; do
            if [ "$i" != "$pure_path" ]; then tmp+=("$i"); fi
          done

          themes_to_add=(''${tmp[@]})
      		result_paths+="$path;"
      	}


      	local IFS=";"
      	read -ra themes_to_add <<<"$THEMES"
      	for path in ''${paths[*]}; do
      		pure_path="$(cut -d':' -f1 <<<$path)"
      		if ! [[ "$pure_path" =~ ^/nix/store/.+ ]]; then
      			pass && continue
      		fi
      		if [[ "''${themes_to_add[*]}" =~ "$pure_path" ]]; then
      			pass && continue
      		else
      			if ! [ -e "$pure_path" ]; then
      				continue
      			fi

            name="$(sed -r 's/\/nix\/store\/[^-\/]+-(([^\/]+)(-[0-9\.]+)|([^\/]+)).*/\2\4/g' <<< $pure_path)"
      			has=$(grep -E ";$name$|^$name;|;$name;|^$name$" <<<$(sed -r 's/-[0-9\.]+(;)?/\1/g' <<< $THEMES_NAME))
      			if [[ "$has" ]]; then
      				continue
      			else
      				pass && continue
      			fi
      		fi

      	done

        unset IFS


        for theme in "''${themes_to_add[@]}"; do
          result_paths+="$theme;"
        done


      	echo $result_paths
      }

      override_dir=~/.local/share/flatpak/overrides
      mkdir -p $override_dir
      touch $override_dir/global
      if [ ! -s $override_dir/global ]; then
      	echo -e "[Context]\nfilesystems=''${THEMES}" > $override_dir/global && exit
      fi

      grep -q "$THEMES" $override_dir/global && exit
      files="$(grep 'filesystems=.*' $override_dir/global)"
      if [[ "$files" ]]; then
      	new_paths=$(edit_paths "$(cut -d'=' -f2 <<<$files)")
      else
      	echo "filesystems=" >>$override_dir/global
      fi
      regex="\(\[Context\]\(.*\n\)*\)\?\(filesystems=\([^\n]*\)\)\n"
      subs="\[Context\]\2filesystems=''${new_paths}\n"
      sed -zi "s>''${regex}>''${subs}>g" $override_dir/global
    '';
  };
}
