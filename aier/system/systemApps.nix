{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    bottles
    dconf-editor
    gnome-tweaks
    gparted
    handbrake
    protonvpn-gui
    resources
    vscode
    # Non graphical programs
    fastfetch
    fd
    ffmpeg-full
    gnome-themes-extra # Theming dependency
    gtk-engine-murrine # Theming dependency
    home-manager
    ntfs3g
    python3
    ripgrep
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

  virtualisation.waydroid.enable = true; 
}