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
    firewalld-gui # Firewall
    loupe # Image viewer
    nautilus # Files
    totem # Videos
    
    # Other Apps
    dconf-editor
    drawing
    fastfetch
    gparted
    obs-studio
    resources
    protonvpn-gui
    vscode

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