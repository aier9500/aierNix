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
      # cursor-theme: GNOME Shell reads this dconf key exclusively.
      # home.pointerCursor (set by stylix.cursor) does NOT write this dconf key —
      # it only sets XCURSOR_THEME env var, ~/.icons symlink, and GTK cursor.
      # So this key and stylix.cursor coexist without conflict.
      # Parallel to how font-name/document-font-name/monospace-font-name work here
      # alongside stylix.fonts: dconf = GNOME Shell; stylix = GTK/X/packages.
      # mkDefault on the three keys the Stylix GTK target also writes
      # (cursor-theme, font-name, gtk-theme): when a colourful theme with
      # targets.gtk = true is active, home-manager's gtk module sets these
      # at normal priority and wins; when gtk target is off (vanilla), these
      # defaults apply unchanged. document-font-name/monospace-font-name are
      # NOT written by the gtk module, so they stay at normal priority.
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
