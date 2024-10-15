{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    dconf-editor
    drawing
    fastfetch
    gparted
    obs-studio
    protonvpn-gui
    resources
    vscode
    # Non graphical programs
    ffmpeg-full
    gnome-themes-extra # Theming dependency
    gtk-engine-murrine # Theming dependency
    home-manager
    ntfs3g
    python3
    sassc # Theming dependency
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