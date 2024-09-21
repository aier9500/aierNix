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
    # Removing Gnome Utilities
    gnome.core-utilities.enable = false; 
    # Enabling TLP
    power-profile-daemon.enable = false; 
    tlp.enable = true; 
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