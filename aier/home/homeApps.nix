{ config, pkgs, inputs, ... }: 

{

  home.packages = with pkgs; [

    # User Apps
    chromium
    dconf2nix
    gnome-boxes
    libreoffice
    microsoft-edge
    osu-lazer
    vesktop
    vial

    # Creative Suite
    darktable # Lightroom Linux Alt
    davinci-resolve # Premiere Pro Linux Alt
    inkscape # Photoshop/Paint

    
    # Gnome Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.disable-unredirect-fullscreen-windows
    gnomeExtensions.hide-top-bar
    gnomeExtensions.launch-new-instance
    gnomeExtensions.unite
    gnomeExtensions.user-themes
  ];

}