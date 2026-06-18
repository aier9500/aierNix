# home/ — Home-Manager User Configuration

User-level configuration for the `default` NixOS profile, managed entirely through [home-manager](https://github.com/nix-community/home-manager). All files here are imported via [`../imports/home-imports.nix`](../imports/home-imports.nix), which is itself pulled in by [`../home.nix`](../home.nix).

## Directory Structure

```
home/
├── home-apps.nix        # home.packages (Nix + Flatpak) and GNOME extensions
├── home-configs.nix     # programs.* native HM modules (Ghostty, Yazi, Bash)
├── home-files.nix       # home.file raw declarations (fonts, scripts, ibus/rime, Kando, Solaar)
├── home-dconf.nix       # Aggregator: imports all files under home-dconf/
├── home-modules.nix     # Stub for future HM module imports
└── home-dconf/
    ├── gnome-desktop-interface.nix  # Fonts (IBM Plex), cursor (Bibata-Original-Ice), clock, scaling
    ├── gnome-shell.nix              # Enabled extensions list + Just Perfection tweaks
    ├── gnome-clipboard.nix          # Copyous clipboard extension keybinding (<Super>V)
    ├── gnome-input-sources.nix      # Keyboard layout: us+colemak_dh via xkb
    ├── gnome-keybindings.nix        # Custom keybinding: <Super>Return → Ghostty
    └── gnome-night-theme.nix        # Night Theme Switcher commands for auto dark/light
```

## Key Files

### [`home-apps.nix`](./home-apps.nix)
Declares user packages and services:
- **`home.packages`** — split into two lists: general user apps (`darktable`, `vesktop`) and GNOME extensions (`blur-my-shell`, `kando-integration`, `night-theme-switcher`, etc.).
- **`services.flatpak.packages`** — Flatpak app IDs managed declaratively (Zen Browser, Obsidian, Bitwarden, MissionCenter, etc.).

### [`home-configs.nix`](./home-configs.nix)
Native `programs.*` HM modules — the preferred approach for any program that home-manager has a module for:

| Program | What is configured |
|---|---|
| `programs.ghostty` | Theme (Everforest Dark Hard), opacity 0.8, blur, window size 120×40, no saved state |
| `programs.yazi` | Panel ratio, preview dimensions, custom `g`-prefix bookmarks, which-key theme |
| `programs.bash` | `bashrcExtra` (fastfetch, PS1, `y()` yazi cd-on-exit wrapper), shell aliases (eza trees, zoxide shortcuts, `homesw`/`sysw` rebuild wrappers) |

> **Note:** `programs.bash.enable = true` is set in the parent `home.nix`; `home-configs.nix` only adds `bashrcExtra` and `shellAliases`.

### [`home-files.nix`](./home-files.nix)
Raw `home.file` declarations for configs that have no home-manager module:

| Target path | Source / content | Purpose |
|---|---|---|
| `.local/share/fonts/IbmPlex` | `pkgs.ibm-plex` opentype dir | IBM Plex font family |
| `.local/share/fonts/NotoCjkSerif` | `pkgs.noto-fonts-cjk-serif` | CJK serif fonts |
| `.local/share/fonts/NotoCjkSans` | `pkgs.noto-fonts-cjk-sans` | CJK sans fonts |
| `MyBash/homesw.sh` | inline text, executable | Runs `home-manager switch --flake .#default` |
| `MyBash/sysw.sh` | inline text, executable | Runs `sudo nixos-rebuild switch --flake .#default` |
| `.config/ibus/rime/default.custom.yaml` | inline text | Activates `luna_pinyin` + `jyut6ping3` schemas |
| `.config/autostart/kando.desktop` | inline text | Autostarts Kando daemon at GNOME login |
| `.config/kando/config.json` | `../../tuxies-wiki/resources/logitech-linux-setup/kando/general-settings-backup.json` | Kando app-level settings |
| `.config/kando/menus.json` | `../../tuxies-wiki/resources/logitech-linux-setup/kando/menu-settings-backup.json` | Kando radial menu layout |
| `.config/solaar/rules.yaml` | `../../tuxies-wiki/resources/logitech-linux-setup/solaar/rules.yaml` | Solaar Logitech button remap rules |

Kando and Solaar configs are sourced from the sibling `tuxies-wiki/` repo at `../../tuxies-wiki/resources/logitech-linux-setup/`.

### [`home-dconf.nix`](./home-dconf.nix)
Pure import aggregator — no settings of its own. Imports all six files under `home-dconf/`.

### [`home-dconf/`](./home-dconf/)
GNOME dconf settings, one file per concern. Each file uses `dconf.settings` with typed GVariant values via `lib.hm.gvariant`. Notable settings:

- **Cursor:** `Bibata-Original-Ice` (set in `gnome-desktop-interface.nix`)
- **Fonts:** IBM Plex Sans/Serif/Mono at 11pt system-wide
- **Keyboard:** `us+colemak_dh` layout (Colemak-DH, no other layouts)
- **Hotkeys:** `<Super>Return` opens Ghostty; `<Super>V` opens Copyous clipboard history; `<Super>M` toggles notification tray
- **Night Theme Switcher:** runs `dconf write` commands at sunrise/sunset to switch color scheme

### [`home-modules.nix`](./home-modules.nix)
Currently a stub (`imports = []`). Intended for future third-party or custom HM modules.

## The Three-Layer Convention

This directory enforces a clear split for user config:

| Layer | File | When to use |
|---|---|---|
| **Native HM module** | `home-configs.nix` | Home-manager has a `programs.<name>` module for it — always prefer this |
| **Raw file** | `home-files.nix` | No HM module exists; config must land verbatim in `~/.config/…` |
| **dconf** | `home-dconf/*.nix` | GNOME/GTK settings that live in the dconf database |

**Prefer `home-configs.nix` over `home-files.nix`.** `yazi` and `ghostty` were recently migrated from raw `home.file` entries to their native `programs.*` modules. When adding a new program, check `home-manager` options first.

## Dependencies and Relationships

**Depends on:**
- `pkgs.ibm-plex`, `pkgs.noto-fonts-cjk-{serif,sans}` — declared in `home-files.nix`, must be available in nixpkgs
- `../../tuxies-wiki/` — sibling repo; `home-files.nix` sources Kando and Solaar configs from it as relative paths
- System-level packages: `kando`, `rime-cantonese`, `rime-luna-pinyin`, `zoxide` are installed at system level (not here); this directory only configures them

**Used by:**
- [`../imports/home-imports.nix`](../imports/home-imports.nix) — imports all five top-level files here
- [`../home.nix`](../home.nix) — the home-manager entry point for the `default` profile

## Notes

- The `homesw` and `sysw` shell aliases (defined in `home-configs.nix`) call `~/MyBash/homesw.sh` and `~/MyBash/sysw.sh` respectively — the scripts themselves are generated by `home-files.nix`. Both assume the flake is checked out at `~/.dotfiles/aierNix`.
- `zoxide` shell integration is **not** in `bashrcExtra` — it is handled system-wide via `programs.zoxide.enableBashIntegration = true` in the system config to avoid double-initialization.
- Rime schema data (`rime-cantonese`, `rime-luna-pinyin`) is installed at the system level; `home-files.nix` only writes the `default.custom.yaml` that selects which schemas appear in the ibus-rime switcher.
