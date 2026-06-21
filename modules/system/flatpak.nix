# modules/system/flatpak.nix — system-level Flatpak enablement
#
# NECESSARY system/home split (NixOS-forced, like gnome and ibus): the SYSTEM half here
# provides the flatpak runtime — the `flatpak` binary, xdg-desktop-portal, the system
# helper, and the /var/lib/flatpak + ~/.local/share/flatpak exports added to
# XDG_DATA_DIRS (so installed apps appear in the launcher). The HOME half
# (modules/home/apps/flatpak-home.nix) only declares the per-user app LIST via the
# nix-flatpak HM module, which installs with `--user` and assumes this service exists
# (its `enable` even defaults to osConfig.services.flatpak.enable). Flatpak therefore
# cannot be home-only; this split is intentional, not scatter.
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
