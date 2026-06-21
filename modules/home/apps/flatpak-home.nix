# modules/home/apps/flatpak-home.nix — per-user flatpak app list (via nix-flatpak)
# Requires modules/system/flatpak.nix — flatpak cannot be home-only.
# Keep apps here only when absent from nixpkgs or when the sandbox is preferable.
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
