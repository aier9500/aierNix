# lib/default.nix — mkHost and mkHome helper functions
#
# Both helpers auto-inject modules/options.nix so every module has access to
# the myConfig.* cross-cutting values without callers having to list it.
{ inputs }:

let
  inherit (inputs.nixpkgs) lib;
in
{
  # mkHost: wraps nixpkgs.lib.nixosSystem
  # Usage: lib.mkHost { system = "x86_64-linux"; modules = [ ... ]; }
  mkHost =
    { system, modules }:
    lib.nixosSystem {
      inherit system;
      modules = [
        ../modules/options.nix
      ]
      ++ modules;
      specialArgs = { inherit inputs; };
    };

  # mkHome: wraps home-manager.lib.homeManagerConfiguration
  # Usage: lib.mkHome { pkgs = ...; modules = [ ... ]; }
  #
  # Auto-injects nix-flatpak's HM module so any host can use
  # services.flatpak without listing the input explicitly.
  mkHome =
    { pkgs, modules }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../modules/options.nix
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ]
      ++ modules;
      extraSpecialArgs = { inherit inputs; };
    };
}
