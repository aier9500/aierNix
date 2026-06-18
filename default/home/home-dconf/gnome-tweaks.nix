{ ... }:

{
  dconf.settings = {
    # Titlebar buttons — show minimize + maximize to the left of close
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };

    # Allow desktop volume to be amplified above 100% (at the cost of distortion)
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    # Fractional-scaling flag — required for some apps to scale correctly
    # under Wayland (see Gnome guide "Enable Fractional Scaling Flag").
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
}
