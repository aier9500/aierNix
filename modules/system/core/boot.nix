_:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        gfxmodeBios = "1920x1080";
        gfxmodeEfi = "1920x1080";
        useOSProber = true;
      };
      systemd-boot.enable = false;
    };
    zfs.forceImportRoot = false;
    supportedFilesystems = [
      "btrfs"
      "ext2"
      "ext3"
      "ext4"
      "exfat"
      "f2fs"
      "fat8"
      "fat16"
      "fat32"
      "ntfs"
      "xfs"
      "zfs"
    ];
  };
}
