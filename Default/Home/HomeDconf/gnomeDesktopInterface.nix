# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # TODO: cursor theme set to Fluent Dark, Serif font use IBM Plex Serif 11, Sans font use IBM Plex Sans 12, Mono font use IBM Plex Mono 11, add adw-gtk3 for legacy apps
      clock-format = "24h"; 
      # cursor-theme = "LatteLightCursors"; # temporarily disabled
      document-font-name = "Noto Serif CJK TC 12.5 @wght=400"; # Serif/Document font # Default pt 11
      enable-hot-corners = false;
      font-name = "IBM Plex Sans 12.5"; # Sans/Interface/Backup font # Default pt 11
      gtk-theme = "Adwaita";
      monospace-font-name = "IBM Plex Mono 12"; # Mono font # default 10
      show-battery-percentage = true;
      text-scaling-factor = 1; 
    };

  };
}
