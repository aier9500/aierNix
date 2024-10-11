{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    # Gnome Apps
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-console
    gnome-photos
    gnome-text-editor
    gnome-tweaks
    loupe # Image viewer
    nautilus # Files
    totem # Videos
    # Other Apps
    dconf-editor
    drawing
    fastfetch
    gparted
    obs-studio
    protonvpn-gui
    resources
    vscode
    # Programs
    home-manager
    ntfs3g
    python3
    usbutils # lsusb etc.
  ];

  programs = {
    evince.enable = true;
    firefox.enable = true;
    git.enable = true; 
    gnome-terminal.enable = true; 
    localsend = {
      enable = true;
      openFirewall = true; 
    };
    java.enable = true; 
  };
}