# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # color-scheme = "default";
      cursor-theme = "LatteLightCursors";
      document-font-name = "Noto Serif CJK TC @wght=400 11";
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "IBM Plex Sans 11";
      gtk-theme = "AdwGtk3";
      monospace-font-name = "Noto Sans CJK SC @wght=400 10";
      show-battery-percentage = true;
    };

  };
}
