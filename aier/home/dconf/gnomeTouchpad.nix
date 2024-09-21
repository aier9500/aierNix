# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "" = {
      send-events = "enabled";
      speed = 0.125;
      two-finger-scrolling-enabled = true;
    };

  };
}
