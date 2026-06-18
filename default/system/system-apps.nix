{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-tweaks
    gparted
    protonvpn-gui
    vscode
    ########## Programs ##########
    ffmpeg-full
    home-manager
    ntfs3g
    python3
    usbutils # lsusb etc.
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
    fzf.fuzzyCompletion = true;
    git.enable = true;
    eza = {
      enable = true;
      enableBashIntegration = true;
    };
    fastfetch = {
      enable = true;
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