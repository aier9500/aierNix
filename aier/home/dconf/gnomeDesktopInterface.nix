# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  # The shell theme is not set declaratively
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "24h"; 
      color-scheme = "default"; # Prefer dark or light
      cursor-theme = "LatteLightCursors";
      document-font-name = "Noto Serif CJK TC 11 @wght=400"; # Serif/Document
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "IBM Plex Sans 11"; # Sans/Interface
      # gtk-theme = "AdwGtk3";
      monospace-font-name = "IBM Plex Mono 10"; # Mono
      show-battery-percentage = true;
      text-scaling-factor = 0.87; 
    };

  };
}
