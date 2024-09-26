{ config, pkgs, inputs, ... }: 

{
	
	# Bootloader.
  boot.loader = {
    
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true; 
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true; 
    };

    systemd-boot.enable = false; 
  };
  
  # Networking 

  networking = {
    hostName = "aierNixOS"; # Define your hostname.
    hostId = "9edbe06b"; 
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Enable networking
    networkmanager.enable = true;
  };

  # Enabling NTFS
  boot.supportedFilesystems = [ "btrfs" "ext2" "ext3" "ext4" "exfat" "f2fs" "fat8" "fat16" "fat32" "ntfs" "xfs" "zfs" ];

  # Enabling Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services = {
    # Enabling Flatpaks
    flatpak.enable = true; 
    # Removing Gnome Core Utilities
    gnome.core-utilities.enable = false; 
    # Enabling power control
    power-profiles-daemon.enable = true; 
    tlp.enable = false; 
  };
  
  # Enabling OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        intel-compute-runtime
    ];
  };

  # Adding Chinese ibus
  i18n.inputMethod = {
    enable = true; 
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
  };

  programs = {
    nautilus-open-any-terminal.enable = true; 

  };

}