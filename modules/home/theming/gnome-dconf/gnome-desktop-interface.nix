{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      # cursor-theme: GNOME Shell reads this dconf key exclusively.
      # home.pointerCursor (set by stylix.cursor) does NOT write this dconf key —
      # it only sets XCURSOR_THEME env var, ~/.icons symlink, and GTK cursor.
      # So this key and stylix.cursor coexist without conflict.
      # Parallel to how font-name/document-font-name/monospace-font-name work here
      # alongside stylix.fonts: dconf = GNOME Shell; stylix = GTK/X/packages.
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
