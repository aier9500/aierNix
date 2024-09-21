{ pkgs, ... }: 

{

  home.packages = (with pkgs; [

    # User Apps
    chromium
    dconf2nix
    discord
    gnome-boxes
    gnome-solanum
    libreoffice
    osu-lazer
    steam
    vesktop
    vial

    # Creative Suite
    darktable # Lightroom Linux Alt
    davinci-resolve # Premiere Pro Linux Alt
    inkscape # Photoshop/Paint


  ]) ++ (with pkgs.gnomeExtensions; [

    # Gnome Extensions
    appindicator
    clipboard-indicator
    dash-to-dock
    disable-unredirect-fullscreen-windows
    hide-top-bar
    launch-new-instance
    rounded-window-corners-reborn
    unite
    user-themes

    ]);
    
}