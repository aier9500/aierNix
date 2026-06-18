{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-tweaks
    gparted
    protonvpn-gui
    vscode
    # Non graphical programs
    fastfetch
    ffmpeg-full
    home-manager
    ntfs3g
    python3
    usbutils # lsusb etc.
    # Shell wizardry
    eza # Better ls
    fd # Better find
    ripgrep # Better grep
    zoxide # Better cd
  ];

  programs = {
    fzf.fuzzyCompletion = true;
    git.enable = true; 
    htop.enable = true;
    localsend = { # Nearby Share for all
      enable = true;
      openFirewall = true; 
    };
    java.enable = true; 
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = [];
    };
  };

  virtualisation = {
    libvirtd.enable = true; 
    waydroid.enable = true; 
  };
}