{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ "<Super>M" ];
    };
  };
}
