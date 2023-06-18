{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    t64gram = {
      url = "github:Markus328/64gram-desktop-bin/no-fhs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    defaultPackage.x86_64-linux = inputs.home-manager.defaultPackage.x86_64-linux;
    homeManagerModules.mod = {...}: {
      imports = [./modules];
    };
    homeConfigurations = let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [
          inputs.nixGL.overlay
          inputs.t64gram.overlay
        ];
      };
      baseModules = [./home.nix ./modules/flatpak-themes.nix];
    in {
      "markus@arch-desktop" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = baseModules ++ [./modules/archConfig.nix];
      };
      "markus@nixos-desktop" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = baseModules ++ [./modules/nixosConfig.nix];
      };
    };
  };
}
