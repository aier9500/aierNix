# modules/system — NixOS System Modules

System-layer modules for the aierNix flake. These files configure what the machine needs to boot and be managed: the desktop environment, audio, keyboard remapping, snapshots, virtualisation, and essential services. All feature-specific logic lives here; the host file (`hosts/aierNixOS/default.nix`) only imports these modules and flips their toggles.

---

## Directory Structure

```
modules/system/
├── core/                  # Always-on essentials — no enable toggle
│   ├── boot.nix           # GRUB + EFI bootloader, supported filesystems
│   ├── locale.nix         # Timezone (America/Caracas), locale (en_US.UTF-8)
│   ├── networking.nix     # Hostname, NetworkManager
│   └── users.nix          # User account (aier), groups
├── desktop/               # Desktop environment feature modules
│   ├── fonts.nix          # mySystem.desktop.fonts — system font packages (stub)
│   ├── gnome.nix          # mySystem.desktop.gnome — GNOME + GDM
│   └── pipewire.nix       # mySystem.desktop.pipewire — PipeWire audio stack
├── flatpak.nix            # mySystem.flatpak — Flatpak system service
├── keyd.nix               # mySystem.keyd — Colemak DH keyboard remap (evdev)
├── nix.nix                # Nix daemon settings, nh, allowUnfree, stateVersion
├── power.nix              # mySystem.power — power-profiles-daemon
├── printing.nix           # mySystem.printing — CUPS
├── snapper.nix            # mySystem.snapper — Btrfs timeline snapshots
├── solaar.nix             # mySystem.solaar — Logitech (hardware.logitech.wireless) + udev
├── system-pkgs.nix        # Core system packages + programs.*
└── virtualisation.nix     # mySystem.virtualisation — libvirtd
```

---

## Two Kinds of Modules

### Core modules (`core/`) — always-on

These emit configuration unconditionally. They have no enable option and are always imported by the host. Removing any of them would prevent the machine from booting or being usable.

| File | What it sets |
|---|---|
| `boot.nix` | GRUB with Catppuccin theme, EFI, OS prober, 1920x1080 gfxmode, broad filesystem support (btrfs, ntfs, ext*, exfat, zfs, …) |
| `locale.nix` | `time.timeZone`, `i18n.defaultLocale`, all `LC_*` categories to `en_US.UTF-8` |
| `networking.nix` | `networking.hostName = "aierNixOS"`, `hostId`, NetworkManager |
| `users.nix` | User `aier` with `networkmanager` and `wheel` groups |

### `nix.nix` and `system-pkgs.nix` — always-on, top-level

Also imported unconditionally by the host (not in `core/` but treated the same way).

**`nix.nix`** sets:
- `nix.settings.experimental-features = ["nix-command" "flakes"]`
- `nixpkgs.config.allowUnfree = true`
- `system.stateVersion = "24.05"` — do not change
- `programs.nh` pointing at `/home/aier/.dotfiles/aierNix`, with auto-GC (`--keep-since 4d --keep 3`)

**`system-pkgs.nix`** installs packages that belong at the system layer and enables a few `programs.*`:

| Type | Contents |
|---|---|
| `environment.systemPackages` | `ghostty`, `gparted`, `ffmpeg-full`, `home-manager`, `ntfs3g`, `usbutils` |
| `programs.*` | `git` (needed to manage the flake), `localsend` (with open firewall), `nautilus-open-any-terminal`, `appimage` |

`home-manager` is here as a bootstrap requirement: standalone home-manager must be installed as a system package before the first `nh home switch` can run.

### Feature-toggle modules — dormant until enabled

Every module under `desktop/` and the top-level feature files follow the same template:

```nix
{ config, lib, pkgs, ... }:
let cfg = config.mySystem.<feature>;
in {
  options.mySystem.<feature>.enable = lib.mkEnableOption "<human description>";
  config = lib.mkIf cfg.enable {
    # ... pkgs.foo, never with pkgs;
  };
}
```

The module is silent unless the host sets `mySystem.<feature>.enable = true`. This means you can import all feature modules unconditionally in the host and control the feature set entirely via the toggle block.

---

## Feature Modules Reference

| File | Option | What it enables |
|---|---|---|
| `desktop/gnome.nix` | `mySystem.desktop.gnome` | GDM + GNOME desktop; excludes `gnome-shell-extensions` package (extensions managed imperatively via Extensions app) |
| `desktop/pipewire.nix` | `mySystem.desktop.pipewire` | PipeWire with ALSA + 32-bit + PulseAudio compatibility; disables `pulseaudio`; enables `rtkit` |
| `desktop/fonts.nix` | `mySystem.desktop.fonts` | Stub — option declared, body empty; reserved for system-level font packages in a future phase |
| `keyd.nix` | `mySystem.keyd` | keyd daemon with Colemak DH remap: `capslock` → `backspace`, `leftshift+rightshift` → `capslock`, a `layer(control)` chord. Operates at evdev level — works on Wayland, layout-independent |
| `snapper.nix` | `mySystem.snapper` | Btrfs timeline snapshots of `/`; user `aier` can manage snapshots; 5 hourly / 7 daily / 2 weekly / 2 monthly / 0 yearly |
| `virtualisation.nix` | `mySystem.virtualisation` | `libvirtd` |
| `flatpak.nix` | `mySystem.flatpak` | `services.flatpak.enable` — system-level service required for nix-flatpak to install user packages (see `modules/home/apps/flatpak-home.nix`) |
| `power.nix` | `mySystem.power` | `power-profiles-daemon`; explicitly disables `tlp` to prevent conflict |
| `printing.nix` | `mySystem.printing` | CUPS printing service |
| `solaar.nix` | `mySystem.solaar` | Logitech device manager: `hardware.logitech.wireless` (install + udev). Device rules are imperative (Solaar GUI) — see `DESIGN.md` GUI-Owned Config |

---

## Conventions

- **Never `with pkgs;`** — always write `pkgs.foo`. Statix enforces this.
- **No cross-module imports** — feature modules do not import each other. Composition is the host file's job.
- **`myConfig.*` access** — modules that need the hostname or username read from `config.myConfig.*`, which is declared in `modules/options.nix` and set in the host.
- **stateVersion** is pinned in `nix.nix` to `"24.05"`. Do not bump it.

---

## Dependencies & Relationships

| Direction | Target | Why |
|---|---|---|
| Imported by | `hosts/aierNixOS/default.nix` | Host is the only consumer |
| Reads from | `modules/options.nix` | `myConfig.*` option declarations |
| Paired with | `modules/home/apps/flatpak-home.nix` | System enables the service; home declares packages |

The system modules are completely independent of the home modules. The only shared surface is `myConfig.*` values (both sides read the same option definitions from `modules/options.nix`).

---

## Notes

- GNOME extensions are managed **imperatively** via the GNOME Extensions app, not declaratively via dconf. Declarative enable caused crashes on baremetal due to extension version mismatches (locked decision L8 in `DESIGN.md`). The `gnome.excludePackages` list removes the upstream `gnome-shell-extensions` metapackage to keep the extension set clean.
- keyd runs at the evdev level, which means it intercepts keys before any compositor or XKB configuration. The Colemak DH layout and the `capslock` → `backspace` remap are always active regardless of what GNOME's input-source settings say.
- `desktop/fonts.nix` is imported by the host but has an empty body. It exists as a placeholder for when system-level font packages are added. Font symlinks into `~/.local/share/fonts` are handled on the home side by `modules/home/misc/fonts-home.nix`.
