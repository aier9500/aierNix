{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      cursor-theme = "Bibata-Original-Ice";
      document-font-name = "IBM Plex Serif 11";
      enable-hot-corners = false;
      font-name = "IBM Plex Sans 11";
      gtk-theme = "Adwaita";
      monospace-font-name = "IBM Plex Mono 11";
      show-battery-percentage = true;
      text-scaling-factor = 1;
    };
  };
}
