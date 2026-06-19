# modules/home/misc/kando.nix — kando radial menu daemon
# Moved from system-pkgs (environment.systemPackages) to home in P2 (user override).
# Kando runs as a background daemon triggered via a global hotkey.
#
# DECLARATIVE here:
#   - the kando package (user-space daemon);
#   - the autostart .desktop — enablement (guarantees the daemon launches at
#     login), not user-editable config, so the read-only Nix-store symlink is fine.
#
# IMPERATIVE (deliberately NOT declared — owned by the app / the user):
#   - config.json (settings + hotkey) and menus.json (pie definitions): an
#     `xdg.configFile.…source` link is a read-only Nix-store symlink, so Kando's
#     editor cannot save to it. Build the menus in the Kando settings UI.
#   - the GNOME Shell integration extension (needed on Wayland to bind the global
#     shortcut): install + enable it via the GNOME Extensions app. It is
#     version-matched in nixpkgs (`gnomeExtensions.kando-integration`) and could be
#     installed declaratively, but only from a system module — gnome-shell does not
#     scan the standalone home-manager profile — which was declined to keep the
#     system config lean (DESIGN.md L8).
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
