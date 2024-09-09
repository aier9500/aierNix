{ config, pkgs, inputs, ... }: 

{

  home.packages = with pkgs; [

    # User Apps
    libreoffice
    vesktop
    vial
    whatsapp-for-linux
    dconf2nix
    microsoft-edge

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
    gnomeExtensions.forge
    gnomeExtensions.launch-new-instance
    gnomeExtensions.search-light
    gnomeExtensions.tiling-assistant
    gnomeExtensions.unite
    gnomeExtensions.user-themes
  ];

}