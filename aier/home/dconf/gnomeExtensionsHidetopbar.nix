# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "" = {
      enable-active-window = false;
      mouse-sensitive = true;
      shortcut-keybind = [ "<Shift><Super>q" ];
    };

  };
}
