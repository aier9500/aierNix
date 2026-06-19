{
  description = "aier's NixOS + home-manager dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      # Helper library — mkHost wraps nixosSystem, mkHome wraps homeManagerConfiguration.
      # Both auto-inject modules/options.nix and pass inputs as specialArgs.
      lib = import ./lib/default.nix { inherit inputs; };
    in
    {
      # --- NixOS system configuration ---
      nixosConfigurations.aierNixOS = lib.mkHost {
        inherit system;
        modules = [ ./hosts/aierNixOS/default.nix ];
      };

      # --- Standalone home-manager configuration ---
      # Activated via: nh home switch
      homeConfigurations.aier = lib.mkHome {
        inherit pkgs;
        modules = [ ./hosts/aierNixOS/home.nix ];
      };

      # --- Formatter (nix fmt) ---
      formatter.${system} = pkgs.nixfmt-rfc-style;

      # --- Dev shell: quality-gate tools ---
      # Enter with: nix develop
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixfmt-rfc-style
          pkgs.statix
          pkgs.deadnix
          pkgs.nh
        ];
      };

      # --- Pre-commit checks via git-hooks.nix ---
      # Excludes:
      #   hardware-configuration.nix — generated file; statix/deadnix flags
      #                                are expected and not actionable
      checks.${system}.pre-commit-check = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt-rfc-style = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
            excludes = [ "hardware-configuration\\.nix$" ];
          };
          statix = {
            enable = true;
            # hardware-configuration.nix is excluded via statix.toml (flat config).
          };
          deadnix = {
            enable = true;
            excludes = [ "hardware-configuration\\.nix$" ];
          };
        };
      };
    };
}
