# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      calculator = [ "<Super>c" ];
      control-center = [ "<Super>i" ];
      # custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" ];
      help = [];
      home = [ "<Super>e" ];
      magnifier = [ "<Super>z" ];
      magnifier-zoom-in = [ "<Super>equal" ];
      magnifier-zoom-out = [ "<Super>minus" ];
      mic-mute = [ "F8" ];
      rotate-video-lock-static = [];
      screenreader = [];
      www = [ "<Super>b" ];
    };

    "custom-keybindings/custom0" = {
      binding = "<Control><Super>Delete";
      command = "gnome-session-quit";
      name = "gnome-session-quit";
    };

    "custom-keybindings/custom1" = {
      binding = "<Shift><Super>r";
      command = "gnome-terminal";
      name = "gnome-terminal";
    };

    "custom-keybindings/custom2" = {
      binding = "<Super>t";
      command = "gnome-text-editor";
      name = "gnome-text-editor";
    };

    "custom-keybindings/custom3" = {
      binding = "<Shift><Control>Escape";
      command = "resources";
      name = "resources";
    };

    "custom-keybindings/custom4" = {
      binding = "<Shift><Control><Alt>r";
      command = "obs";
      name = "obs";
    };

  };
}
