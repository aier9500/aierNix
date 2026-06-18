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
    node
    ntfs3g
    python3
    usbutils # lsusb etc.
  ];

  programs = {
    git.enable = true;
    localsend = {
      enable = true;
      openFirewall = true; 
    };
    nautilus-open-any-terminal.enable = true; 
    appimage.enable = true; 
  };

  virtualisation = {
    libvirtd.enable = true; 
  };
}
