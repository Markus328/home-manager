{ pkgs, t64gram, ... }: {
  nixpkgs.overlays = [];
  home.packages = with pkgs; [
    wl-clipboard
    foot
    tmux

    #programming
  ];
}
