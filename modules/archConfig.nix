{
  config,
  pkgs,
  ...
}: {
  targets.genericLinux.enable = true;
  home.packages = with pkgs; [
    neovim

    #utils
    ncdu
    iotop
    intel-gpu-tools
    unzip
    curl
    nixgl.nixGLIntel
    nixgl.nixVulkanIntel

    (writeShellScriptBin "wine" ''
      flatpak run org.winehq.Wine $@
    '')
  ];
}
