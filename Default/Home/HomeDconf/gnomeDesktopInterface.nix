# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "24h"; 
      color-scheme = "default"; # Prefer dark or light
      # cursor-theme = "LatteLightCursors"; # temporarily disabled
      document-font-name = "Noto Serif CJK TC 13 @wght=400"; # Serif/Document font # Default pt 11
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "IBM Plex Sans 13"; # Sans/Interface/Backup font # Default pt 11
      gtk-theme = "AdwGtk3";
      monospace-font-name = "IBM Plex Mono 13"; # Mono font # default 10
      show-battery-percentage = true;
      text-scaling-factor = 1; 
    };

  };
}
