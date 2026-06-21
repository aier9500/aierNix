# modules/system/solaar.nix — Solaar Logitech device manager
# hardware.logitech.wireless installs Solaar + udev rules; no services.solaar
# exists — Solaar is a per-user tray app.
#
# Device rules (~/.config/solaar/rules.yaml) are imperative: the Solaar GUI
# owns and rewrites that file, so a read-only Nix symlink would break the
# editor. See README "Manual setup (imperative)".
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
    hardware = {
      logitech.wireless.enable = true;
      logitech.wireless.enableGraphical = true;
      # "Key press" rules inject via /dev/uinput on Wayland (user in uinput group — core/users.nix).
      uinput.enable = true;
    };

    # Autostart: equivalent to Solaar's "Start at login" toggle. A read-only
    # Nix symlink in /etc/xdg/autostart is fine for enablement-only config.
    # --window=hide starts minimized to tray.
    environment.etc."xdg/autostart/solaar.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Solaar
      Exec=solaar --window=hide
      X-GNOME-Autostart-enabled=true
      Comment=Solaar Logitech device manager
    '';
  };
}
