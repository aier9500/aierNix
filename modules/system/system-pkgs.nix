# modules/system/system-pkgs.nix — core system packages and program enablements
# ghostty remains here (system-level install); vscode and kando moved to home in P2.
{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.ghostty
    pkgs.gparted
    pkgs.ffmpeg-full
    pkgs.home-manager
    pkgs.ntfs3g
    pkgs.usbutils
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
}
