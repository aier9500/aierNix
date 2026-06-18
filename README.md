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

### Bootloader is machine-specific too

The committed config (`default/system/system-configs.nix`) sets up GRUB with EFI
and **defaults the EFI partition mount point to `/boot`**. Where the EFI System
Partition (ESP) actually lives is a hardware fact — like disk UUIDs — so any
per-device override belongs in this machine's git-ignored
`hardware-configuration.nix`, **not** in the committed files. That keeps the repo
portable: clone → generate hardware config → (maybe add one line) → build.

`nixos-generate-config` writes `fileSystems` but does **not** write
`boot.loader.efi.efiSysMountPoint`. So after generating, check where this machine
mounts its ESP:

```bash
findmnt /boot /boot/efi
lsblk -f
```

Then, in `default/hardware-configuration.nix`, handle the case that matches:

- **ESP mounted at `/boot`** (default): add nothing. Works as-is.
- **ESP mounted at `/boot/efi`** (separate ESP): add
  ```nix
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  ```
  Otherwise `grub-install` fails with `/boot doesn't look like an EFI partition`.
- **Single partition / no separate ESP (e.g. a BIOS/legacy-boot VM):** the
  machine is not EFI-booting at all. EFI GRUB cannot install. Either give the VM
  firmware an EFI ESP, or switch that device to BIOS GRUB by setting in its
  `hardware-configuration.nix`:
  ```nix
  boot.loader.grub.efiSupport = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.devices = lib.mkForce [ "/dev/vda" ];  # whole disk
  ```
  `lib.mkForce` is required: the committed config already sets these (e.g.
  `efiSupport = true`, `devices = [ "nodev" ]`), and two equal-priority
  definitions error out — `mkForce` makes the per-device value win. Ensure `lib`
  is in the file's argument set (`{ config, lib, pkgs, ... }:`). Confirm the disk
  name with `lsblk` — often `/dev/vda` or `/dev/sda` in a VM.

## Build

System:

```bash
sudo nixos-rebuild switch --flake .#default
```

Home-manager:

```bash
home-manager switch --flake .#default
```
