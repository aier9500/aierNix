{
  config,
  lib,
  ...
}:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      # cursor-theme: GNOME Shell reads this dconf key; home.pointerCursor / stylix.cursor
      # only sets XCURSOR_THEME + GTK cursor — does NOT write this key. No conflict.
      # Same split for fonts: dconf = GNOME Shell, stylix = GTK/X/packages.
      # mkDefault on cursor-theme, font-name, gtk-theme: when stylix targets.gtk is on,
      # the gtk module writes these at normal priority and wins; when off, these defaults
      # apply. document-font-name and monospace-font-name are NOT written by the gtk
      # module, so they stay at normal priority.
      cursor-theme = lib.mkDefault config.stylix.cursor.name;
      document-font-name = "IBM Plex Serif 11";
      enable-hot-corners = false;
      font-name = lib.mkDefault "IBM Plex Sans 11";
      gtk-theme = lib.mkDefault "Adwaita";
      monospace-font-name = "IBM Plex Mono 11";
      show-battery-percentage = true;
      text-scaling-factor = 1;
    };
  };
}
