# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "default";
      cursor-theme = "latteLightCursors";
      document-font-name = "Cantarell 11";
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "Cantarell 12";
      gtk-theme = "adw-gtk3";
      monospace-font-name = "Monospace 11";
      show-battery-percentage = true;
    };

  };
}
