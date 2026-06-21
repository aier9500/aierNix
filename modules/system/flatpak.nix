# modules/system/flatpak.nix — system-level Flatpak enablement
#
# NixOS requires a system/home split: this module provides the Flatpak runtime
# (binary, xdg-desktop-portal, system helper, XDG_DATA_DIRS exports). The home
# half (modules/home/apps/flatpak-home.nix) declares only the per-user app list
# via nix-flatpak, which installs with --user and depends on this service.
# Flatpak cannot be home-only — the split is intentional.
{ config, lib, ... }:
let
  cfg = config.mySystem.flatpak;
in
{
  options.mySystem.flatpak.enable = lib.mkEnableOption "Flatpak system service";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
