{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.desktop.gnome;
in
{
  options.mySystem.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop with GDM";

  config = lib.mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = [
      pkgs.gnome-shell-extensions
    ];
  };
}
