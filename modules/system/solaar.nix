# modules/system/solaar.nix — Solaar Logitech device manager + udev rules
# hardware.logitech.wireless installs Solaar and registers udev rules system-wide.
# There is no services.solaar — Solaar runs as a per-user tray app, not a daemon.
{
  config,
  lib,
  ...
}:
let
  cfg = config.mySystem.solaar;
in
{
  options.mySystem.solaar.enable = lib.mkEnableOption "Solaar (Logitech device manager) + udev rules";

  config = lib.mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
  };
}
