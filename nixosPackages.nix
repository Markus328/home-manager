{ pkgs, t64gram, ... }: {

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
  home.packages = with pkgs; [
    waybar
    wofi
    swaybg
    pavucontrol
    nixos-option
    bottles
    grapejuice
    wl-clipboard
    foot
    keepassxc
    nextcloud-client
    tmux
    wineWowPackages.unstableFull
    t64gram

    #programming
    clang
    clang-tools
    cargo
    rnix-lsp
    nodejs
  ];
}
