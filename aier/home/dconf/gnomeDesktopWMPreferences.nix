# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      action-middle-click-titlebar = "minimize";
      button-layout = "close:appmenu";
      num-workspaces = 3;
    };

  };
}
