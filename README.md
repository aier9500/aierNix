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

### Convenience script

`scripts/gen-hardware-config.sh` is a thin wrapper around the manual command
above. It resolves the repo root automatically (works from any directory),
backs up any existing `hardware-configuration.nix` to
`hardware-configuration.nix.bak` before overwriting, and prints the same
ESP / bootloader checklist described below.

```bash
# Make executable once, then run from anywhere:
chmod +x scripts/gen-hardware-config.sh
./scripts/gen-hardware-config.sh
```

The manual `nixos-generate-config` command and the bootloader notes below
remain the authoritative reference; the script just saves the copy-paste.

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

## Setup

Clone the repo to **exactly** `~/.dotfiles/aierNix` — the shell aliases `homesw` and `sysw` hard-code that path:

```bash
git clone <repo-url> ~/.dotfiles/aierNix
cd ~/.dotfiles/aierNix
```

## Build

System:

```bash
sudo nixos-rebuild switch --flake .#default
```

Home-manager:

```bash
home-manager switch --flake .#default
```

## Notes & tips

### Command cheatsheet

| Alias   | Command                                          | Description                                                     |
|---------|--------------------------------------------------|-----------------------------------------------------------------|
| `homesw` | `cd ~/.dotfiles/aierNix && home-manager switch --flake .#default` | Switch home-manager generation (user config only). |
| `sysw`  | `cd ~/.dotfiles/aierNix && sudo nixos-rebuild switch --flake .#default` | Rebuild and switch the NixOS system generation. |

> **Note:** `homesw` and `sysw` both `cd` to `~/.dotfiles/aierNix`. If the repo lives anywhere else these aliases will fail — see [Setup](#setup) above.
| `nixse` | `nix search nixpkgs <query>`                     | Search nixpkgs for a package by name or keyword.               |
