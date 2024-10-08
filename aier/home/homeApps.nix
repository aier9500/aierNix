{ pkgs, ... }: 

{

  home.packages = (with pkgs; [    # User Apps
    blender
    chromium
    dconf2nix
    discord
    gnome-boxes
    gnome-solanum
    gradience
    libreoffice
    osu-lazer
    steam
    vesktop
    vial
    # Creative Suite
    darktable # Lightroom Alt
    davinci-resolve # Premiere Alt
    # inkscape # Photoshop/Paint

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    blur-my-shell
    clipboard-indicator
    dash-to-dock
    # disable-unredirect-fullscreen-windows # Not needed for PaperWM
    # hide-top-bar # Not needed for PaperWM
    launch-new-instance
    paperwm
    # rounded-window-corners-reborn # Incompatible with PaperWM
    unite
    user-themes
    windownavigator
  ]);
}
