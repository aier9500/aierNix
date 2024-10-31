{ pkgs, ... }: 

{

  home.packages = (with pkgs; [    # User Apps
    audacity
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
    lyrebird
    osu-lazer
    steam
    texliveFull
    tetrio-desktop
    vesktop
    vial
    wordbook

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    arcmenu
    # auto-move-windows
    # blur-my-shell
    clipboard-indicator
    dash-to-dock
    disable-unredirect-fullscreen-windows # Not needed for PaperWM
    easyeffects-preset-selector
    hide-top-bar # Incompatible with PaperWM
    launch-new-instance
    # paperwm
    quick-settings-audio-panel
    # rounded-window-corners-reborn # Incompatible with PaperWM
    # unite
    user-themes
    windownavigator
    window-title-is-back
  ]);
  
  services = {
    blanket.enable = true;
    easyeffects.enable = true;
  };

}
