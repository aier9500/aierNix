# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/dash-to-dock" = {
      background-opacity = 0.8;
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      height-fraction = 0.9;
      hotkeys-overlay = true;
      hotkeys-show-dock = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      shortcut = [ "<Shift><Super>q" ];
      shortcut-text = "<Shift><Super>q";
      shortcut-timeout = 2.0;
    };

  };
}
