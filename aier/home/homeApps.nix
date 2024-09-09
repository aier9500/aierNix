{ config, pkgs, inputs, ... }: 

{

  home.packages = with pkgs; [

    # User Apps
    dconf2nix
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
    gnomeExtensions.auto-move-windows
    gnomeExtensions.clipboard-indicator
    # gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.dock-from-dash
    gnomeExtensions.launch-new-instance
    gnomeExtensions.unite
    gnomeExtensions.user-themes
  ];

}