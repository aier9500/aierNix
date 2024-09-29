{
  description = "aier's Flake file";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.aier = nixpkgs.lib.nixosSystem {
        inherit system; 
        modules = [ 
          ./aier/configuration.nix 
        ];
      };

      homeConfigurations.aier = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./aier/home.nix 
        ];
      };
    };
}
