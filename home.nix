{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./themes.nix
  ];
  home.username = "markus";
  home.homeDirectory = "/home/markus";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    t64gram
    tmux
    zathura

    #Neovim
    # cargo
    alejandra
    gamemode
    shfmt
    shellcheck
    # rnix-lsp
    stylua
    isort
    black
    nodePackages.prettier
  ];
}
