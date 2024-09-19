# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # color-scheme = "default";
      cursor-theme = "LatteLightCursors";
      document-font-name = "Noto Serif CJK TC @wght=400 11"; # Serif/Document
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "Noto Sans CJK SC @wght=400 11"; # Sans/Interface
      gtk-theme = "AdwGtk3";
      monospace-font-name = "IBM Plex Mono 10"; # Mono
      show-battery-percentage = true;
    };

  };
}
