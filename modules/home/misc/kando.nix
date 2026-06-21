# Kando radial menu daemon — package + autostart only.
#
# Declarative: package and autostart .desktop (enablement, not user config).
#
# Imperative (NOT declared — app/user-owned):
#   - config.json and menus.json: declaring via xdg.configFile would produce a
#     read-only Nix-store symlink, blocking Kando's editor from saving. Build menus
#     in the Kando UI instead.
#   - GNOME Shell integration extension (Wayland global shortcut): install via GNOME
#     Extensions app. Could use gnomeExtensions.kando-integration declaratively, but
#     only from a system module (gnome-shell ignores the standalone HM profile).
# See README "Manual setup (imperative)".
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myHome.kando;
in
{
  options.myHome.kando.enable = lib.mkEnableOption "kando radial menu";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.kando ];

    home.file.".config/autostart/kando.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Kando
      Exec=kando
      X-GNOME-Autostart-enabled=true
      Comment=Kando radial menu daemon
    '';
  };
}
