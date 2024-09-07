# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "" = {
      action-middle-click-titlebar = "minimize";
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
    };

  };
}
