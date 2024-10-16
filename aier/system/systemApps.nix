{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    bottles
    dconf-editor
    drawing
    fastfetch
    gnome-tweaks
    gparted
    handbrake
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
    zoxide
  ];

  programs = {
    adb.enable = true; 
    droidcam.enable = true; 
    evince.enable = true;
    fzf.fuzzyCompletion = true; 
    git.enable = true; 
    gnome-terminal.enable = true; 
    localsend = {
      enable = true;
      openFirewall = true; 
    };
    java.enable = true; 
    obs-studio = {
      enable = true;
      enableVirtualCamera = true; 
      plugins = [
        pkgs.obs-studio-plugins.droidcam-obs
      ];
    };
  };
}