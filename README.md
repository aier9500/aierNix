# aierNix

Personal NixOS + home-manager flake.

## Per-device hardware config

`default/hardware-configuration.nix` is **git-ignored** — it is machine-specific
(disk UUIDs, ESP mount point, kernel modules) and must be generated on each
device. Do not commit it.

On a fresh machine, before the first build:

```bash
sudo nixos-generate-config --show-hardware-config > default/hardware-configuration.nix
```

This writes the correct `fileSystems` entries and UUIDs for that device.

### EFI mount point

The bootloader (`default/system/system-configs.nix`) uses GRUB with EFI. GRUB
installs to `boot.loader.efi.efiSysMountPoint`, which defaults to `/boot`.

If a device mounts its EFI System Partition at `/boot/efi` instead of `/boot`
(check `findmnt /boot/efi`), set on that device:

```nix
boot.loader.efi.efiSysMountPoint = "/boot/efi";
```

Otherwise `grub-install` fails with `/boot doesn't look like an EFI partition`.

## Build

System:

```bash
sudo nixos-rebuild switch --flake .#default
```

Home-manager:

```bash
home-manager switch --flake .#default
```
