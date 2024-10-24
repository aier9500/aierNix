{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    annotator
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
    ffmpeg-full
    gnome-themes-extra # Theming dependency
    gtk-engine-murrine # Theming dependency
    home-manager
    ntfs3g
    python3
    sassc # Theming dependency
    usbutils # lsusb etc.
    # Shell wizardry
    eza # Better ls
    fd # Better find
    ripgrep # Better grep
    zoxide # Better cd
  ];

  programs = {
    adb.enable = true; # Android USB Debugging
    droidcam.enable = true; 
    fzf.fuzzyCompletion = true;
    git.enable = true; 
    localsend = { # Nearby Share for all
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