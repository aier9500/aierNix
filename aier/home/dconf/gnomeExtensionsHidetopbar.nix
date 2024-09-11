# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/hidetopbar" = {
      enable-active-window = false;
      mouse-sensitive = true;
      shortcut-keybind = [ "<Super>q" ];
    };

  };
}
