# aierNix

Personal NixOS + home-manager flake.

---

## Install on a fresh machine

Run each step in order, top to bottom.

### 1. Get `git`

A fresh NixOS install has no `git`. Drop into a temporary shell that has it:

```bash
nix-shell -p git
```

Stay in this shell for the next steps. It vanishes when you `exit` — `git`
becomes permanent once you build the config below.

### 2. Turn on flakes for this terminal

This repo is a **flake**. Flakes are still an "experimental" Nix feature and are
**off by default** on a fresh system. The config you are about to build turns
them on permanently — but the first few commands run *before* that, so switch
them on just for this terminal:

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
```

Now every `nix` and `nixos-rebuild` command in this terminal understands flakes.
After the first build (step 6) flakes are on system-wide and you never set this
again. (If you prefer, add `--experimental-features 'nix-command flakes'` to each
command instead of exporting it.)

### 3. Clone the repo

Clone to **exactly** `~/.dotfiles/aierNix` — the `homesw` / `sysw` aliases
hard-code that path.

```bash
git clone <repo-url> ~/.dotfiles/aierNix
cd ~/.dotfiles/aierNix
```

### 4. Generate this machine's hardware config

Every machine has different disks, so each needs its own
`hardware-configuration.nix`. The helper script generates it (and backs up any
existing one, then prints a bootloader checklist):

```bash
chmod +x scripts/gen-hardware-config.sh
./scripts/gen-hardware-config.sh
```

Read the notes it prints. If your `/boot` is unusual, see
[Bootloader notes](#bootloader-notes) below.

### 5. Let the flake see the new file

Nix flakes only read files that **git tracks**. The file you just generated is
brand new and untracked, so the build can't see it yet. Stage it (no commit
needed yet):

```bash
git add default/hardware-configuration.nix
```

### 6. Update inputs, then build the system

```bash
nix flake update          # pull latest pinned versions
sudo nixos-rebuild switch --flake .#default
```

This first build enables flakes permanently, so plain commands work from now on.

### 7. Build your home-manager config

```bash
home-manager switch --flake .#default
```

### 8. Save this machine's hardware config

```bash
git commit -m "hardware-config for <this machine>"
```

Done. Reboot if the build changed the bootloader or kernel.

---

## Per-device hardware config

`default/hardware-configuration.nix` is machine-specific (disk UUIDs, ESP mount
point, kernel modules). Two things to know:

- **It is tracked in git, not ignored.** Flakes copy only git-tracked files, so
  ignoring it would break the build with a "file not found" error. Always
  `git add` it after generating (step 5).
- **One machine at a time.** This repo keeps a single
  `default/hardware-configuration.nix`. On each new device you regenerate it and
  commit — the new config replaces the old one in history. Fine for one device at
  a time. For two devices at once, switch to per-host folders
  (`hosts/<hostname>/hardware-configuration.nix`) — see ROADMAP open question 3.

Without the script, the raw command is:

```bash
sudo nixos-generate-config --show-hardware-config > default/hardware-configuration.nix
```

### Bootloader notes

The committed config (`default/system/system-configs.nix`) uses GRUB with EFI and
defaults the EFI partition mount point to `/boot`. Where the EFI System Partition
(ESP) actually lives is a hardware fact, so any override goes in this machine's
`hardware-configuration.nix`, **not** the shared modules.

`nixos-generate-config` writes `fileSystems` but **not**
`boot.loader.efi.efiSysMountPoint`. So after generating, check where the ESP is:

```bash
findmnt /boot /boot/efi
lsblk -f
```

Then handle the case that matches in `default/hardware-configuration.nix`:

- **ESP at `/boot`** (default): add nothing. Works as-is.
- **ESP at `/boot/efi`** (separate ESP): add
  ```nix
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  ```
  Otherwise `grub-install` fails with `/boot doesn't look like an EFI partition`.
- **No EFI / BIOS-only (e.g. a legacy-boot VM):** the machine is not EFI-booting,
  so EFI GRUB cannot install. Either give the VM an EFI ESP, or switch that device
  to BIOS GRUB in its `hardware-configuration.nix`:
  ```nix
  boot.loader.grub.efiSupport = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.devices = lib.mkForce [ "/dev/vda" ];  # whole disk
  ```
  `lib.mkForce` is required because the committed config already sets these
  (`efiSupport = true`, `devices = [ "nodev" ]`) and two equal-priority values
  error out. Make sure `lib` is in the file's arguments
  (`{ config, lib, pkgs, ... }:`). Confirm the disk with `lsblk` — often
  `/dev/vda` or `/dev/sda` in a VM.

---

## Day-to-day

Once installed, these aliases rebuild from `~/.dotfiles/aierNix`:

| Alias   | Command                                                                  | What it does                                  |
|---------|--------------------------------------------------------------------------|-----------------------------------------------|
| `sysw`  | `cd ~/.dotfiles/aierNix && sudo nixos-rebuild switch --flake .#default`   | Rebuild + switch the **system** generation.   |
| `homesw`| `cd ~/.dotfiles/aierNix && home-manager switch --flake .#default`         | Switch the **home-manager** (user) config.    |
| `nixse` | `nix search nixpkgs <query>`                                             | Search nixpkgs for a package.                 |

> `homesw` and `sysw` both `cd` to `~/.dotfiles/aierNix`. If the repo lives
> anywhere else they fail — clone to that exact path (install step 3).
