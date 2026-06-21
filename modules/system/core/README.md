# core — Always-On NixOS System Essentials

These four modules are imported unconditionally by `hosts/aierNixOS/default.nix`. They
have no enable toggle and carry no optional logic — removing any of them would leave the
machine unbootable or unusable. They are the minimum viable NixOS baseline that every
host in the aierNix flake must have.

This directory is one sub-layer of [`modules/system/`](../README.md), which also
contains the feature-toggle modules (keyd, flatpak, snapper, etc.) that are silent until
the host enables them.

---

## Directory Structure

```
modules/system/core/
├── boot.nix        # GRUB/EFI bootloader, filesystem support list
├── locale.nix      # UK baseline locale + automatic timezone
├── networking.nix  # Hostname, hostId, NetworkManager
└── users.nix       # User account (aier) and group memberships
```

---

## Module Reference

### [`boot.nix`](./boot.nix)

Configures the bootloader and kernel filesystem support.

| Setting | Value |
|---|---|
| Bootloader | GRUB (EFI mode); `systemd-boot` explicitly disabled |
| EFI | `canTouchEfiVariables = true` |
| OS Prober | `useOSProber = true` — detects Windows/other OSes for dual-boot |
| Graphics mode | `1920x1080` for both BIOS and EFI GRUB stages |
| Filesystems | btrfs, ext2/3/4, exfat, f2fs, fat8/16/32, ntfs, xfs, zfs |
| ZFS | `forceImportRoot = false` |

No Catppuccin theme or other visual configuration is set here — that lives outside core
if added.

---

### [`locale.nix`](./locale.nix) — shared UK baseline

Sets the system-wide locale baseline and automatic timezone detection. All machines using
this module default to British English conventions: metric measurements, A4 paper, GBP
currency, DD/MM/YYYY dates.

| Setting | Value |
|---|---|
| Default locale | `en_GB.UTF-8` |
| All `LC_*` categories | `en_GB.UTF-8` (explicit, so overrides are clear) |
| Timezone | Detected automatically at runtime via `automatic-timezoned` (geoclue2); `time.timeZone` is **not** set |
| Generated locales | `C.UTF-8`, `en_GB.UTF-8`, `en_US.UTF-8`, `en_DK.UTF-8` |

`en_US` and `en_DK` are generated here specifically to back host-level overrides — they
are not active by default.

**Host-specific deviations** go in a separate host file, not here. The aierNixOS machine
deviates from the UK baseline in [`hosts/aierNixOS/locale.nix`](../../../hosts/aierNixOS/locale.nix),
which uses `lib.mkForce` to override two categories:

| Category | Override | Reason |
|---|---|---|
| `LC_TIME` | `en_DK.UTF-8` | ISO-8601 dates (2026-06-20) and 24-hour clock |
| `LC_MONETARY` | `en_US.UTF-8` | Currency in USD ($) rather than GBP (£) |

These overrides are applied at the system layer (writing to `/etc/locale.conf`) so GDM,
Wayland compositors, and GNOME all pick them up without any home-manager workaround.

---

### [`networking.nix`](./networking.nix)

Minimal always-on networking.

| Setting | Value |
|---|---|
| Hostname | `aierNixOS` |
| Host ID | `76a9986d` (required by ZFS) |
| Network management | NetworkManager enabled |

No firewall rules, no VPN, no DNS customisation — those are feature-module territory.

---

### [`users.nix`](./users.nix)

Declares the single normal user account.

| Setting | Value |
|---|---|
| Username | `aier` |
| Type | `isNormalUser = true` |
| Groups | `networkmanager`, `wheel`, `uinput` |

`uinput` group membership is required for Solaar's KeyPress rules to inject synthetic
input events on Wayland (see [`../solaar.nix`](../solaar.nix)).

---

## Conventions

- All four files use the anonymous-argument pattern (`_:`) or named args — they receive
  no custom `myConfig.*` options, only the standard NixOS module arguments.
- No `with pkgs;` anywhere — always `pkgs.foo`. Statix enforces this repo-wide.
- No cross-module imports. Each file is self-contained; the host file composes them.
- These modules must never grow an `enable` toggle — if something is conditional, it
  belongs in a feature module at the `modules/system/` level.

---

## Dependencies & Relationships

| Direction | Target | Note |
|---|---|---|
| Imported by | `hosts/aierNixOS/default.nix` | Only consumer |
| Extended by | `hosts/aierNixOS/locale.nix` | Host-specific LC_TIME / LC_MONETARY overrides layered on top of `locale.nix` baseline |
| No dependency on | `modules/options.nix` | Core modules do not read `myConfig.*` |

---

## Notes

- **Locale two-file split is intentional.** `locale.nix` is the sharable UK baseline;
  `hosts/aierNixOS/locale.nix` is the per-machine deviation. If you add a second host
  that needs different monetary or date formatting, create its own `hosts/<name>/locale.nix`
  rather than editing the shared baseline.
- **Do not set `time.timeZone` here.** The automatic-timezoned service (geoclue2) must
  find it unset to write the detected zone at runtime. Hard-coding a zone disables
  automatic detection silently.
- **ZFS hostId** in `networking.nix` must remain stable. Changing it while a ZFS pool is
  imported will cause the pool to refuse import on the next boot.
