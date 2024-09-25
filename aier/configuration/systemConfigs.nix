{ config, pkgs, inputs, ... }: 

{
	
	# Bootloader.
  boot.loader = {
    
    grub = {
      enable = true; 
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true; 
    };

    efi.canTouchEfiVariables = true;
  };
  
  # Enabling NTFS
  boot.supportedFilesystems = {
    ntfs = true; 
  };

  # Enabling Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services = {
    # Enabling Flatpaks
    flatpak.enable = true; 
    # Enabling Fingerprint reading service
    fprintd.enable = true;
    fprintd.tod.enable = true;
    # fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # (If the vfs0090 Driver does not work, use the following driver)
    fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
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