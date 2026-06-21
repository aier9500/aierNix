# modules/home/apps/flatpak-home.nix — flatpak user packages via nix-flatpak
#
# HOME half of a NECESSARY system/home split (see modules/system/flatpak.nix for why
# flatpak cannot be home-only). This module only declares the per-user app LIST; the
# nix-flatpak HM module (injected by mkHome in lib/default.nix) installs them with
# `--user` and rides on the system flatpak runtime enabled in modules/system/flatpak.nix.
#
# Apps stay here only when they are not in nixpkgs, or when flatpak's sandbox /
# bundled runtime is preferable (e.g. Bitwarden, whose nixpkgs build needs an
# insecure electron). Flatpak is a bridge, not a destination (DESIGN.md
# minimize-policy); everything cleanly packaged was migrated to home.packages
# (modules/home/apps/home-pkgs.nix) on 2026-06-19.
{ config, lib, ... }:
let
  cfg = config.myHome.apps.flatpak;
in
{
  options.myHome.apps.flatpak.enable = lib.mkEnableOption "flatpak user packages";

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "app.zen_browser.zen" # not in nixpkgs; browser sandboxing desirable (DESIGN-locked)
        "com.bitwarden.desktop" # nixpkgs bitwarden-desktop needs insecure electron-39.8.10; sandbox preferred for a secrets app
        "com.github.tchx84.Flatseal" # not in nixpkgs; manages flatpak permissions
        "io.github.zarestia_dev.rclone-manager" # not in nixpkgs
      ];
    };
  };
}
