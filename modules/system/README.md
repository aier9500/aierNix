# modules/system — NixOS System Modules

System-layer modules for the aierNix flake. These files configure what the machine needs to boot and be managed: the desktop environment, audio, keyboard remapping, snapshots, virtualisation, and essential services. All feature-specific logic lives here; the host file (`hosts/aierNixOS/default.nix`) only imports these modules and flips their toggles.

---

## Directory Structure

```
modules/system/
├── core/                  # Always-on essentials — no enable toggle
│   ├── boot.nix           # GRUB + EFI bootloader, supported filesystems
│   ├── locale.nix         # Timezone (auto-detected via automatic-timezoned/geoclue2), locale (en_GB.UTF-8)
│   ├── networking.nix     # Hostname, NetworkManager
│   └── users.nix          # User account (aier), groups
├── desktop/               # Desktop environment feature modules
│   ├── gnome.nix          # mySystem.desktop.gnome — GNOME + GDM
│   └── pipewire.nix       # mySystem.desktop.pipewire — PipeWire audio stack
├── flatpak.nix            # mySystem.flatpak — Flatpak system service (system half of a required split)
├── ibus.nix               # mySystem.ibus — ibus + Rime engine (luna_pinyin, jyut6ping3)
├── keyd.nix               # mySystem.keyd — Colemak DH keyboard remap (evdev)
├── nix.nix                # Nix daemon settings, nh, allowUnfree, stateVersion
├── openwhispr.nix         # mySystem.openwhispr — OpenWhispr voice dictation [EXPERIMENTAL]
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
| `boot.nix` | GRUB, EFI (`canTouchEfiVariables`), OS prober, 1920x1080 gfxmode (BIOS + EFI), broad filesystem support (btrfs, ext2/3/4, exfat, f2fs, fat8/16/32, ntfs, xfs, zfs); `zfs.forceImportRoot = false` |
| `core/locale.nix` | Timezone auto-detected at runtime via `services.automatic-timezoned` / geoclue2 (no `time.timeZone` set); `i18n.defaultLocale = "en_GB.UTF-8"`; all `LC_*` categories default to `en_GB.UTF-8` (per-category overrides `LC_TIME`/`LC_MONETARY` live in the host's `hosts/aierNixOS/locale.nix`) |
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
| `keyd.nix` | `mySystem.keyd` | keyd daemon with Colemak DH remap: `capslock` → `backspace`, `leftshift+rightshift` → `capslock`, a `layer(control)` chord. Operates at evdev level — works on Wayland, layout-independent |
| `snapper.nix` | `mySystem.snapper` | Btrfs timeline snapshots of `/`; user `aier` can manage snapshots; 5 hourly / 7 daily / 2 weekly / 2 monthly / 0 yearly |
| `virtualisation.nix` | `mySystem.virtualisation` | `libvirtd` |
| `flatpak.nix` | `mySystem.flatpak` | `services.flatpak.enable` — system-level Flatpak runtime (binary, xdg-desktop-portal, system helper, XDG_DATA_DIRS exports). This is the required system half; the per-user app list lives in `modules/home/apps/flatpak-home.nix`. The split is NixOS-forced and intentional — Flatpak cannot be home-only |
| `power.nix` | `mySystem.power` | `power-profiles-daemon`; explicitly disables `tlp` to prevent conflict |
| `printing.nix` | `mySystem.printing` | CUPS printing service |
| `solaar.nix` | `mySystem.solaar` | Logitech device manager: `hardware.logitech.wireless` (install + udev) + autostart `.desktop` (`/etc/xdg/autostart`, tray via `--window=hide`). Device rules are imperative (Solaar GUI) — see `DESIGN.md` GUI-Owned Config |
| `ibus.nix` | `mySystem.ibus` | ibus input-method framework + Rime engine via `i18n.inputMethod` (type `ibus`). The bundled rime-data provides `luna_pinyin` + `jyut6ping3` (no `rimeDataPkgs` override). Schema selection is the home half (`modules/home/misc/ibus-rime.nix`); the GNOME input source is in gnome-input-sources dconf. See `DESIGN.md` L6 |
| `openwhispr.nix` | `mySystem.openwhispr` | **EXPERIMENTAL — partially working. See Notes.** OpenWhispr voice dictation: imports `inputs.openwhispr.nixosModules.default` from the upstream flake, enables `programs.openwhispr` (which pulls in `programs.ydotool`, `hardware.uinput`, and the `ydotool`/`uinput` groups), additionally adds the user to the `input` group, and registers an `open-whispr.desktop` NoDisplay protocol handler + `xdg.mime.defaultApplications` for the `openwhispr://` browser sign-in scheme |

---

## Conventions

- **Never `with pkgs;`** — always write `pkgs.foo`. Statix enforces this.
- **No cross-module imports** — feature modules do not import each other. Composition is the host file's job.
- **`myConfig.*` access** — modules that need the hostname or username read from `config.myConfig.*`, which is declared in `modules/options.nix` and set in the host.
- **`inputs` in module args** — modules that wrap upstream flake NixOS modules (e.g. `openwhispr.nix`) take `inputs` as an extra argument and use `imports = [ inputs.<flake>.nixosModules.default ]`.
- **stateVersion** is pinned in `nix.nix` to `"24.05"`. Do not bump it.

---

## Dependencies & Relationships

| Direction | Target | Why |
|---|---|---|
| Imported by | `hosts/aierNixOS/default.nix` | Host is the only consumer |
| Reads from | `modules/options.nix` | `myConfig.*` option declarations |
| Paired with | `modules/home/apps/flatpak-home.nix` | System enables the Flatpak service; home declares per-user packages |
| Paired with | `modules/home/misc/ibus-rime.nix` | System enables ibus; home manages Rime schema selection |

The system modules are completely independent of the home modules. The only shared surface is `myConfig.*` values (both sides read the same option definitions from `modules/options.nix`).

---

## Notes

- **OpenWhispr is experimental and partially working.** Web sign-in via the `openwhispr://` protocol handler works. However, Wayland auto-paste may still type a literal `v` instead of pasting — the Ctrl modifier is dropped when ydotool sends the paste keystroke. This is unresolved. Do not rely on auto-paste in production workflows until this is confirmed fixed.
- **Group membership requires re-login.** The `ydotool`, `uinput`, and `input` groups added by `openwhispr.nix` only take effect after the user logs out and back in following the first system switch with `mySystem.openwhispr.enable = true`.
- **`desktop/fonts.nix` has been removed.** It was an empty stub with no configuration body. System-level font packages are not currently managed here; fonts are owned entirely on the home side by `myHome.fonts` (`modules/home/misc/fonts-home.nix`).
- GNOME extensions are managed **imperatively** via the GNOME Extensions app, not declaratively via dconf. Declarative enable caused crashes on baremetal due to extension version mismatches (locked decision L8 in `DESIGN.md`). The `gnome.excludePackages` list removes the upstream `gnome-shell-extensions` metapackage to keep the extension set clean.
- keyd runs at the evdev level, which means it intercepts keys before any compositor or XKB configuration. The Colemak DH layout and the `capslock` → `backspace` remap are always active regardless of what GNOME's input-source settings say.
- The Flatpak system/home split is NixOS-forced (same pattern as `gnome`, `ibus`): the system provides the runtime and portal infrastructure; the home module can only declare user-installed apps if this service is already running. Collapsing this into the home side would break nix-flatpak's `--user` installs.
