{ config, pkgs, inputs, ... }:

{

	########## Bootloader ##########
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true; 
      gfxmodeBios = "1920x1080";
      gfxmodeEfi = "1920x1080";
      theme = "${pkgs.catppuccin-grub}";
      useOSProber = true; 
    };
    systemd-boot.enable = false; 
  };

  boot.zfs.forceImportRoot = false; 

  ########## Supported Filesystems ##########
  boot.supportedFilesystems = [ "btrfs" "ext2" "ext3" "ext4" "exfat" "f2fs" "fat8" "fat16" "fat32" "ntfs" "xfs" "zfs" ];

  ########## Enabling Flakes ##########
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services = {
    # Enabling Flatpak
    flatpak.enable = true;
    # Enabling power control
    power-profiles-daemon.enable = true;
    tlp.enable = false;
    # BTRFS timeline snapshots
    snapper = {
      configs.root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "aier" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 2;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };

  ########## Exclude default Gnome extensions ##########
  environment.gnome.excludePackages = (with pkgs; [
    gnome-shell-extensions
  ]);
}
