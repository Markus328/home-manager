{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    t64gram = {
      url = "github:Markus328/64gram-desktop-bin";
    };
  };

  outputs = inputs: {
    defaultPackage.x86_64-linux = inputs.home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      "markus@arch-desktop" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { t64gram = inputs.t64gram.defaultPackage.x86_64-linux; };
        modules = [ ./home.nix ];
      };
    };
  };
}

