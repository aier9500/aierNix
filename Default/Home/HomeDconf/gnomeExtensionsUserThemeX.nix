# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/user-theme-x" = {
      name = "MarbleBlueLight";
      x-cursor = "LatteLightCursors";
      x-cursor-night = "LatteLightCursors";
      x-gtk = "AdwGtk3";
      x-gtk-night = "AdwGtk3";
      x-shell = "MarbleBlueLight";
      x-shell-night = "MarbleBlueDark";
    };

  };
}
