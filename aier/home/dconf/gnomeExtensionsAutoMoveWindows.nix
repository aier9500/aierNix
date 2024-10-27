# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [ "vesktop.desktop:1" "ferdium.desktop:1" "org.gnome.Calendar.desktop:1" ];
    };

  };
}
