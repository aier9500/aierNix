# system — NixOS system-level configuration

This directory holds all NixOS system-level (root-owned) configuration for the `aierNix` flake. It is imported by [`../imports/system-imports.nix`](../imports/system-imports.nix), which is itself pulled into the top-level [`../configuration.nix`](../configuration.nix). Nothing in this directory manages user-space or home-manager options — those live in `../home/`.

---

## Directory Structure

```
system/
├── system-apps.nix          # System packages, programs.*, and virtualisation
├── system-configs.nix       # Boot, filesystems, services, hardware, i18n/input
├── system-modules.nix       # Aggregator: imports all files under system-modules/
└── system-modules/
    ├── system-keyd.nix      # keyd keyboard remapping daemon
    └── system-solaar.nix    # Solaar daemon for Logitech peripherals
```

> `hardware-configuration.nix` is **not** stored here — it is per-device but **tracked** (flakes only copy git-tracked files). It lives at `../hardware-configuration.nix` and is imported directly by `../configuration.nix`. See the project root README for how to regenerate + `git add` it per machine.

---

## How the files are loaded

```
configuration.nix
└── imports/system-imports.nix
    ├── system/system-modules.nix   → system-modules/system-keyd.nix
    │                               → system-modules/system-solaar.nix
    ├── system/system-apps.nix
    └── system/system-configs.nix
```

`system-modules.nix` is a thin aggregator whose only job is to `imports` everything under `system-modules/`. Add new system-scoped service modules there rather than directly in `system-imports.nix`.

---

## Key Files

### [`system-apps.nix`](./system-apps.nix)
Declares all system-wide software.

| Section | What it does |
|---|---|
| `environment.systemPackages` | GUI tools (Ghostty, GNOME Boxes, GParted, VSCode, Kando, ProtonVPN…), CLI utilities (ffmpeg, python3, usbutils, ntfs3g), theming assets (adw-gtk3, bibata-cursors, IBM Plex fonts) |
| `programs.*` | LocalSend (with firewall rule), OBS Studio (virtual camera enabled), eza, fastfetch, fzf, git, yazi, zoxide — all with Bash integration where applicable |
| `virtualisation` | Enables `libvirtd` (QEMU/KVM, pairs with `gnome-boxes`) |

### [`system-configs.nix`](./system-configs.nix)
Handles all system-level configuration that is not about installed software.

| Section | Details |
|---|---|
| **Bootloader** | GRUB (EFI, OSProber, 1920×1080, Catppuccin theme); `systemd-boot` explicitly disabled |
| **Filesystems** | btrfs, ext2/3/4, exfat, f2fs, fat variants, ntfs, xfs, zfs all declared in `boot.supportedFilesystems` |
| **Nix settings** | `nix-command` and `flakes` experimental features enabled |
| **Services** | Flatpak, `power-profiles-daemon` (TLP disabled), Snapper BTRFS snapshots for `/` (hourly×5, daily×7, weekly×2, monthly×2), `grub-btrfs` for snapshot boot entries |
| **Graphics** | `hardware.graphics` with 32-bit support and `intel-compute-runtime` extra package |
| **Input method** | iBus + Rime, overridden to bundle both `rime-data` (luna-pinyin) and `rime-cantonese` (jyut6ping3 / Jyutping). Schema selection is handled on the home-manager side via `~/.config/ibus/rime/default.custom.yaml`. |
| **GNOME extras** | `nautilus-open-any-terminal` and AppImage support enabled; `gnome-shell-extensions` excluded from default GNOME packages |

### [`system-modules/system-keyd.nix`](./system-modules/system-keyd.nix)
Enables the `keyd` keyboard remapping daemon with a global (`ids = ["*"]`) profile:
- `capslock` → `backspace`
- `leftshift+rightshift` → `capslock` (restore when needed)
- `leftshift+leftmeta+f23` → `layer(control)` (Colemak-compatible modifier chord)

### [`system-modules/system-solaar.nix`](./system-modules/system-solaar.nix)
Enables Solaar for Logitech Unifying/Bolt receiver management. Window starts hidden (`window = "hide"`).

---

## Conventions

- **One concern per file** at the top level (`-apps`, `-configs`). Use `system-modules/` for self-contained services that have their own `services.<name>` block.
- New service modules go in `system-modules/` and are registered in `system-modules.nix` — not directly in `system-imports.nix`.
- User-space programs, dotfiles, and shell configuration belong in `../home/`, not here.
- The `inputs` flake argument is threaded through `system-configs.nix` (used for iBus/Rime override) — new files that need flake inputs must declare `{ config, pkgs, inputs, ... }`.

---

## Dependencies & Relationships

| Direction | Target |
|---|---|
| Imported by | [`../imports/system-imports.nix`](../imports/system-imports.nix) → [`../configuration.nix`](../configuration.nix) |
| Sibling | [`../home/`](../home/) — home-manager user configuration (separate agent) |
| Per-device input | [`../hardware-configuration.nix`](../hardware-configuration.nix) — **tracked**, regenerated per machine by `nixos-generate-config` |

---

## Notes

- `tlp.enable = false` is explicit — `power-profiles-daemon` and TLP conflict; only one should be active.
- Snapper is configured for user `aier` only. The `grub-btrfs` service scans for snapshots and adds a GRUB submenu automatically on rebuild.
- The iBus/Rime split (system = engine + data packages, home = schema list) means changing active input schemas only requires a home-manager switch, not a full system rebuild.
