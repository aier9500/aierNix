# default — Primary Host Configuration

The `default/` directory is the single host/profile configuration for this NixOS flake. It is the target of both `nixosConfigurations.default` and `homeConfigurations.default` as declared in [`../flake.nix`](../flake.nix), and is applied with the commands in the two switch scripts below.

---

## Directory Structure

```
default/
├── configuration.nix          # NixOS entry point — imports hardware + system-imports.nix
├── hardware-configuration.nix # Generated hardware scan; managed separately per device
├── home.nix                   # home-manager entry point — imports home-imports.nix
├── imports/
│   ├── system-imports.nix     # Aggregates all system/ modules into one import list
│   └── home-imports.nix       # Aggregates all home/ modules into one import list
├── system/                    # NixOS (root-level) configuration
│   ├── system-apps.nix        # System packages and CLI programs
│   ├── system-configs.nix     # Bootloader, filesystem, hardware, input method, services
│   ├── system-modules.nix     # Re-exports system-modules/ sub-files
│   └── system-modules/
│       ├── system-keyd.nix    # keyd keyboard remapping daemon
│       └── system-solaar.nix  # Solaar Logitech device daemon
└── home/                      # home-manager (user-level) configuration
    ├── home-apps.nix           # User packages, GNOME extensions, Flatpak apps
    ├── home-configs.nix        # Program dotfiles: Ghostty, Yazi, Bash (PS1, aliases)
    ├── home-dconf.nix          # Re-exports home-dconf/ sub-files
    ├── home-dconf/
    │   ├── gnome-clipboard.nix
    │   ├── gnome-desktop-interface.nix
    │   ├── gnome-input-sources.nix  # Colemak-DH keyboard layout
    │   ├── gnome-keybindings.nix    # Custom keybinds (e.g. Super+Return → Ghostty)
    │   ├── gnome-night-theme.nix
    │   └── gnome-shell.nix
    ├── home-files.nix          # home.file: fonts, ibus-rime schema, Kando, Solaar rules
    └── home-modules.nix        # Placeholder for future home-manager module imports
```

---

## Entry Points and Flake Wiring

`flake.nix` references exactly two files from this directory:

| Flake output | Entry file | What it imports |
|---|---|---|
| `nixosConfigurations.default` | `configuration.nix` | `hardware-configuration.nix`, `imports/system-imports.nix` |
| `homeConfigurations.default` | `home.nix` | `imports/home-imports.nix` (plus `nix-flatpak` module injected by flake) |

The `imports/` files are thin aggregators — each is a single `imports = [ ... ]` list that fans out to the real modules. This pattern keeps entry points clean and makes it easy to add or remove modules without touching `configuration.nix` or `home.nix`.

---

## System vs. Home Split

| Concern | Where it lives | Why |
|---|---|---|
| Boot / GRUB / filesystem | `system/system-configs.nix` | Requires root; affects all users |
| ibus-rime engine (schema data) | `system/system-configs.nix` | Package override must happen at system level |
| Flatpak service | `system/system-configs.nix` | System service; portal must be enabled system-wide |
| keyd, Solaar daemons | `system/system-modules/` | System services; need udev rules and privileges |
| libvirtd / GNOME / PipeWire | `system/system-configs.nix` | System-level desktop stack |
| System packages, CLI tools | `system/system-apps.nix` | Available to all users |
| User packages, GNOME extensions | `home/home-apps.nix` | Per-user installs via `home.packages` |
| Flatpak app list | `home/home-apps.nix` | Per-user Flatpak installs via nix-flatpak |
| Program dotfiles (Ghostty, Yazi, Bash) | `home/home-configs.nix` | User-owned config, managed by home-manager |
| dconf / GNOME settings | `home/home-dconf/` | User-level GSettings database |
| `home.file` dotfiles (fonts, rime schema, Kando, Solaar) | `home/home-files.nix` | Files placed directly in `$HOME` |
| ibus-rime schema list | `home/home-files.nix` | Per-user `~/.config/ibus/rime/default.custom.yaml` |

**Split-ownership note for ibus-rime:** the Rime engine and schema packages (`rime-data`, `rime-cantonese`) are installed system-side in `system-configs.nix`; which schemas are active for the user is set home-side in `home-files.nix` via `~/.config/ibus/rime/default.custom.yaml`.

---

## Applying Changes

The repo ships two helper scripts (written to `~/MyBash/` by `home-files.nix`) for convenience:

```bash
# Apply home-manager changes (user config)
home-manager switch --flake ~/.dotfiles/aierNix#default

# Apply NixOS system changes (requires sudo)
sudo nixos-rebuild switch --flake ~/.dotfiles/aierNix#default
```

Or via the aliases set in `home-configs.nix`:

```bash
homesw   # runs ~/MyBash/homesw.sh
sysw     # runs ~/MyBash/sysw.sh
```

---

## Key Conventions

- **`imports/` aggregator pattern** — never import `system/` or `home/` files directly from entry points; always go through `imports/system-imports.nix` or `imports/home-imports.nix`. This keeps `configuration.nix` and `home.nix` stable.
- **`system-modules/` for daemons** — system services that need their own file get a file under `system/system-modules/` and are collected by `system/system-modules.nix`. Mirror this for new services.
- **`home-dconf/` for GNOME settings** — each logical group of dconf keys gets its own file under `home/home-dconf/`, collected by `home/home-dconf.nix`.
- **`home-files.nix` for static dotfiles** — files placed verbatim into `$HOME` go here, including symlinks into `../../tuxies-wiki/resources/` for Kando and Solaar configs.
- **`hardware-configuration.nix` is device-specific** — it is git-ignored per-device (see [`../.gitignore`](../.gitignore)); regenerate with [`../scripts/gen-hardware-config.sh`](../scripts/gen-hardware-config.sh) on a new machine.

---

## Dependencies

**This directory depends on:**
- `nixpkgs` (unstable channel) — all package derivations
- `home-manager` — `home.nix` module system
- `nix-flatpak` — `services.flatpak.packages` in `home-apps.nix` (injected by `flake.nix`)
- `../../tuxies-wiki/resources/` — source files for Kando and Solaar `home.file` entries

**Consumed by:**
- `../flake.nix` — sole consumer; both `nixosConfigurations.default` and `homeConfigurations.default` point here
