{ pkgs, ... }: 

{

  home.packages = (with pkgs; [    # User Apps
    audacity
    blender
    chromium
    darktable
    davinci-resolve
    dconf2nix
    discord
    eyedropper
    gdm-settings
    gnome-boxes
    gnome-solanum
    gradience
    libreoffice
    osu-lazer
    steam
    vesktop
    vial
    wordbook

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    # blur-my-shell
    clipboard-indicator
    dash-to-dock
    disable-unredirect-fullscreen-windows # Not needed for PaperWM
    # gsconnect
    hide-top-bar # Incompatible with PaperWM
    launch-new-instance
    # paperwm
    rounded-window-corners-reborn # Incompatible with PaperWM
    # unite
    user-themes
    windownavigator
  ]);
}
