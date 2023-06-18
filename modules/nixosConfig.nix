{pkgs, ...}: {
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];
  home.packages = with pkgs; [
    waybar
    wofi
    swaybg
    nixos-option
    bottles
    grapejuice
    wl-clipboard
    foot
    tmux
  ];
}
