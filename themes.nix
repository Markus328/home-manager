{
  config,
  pkgs,
  ...
}:
with pkgs; let
  bibata-icon-ice = runCommand "bibata-icon-ice" {} ''
    mkdir -p $out/share/icons
    tar -xf ${fetchurl {
      url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Ice.tar.gz";
      sha256 = "4a429343301a3fcb11e7ff738c903703b3dd113efd8e221742cfbfd7714e0e98";
    }} -C $out/share/icons
  '';
in {
  home = {
    flatpak-themes = {
      enable = true;
      icons = [
        bibata-icon-ice
      ];
      themes = [
        dracula-theme
      ];
      fonts = [
        fantasque-sans-mono
        font-awesome
        (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
      ];
    };
    file.".local/share/" = {
      source = "${config.home.flatpak-themes.themes-join}/share";
      recursive = true;
    };

    pointerCursor = {
      gtk.enable = true;
      name = "Bibata-Modern-Ice";
      size = 24;
      package = bibata-icon-ice;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = dracula-theme;
    };
  };
}
