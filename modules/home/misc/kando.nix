# modules/home/misc/kando.nix — kando radial menu daemon
# Moved from system-pkgs (environment.systemPackages) to home in P2 (user override).
# Kando runs as a background daemon triggered via a global hotkey.
# Config files sourced from in-repo copies (kando-config.json, kando-menus.json).
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

    xdg.configFile."kando/config.json".source = ./kando-config.json;
    xdg.configFile."kando/menus.json".source = ./kando-menus.json;
  };
}
