# modules/system/solaar.nix — Solaar Logitech device manager + udev rules
# hardware.logitech.wireless installs Solaar and registers udev rules system-wide.
# There is no services.solaar — Solaar runs as a per-user tray app, not a daemon.
#
# This is the ONLY Solaar config. Device rules (~/.config/solaar/rules.yaml) are
# IMPERATIVE: owned and rewritten by the Solaar GUI rule editor, so they are not
# declared here. A declarative symlink would be read-only and block the editor.
# See README "Manual setup (imperative)".
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
