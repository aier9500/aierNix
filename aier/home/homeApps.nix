{ pkgs, ... }: 

{

  home.packages = (with pkgs; [    # User Apps
    audacity
    blanket
    blender
    darktable
    davinci-resolve
    dconf2nix
    discord
    eyedropper
    ferdium
    gdm-settings
    gnome-boxes
    gnome-solanum
    gradience
    hieroglyphic
    krita
    libreoffice
    osu-lazer
    steam
    texliveFull
    tetrio-desktop
    vesktop
    vial
    wordbook

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    # blur-my-shell
    clipboard-indicator
    dash-to-dock
    disable-unredirect-fullscreen-windows # Not needed for PaperWM
    hide-top-bar # Incompatible with PaperWM
    launch-new-instance
    # paperwm
    # rounded-window-corners-reborn # Incompatible with PaperWM
    # unite
    user-themes
    windownavigator
  ]);
}
