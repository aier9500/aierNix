{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ "<Super>M" ];
    };

    "org/gnome/shell/extensions/copyous" = {
      open-clipboard-dialog-shortcut = [ "<Super>V" ];
      clipboard-history = "keep-all";
      clipboard-position-vertical = "bottom";
    };
  };
}
