{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    btrfs-assistant
    dconf-editor
    ghostty
    gnome-boxes
    kando
    gnome-tweaks
    gparted
    proton-vpn
    vscode
    ########## Programs ##########
    dconf2nix
    ffmpeg-full
    home-manager
    ntfs3g
    python3
    usbutils # lsusb etc.
    ########## Other Packages ##########
    adw-gtk3
    bibata-cursors
    ibm-plex
  ];

  programs = {
    
    localsend = {
      enable = true;
      openFirewall = true; 
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = [];
    };
    ########## CLI ##########
    eza = {
      enable = true;
      enableBashIntegration = true;
    };
    fastfetch.enable = true;
    fzf.fuzzyCompletion = true;
    git.enable = true;
    yazi = {
      enable = true;
      enableBashIntegration = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

  };

  virtualisation = {
    libvirtd.enable = true; 
  };
}