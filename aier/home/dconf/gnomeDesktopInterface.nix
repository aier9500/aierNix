# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # color-scheme = "default";
      cursor-theme = "LatteLightCursors";
      document-font-name = "IBM Plex Serif weight=450 11";
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "IBM Plex Sans 11";
      gtk-theme = "AdwGtk3";
      monospace-font-name = "IBM Plex Mono 10";
      show-battery-percentage = true;
    };

  };
}
