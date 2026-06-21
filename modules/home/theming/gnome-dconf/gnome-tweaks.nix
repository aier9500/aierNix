_:

{
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    # Fractional-scaling — required for correct per-monitor scaling under Wayland.
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
}
