{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    ghostty
    kando
    gparted
    vscode
    ########## Programs ##########
    ffmpeg-full
    home-manager
    ntfs3g
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
