# modules/home/apps/flatpak-home.nix — flatpak user packages via nix-flatpak
# The nix-flatpak HM module is injected by mkHome (lib/default.nix).
# System-level flatpak enablement is handled by modules/system/flatpak.nix.
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
        "app.zen_browser.zen"
        "be.alexandervanhee.gradia"
        "com.bitwarden.desktop"
        "com.github.tchx84.Flatseal"
        "com.mattjakeman.ExtensionManager"
        "io.github.seadve.Kooha"
        "io.github.zarestia_dev.rclone-manager"
        "io.missioncenter.MissionCenter"
        "md.obsidian.Obsidian"
      ];
    };
  };
}
