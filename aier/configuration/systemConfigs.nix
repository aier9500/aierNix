{ config, pkgs, inputs, ... }: 

{
	
	# Bootloader.
  boot.loader.grub.enable = true; 
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true; 
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Enabling Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Removing Gnome Utilities
  services.gnome.core-utilities.enable = false; 

  # Enabling NTFS
  boot.supportedFilesystems = {
    ntfs = true; 
  };

  # Enabling OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        intel-compute-runtime
    ];
  };

  # Adding v4l2loopback for virtual camera
  boot.kernelModules = [ "kvm-intel" "hid-nintendo" "v4l2loopback" ];

  # Enabling Flatpak
  services.flatpak.enable = true;

  # Enabling Fcitx5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
    ];
  };

}