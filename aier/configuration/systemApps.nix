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
    dconf-editor
    fastfetch
    gparted
    obs-studio
    resources
    protonvpn-gui
    vscode
    # flameshot

    # Programs
    git
    home-manager
    jdk
    ntfs3g
    python3
    tlp
    
    # Codecs
  ];

}