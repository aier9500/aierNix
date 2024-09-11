{ config, pkgs, inputs, ... }: 

{

  home.packages = with pkgs; [

    # User Apps
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
    
    # programs
    sassc

    
    # Gnome Extensions
    gnomeExtensions.appindicator
    # gnomeExtensions.auto-move-windows
    gnomeExtensions.clipboard-indicator
    # gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.dash-to-dock
    gnomeExtensions.disable-unredirect-fullscreen-windows
    gnomeExtensions.hide-top-bar
    gnomeExtensions.launch-new-instance
    gnomeExtensions.unite
    gnomeExtensions.user-themes
  ];

}