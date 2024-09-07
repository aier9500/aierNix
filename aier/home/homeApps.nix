{ config, pkgs, inputs, ... }: 

{

  home.packages = with pkgs; [

    # User Apps
    libreoffice
    vesktop
    vial
    whatsapp-for-linux
    dconf2nix

    # Creative Suite
    darktable # Lightroom Linux Alt
    davinci-resolve # Premiere Pro Linux Alt
    inkscape # Photoshop/Paint
    
    # Gnome Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.auto-move-windows
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dock-from-dash
    gnomeExtensions.launch-new-instance
    # gnomeExtensions.native-window-placement
    # gnomeExtensions.on-the-top
    gnomeExtensions.search-light
    gnomeExtensions.tiling-assistant
    gnomeExtensions.user-themes
    gnomeExtensions.window-title-is-back
  ];

}