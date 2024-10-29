# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "" = {
      always-show-input-slider = true;
      create-sink-mixer = false;
      merge-panel = false;
      separate-indicator = false;
      show-current-device = false;
    };

  };
}
