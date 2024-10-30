# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/arcmenu" = {
      arcmenu-hotkey = [ "<Alt>space" ];
      menu-button-position-offset = 1;
      menu-layout = "Runner";
      show-activities-button = true;
    };

  };
}
