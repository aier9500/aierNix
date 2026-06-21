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

    # OpenWhispr — voice dictation; its NixOS module wires up Wayland auto-paste.
    # See modules/system/openwhispr.nix.
    openwhispr = {
      url = "github:OpenWhispr/openwhispr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      # mkHost/mkHome helpers (auto-inject modules/options.nix, pass inputs).
      lib = import ./lib/default.nix { inherit inputs; };
    in
    {
      nixosConfigurations.aierNixOS = lib.mkHost {
        inherit system;
        modules = [ ./hosts/aierNixOS/default.nix ];
      };

      # Standalone home-manager (nh home switch).
      homeConfigurations.aier = lib.mkHome {
        inherit pkgs;
        modules = [ ./hosts/aierNixOS/home.nix ];
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;

      # Dev shell (nix develop): quality-gate tools.
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixfmt-rfc-style
          pkgs.statix
          pkgs.deadnix
          pkgs.nh
        ];
      };

      # Pre-commit checks (git-hooks.nix). hardware-configuration.nix is excluded —
      # it's generated, so its statix/deadnix flags aren't actionable.
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
