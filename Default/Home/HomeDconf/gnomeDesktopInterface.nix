# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "24h"; 
      color-scheme = "default"; # Prefer dark or light
      document-font-name = "Noto Serif CJK TC 11 @wght=400"; # Serif/Document font
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "IBM Plex Sans 11"; # Sans/Interface/Backup font
      monospace-font-name = "IBM Plex Mono 10"; # Mono font
      show-battery-percentage = true;
      text-scaling-factor = 0.85; 
    };

  };
}