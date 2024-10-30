# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/arcmenu" = {
      arcmenu-hotkey = [ "<Alt>space" ];
      highlight-result-terms = true; 
      menu-button-position-offset = 1;
      menu-layout = "Runner";
      search-provider-open-windows = true; 
      search-provider-recent-files = true;
      show-activities-button = true;
      show-search-result-details = true;
    };

  };
}
