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
    # Boot into BTRFS snapshots via GRUB submenu (pairs with snapper above)
    grub-btrfs = {
      enable = true;
    };
  };
  
  # Enabling OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        intel-compute-runtime
    ];
  };

  # Input method: ibus with rime (Cantonese + Simplified Chinese)
  # System side: rime engine is overridden to include both base rime-data and
  # rime-cantonese (provides jyut6ping3 / Cantonese Jyutping schema) and
  # luna-pinyin (bundled in rime-data as luna_pinyin).
  # Home side (separate agent): set the active schema list in
  # ~/.config/ibus/rime/default.custom.yaml (home-manager home.file).
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      (rime.override {
        rimeDataPkgs = [
          pkgs.rime-data
          pkgs.rime-cantonese
        ];
      })
    ];
  };

  programs = {
    nautilus-open-any-terminal.enable = true; 
    appimage.enable = true; 
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-shell-extensions
  ]);
}