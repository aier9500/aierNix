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
    gnome-terminal
    gnome-tweaks
    evince # Document viewer
    loupe # Image viewer
    nautilus # Files
    totem # Videos
    
    # Other Apps
    vscode
    fastfetch
    gparted
    resources
    dconf-editor
    obs-studio

    # Programs
    jdk
    git
    ntfs3g
    home-manager
    tlp
    python3
    
    # Codecs
  ];

}