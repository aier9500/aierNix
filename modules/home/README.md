# modules/home — Home-Manager Modules

User-environment modules for the aierNix flake. These configure everything customizable and user-specific: the shell, CLI tools, terminal emulator, applications, GNOME theming, and fonts. The host file (`hosts/aierNixOS/home.nix`) imports every module here and enables the ones active on the current machine via `myHome.*` toggles.

All modules follow the same feature-toggle pattern — they are silent unless the host sets their `enable` flag. This keeps rebuild iteration fast: home changes do not require a system rebuild.

Rebuild the user environment with:
```bash
nh home switch   # alias: homesw
```

---

## Directory Structure

```
modules/home/
├── shell/
│   └── bash.nix               # myHome.shell.bash — PS1, aliases, y() wrapper
├── cli/
│   ├── eza.nix                # myHome.cli.eza — directory listing
│   ├── fastfetch.nix          # myHome.cli.fastfetch — system info on shell open
│   ├── fzf.nix                # myHome.cli.fzf — fuzzy finder
│   ├── yazi.nix               # myHome.cli.yazi — file manager with custom config
│   └── zoxide.nix             # myHome.cli.zoxide — smart directory jumper
├── terminal/
│   └── ghostty.nix            # myHome.terminal.ghostty — Ghostty terminal emulator
├── apps/
│   ├── flatpak-home.nix       # myHome.apps.flatpak — user Flatpak package list
│   ├── home-pkgs.nix          # myHome.apps.homePkgs — general home.packages list
│   ├── obs-studio.nix         # myHome.apps.obsStudio — OBS Studio
│   └── vscode.nix             # myHome.apps.vscode — VS Code (install-only)
├── theming/
│   ├── dconf.nix              # myHome.theming.gnome — dconf aggregator
│   ├── cursors.nix            # myHome.theming.cursors — bibata cursor theme
│   └── gnome-dconf/           # dconf fragment files (imported by dconf.nix)
│       ├── gnome-clipboard.nix       # Notification tray keybind
│       ├── gnome-desktop-interface.nix  # Fonts, cursor, clock, hot-corners
│       ├── gnome-input-sources.nix   # (empty — input sources managed elsewhere)
│       ├── gnome-keybindings.nix     # WM + media-key bindings
│       ├── gnome-night-theme.nix     # nightthemeswitcher extension commands
│       ├── gnome-shell.nix           # extension list (commented — see Notes)
│       └── gnome-tweaks.nix         # Titlebar buttons, volume, fractional scaling
└── misc/
    ├── fonts-home.nix         # myHome.fonts — font symlinks into ~/.local/share/fonts
    └── kando.nix              # myHome.kando — Kando radial menu + autostart
```

---

## Module Reference

### `shell/bash.nix` — `myHome.shell.bash`

Configures `programs.bash` with:

- **PS1** — custom multi-line prompt using `tput` color codes (cyan/green/teal palette, shows user, host, working directory)
- **`bashrcExtra`** — runs `fastfetch` on every new shell; defines the `y()` cd-on-exit wrapper for yazi (captures yazi's `--cwd-file` output and `cd`s to the last directory on exit)
- **Shell aliases:**

| Alias | Expands to | Purpose |
|---|---|---|
| `homesw` | `nh home switch` | Rebuild + activate home |
| `sysw` | `nh os switch` | Rebuild + activate system |
| `nixse` | `nix search nixpkgs` | Package search |
| `cls` | `clear` | Clear terminal |
| `cmd` | `compgen -c \| fzf` | Fuzzy-search all available commands |
| `zh` | `history \| fzf` | Fuzzy-search shell history |
| `lsd` / `lsd1–3` | `eza -TD [--level N]` | Directory-only tree (1–3 levels) |
| `lst` / `lst1–3` | `eza -T [--level N]` | Files + dirs tree |
| `lsda` / `lsda1–3` | `eza -TDa [--level N]` | Directory-only tree (show hidden) |
| `lsta` / `lsta1–3` | `eza -Ta [--level N]` | Files + dirs tree (show hidden) |

---

### `cli/`

| Module | Option | Details |
|---|---|---|
| `eza.nix` | `myHome.cli.eza` | `programs.eza` with bash integration. Aliases (`lsd*`, `lst*`) live in `bash.nix`. |
| `fzf.nix` | `myHome.cli.fzf` | `programs.fzf.enable`. Used by `cmd` and `zh` aliases. |
| `zoxide.nix` | `myHome.cli.zoxide` | `programs.zoxide` with bash integration. Replaces `cd` with frecency-aware jumps. |
| `fastfetch.nix` | `myHome.cli.fastfetch` | `programs.fastfetch.enable`. Runs on shell open via `bashrcExtra`. Default config; custom `config.jsonc` deferred. |
| `yazi.nix` | `myHome.cli.yazi` | `programs.yazi` with bash integration, `shellWrapperName = "y"`. Custom: 3-panel ratio (1:2:5), preview size 1200×1600, Everforest-palette `which` hint UI, and `g`-prefix keybindings for common directories (Desktop, Documents, Pictures, Videos, Music, Public, Projects, Installations, `~/.config/yazi`). |

Note: both yazi and bash.nix define a `y()` symbol. The `shellWrapperName = "y"` in `yazi.nix` sets the HM-generated wrapper; the `y()` function in `bash.nix` is a manual cd-on-exit wrapper for the same purpose. The bash one takes precedence in `.bashrc` ordering — the two should be kept consistent if yazi is updated.

---

### `terminal/ghostty.nix` — `myHome.terminal.ghostty`

Configures `programs.ghostty` with:
- Theme: `Everforest Dark Hard`
- Background opacity: `0.8`, blur: `true` (requires Blur my Shell extension on GNOME)
- Initial window size: 120 columns × 40 rows
- `window-save-state = "never"` — always opens at the declared size

Ghostty is also listed in `modules/system/system-pkgs.nix` (system-level install). The home module manages its configuration; the system package provides the binary for GDM and other system contexts.

---

### `apps/`

| Module | Option | Details |
|---|---|---|
| `vscode.nix` | `myHome.apps.vscode` | `home.packages = [pkgs.vscode]`. Install-only — no Nix-managed settings. Configuration is handled entirely by VS Code Settings Sync / GitHub Gist. Do not add `programs.vscode.userSettings` here. |
| `obs-studio.nix` | `myHome.apps.obsStudio` | `programs.obs-studio.enable = true`. Plugin list is empty (`plugins = []`); scenes and profiles are managed imperatively. |
| `flatpak-home.nix` | `myHome.apps.flatpak` | User Flatpak packages managed declaratively via nix-flatpak (`services.flatpak.packages`). Current list: `zen`, `gradia`, `bitwarden`, `flatseal`, `extension-manager`, `kooha`, `rclone-manager`, `missioncenter`, `obsidian`. Requires `mySystem.flatpak.enable = true` on the system side. Do not also list these in `home.packages`. |
| `home-pkgs.nix` | `myHome.apps.homePkgs` | General `home.packages` for apps and tools not covered by dedicated modules: `darktable`, `dconf-editor`, `gnome-boxes`, `gnome-tweaks`, `proton-vpn`, `vesktop`, `claude-code`, `dconf2nix`, `nodejs`, `openconnect`, `python3`, `adw-gtk3`. |

---

### `theming/`

**`dconf.nix`** (`myHome.theming.gnome`) is the aggregator. It declares the `myHome.theming.gnome.enable` option and imports the active dconf fragment files:

| Fragment | Enabled | What it sets |
|---|---|---|
| `gnome-desktop-interface.nix` | Yes | 24h clock, `Bibata-Original-Ice` cursor, IBM Plex fonts (Sans/Serif/Mono 11pt), `Adwaita` GTK theme, hot-corners off, battery percentage on |
| `gnome-clipboard.nix` | Yes | `<Super>M` → toggle notification tray |
| `gnome-keybindings.nix` | Yes | Workspace navigation (`Ctrl+Super+Left/Right`), window move across workspaces, `Alt+Tab` for windows, `Super+Tab` for apps, `Super+Return` → Ghostty, `Ctrl+Shift+Escape` → MissionCenter, `Super+F` fullscreen, `Super+X` close, etc. |
| `gnome-tweaks.nix` | Yes | Titlebar buttons (`:minimize,maximize,close`), volume above 100%, fractional scaling `scale-monitor-framebuffer` experimental flag |
| `gnome-input-sources.nix` | Yes | Empty body — input sources are configured elsewhere |
| `gnome-shell.nix` | Commented out | Extension list + just-perfection settings (see Notes) |
| `gnome-night-theme.nix` | Commented out | nightthemeswitcher extension commands (see Notes) |

**`cursors.nix`** (`myHome.theming.cursors`) installs `pkgs.bibata-cursors` into `home.packages`. The active cursor theme (`Bibata-Original-Ice`) is set via `gnome-desktop-interface.nix`.

---

### `misc/`

**`fonts-home.nix`** (`myHome.fonts`) — uses `home.file` to symlink font directories from the Nix store into `~/.local/share/fonts/`:

| Directory | Package | Fonts |
|---|---|---|
| `IbmPlex` | `pkgs.ibm-plex` | IBM Plex Sans, Serif, Mono (OTF) |
| `JetBrainsMonoNerd` | `pkgs.nerd-fonts.jetbrains-mono` | JetBrains Mono Nerd Font (full symbol/icon coverage for VS Code terminal) |
| `NotoCjkSerif` | `pkgs.noto-fonts-cjk-serif` | Noto CJK Serif |
| `NotoCjkSans` | `pkgs.noto-fonts-cjk-sans` | Noto CJK Sans |

`home.file` is used here because there is no home-manager module for font path installation — this is one of the accepted `home.file` exceptions per `DESIGN.md`.

**`kando.nix`** (`myHome.kando`) — installs `pkgs.kando` and writes an autostart `.desktop` entry to `~/.config/autostart/kando.desktop`. Kando runs as a background daemon triggered by its own global hotkey. Configuration (`config.json`, `menus.json`) is managed imperatively via the GUI — declarative config is deferred.

---

## Feature-Toggle Template

All modules in this directory follow this pattern:

```nix
{ config, lib, pkgs, ... }:
let cfg = config.myHome.<category>.<feature>;
in {
  options.myHome.<category>.<feature>.enable = lib.mkEnableOption "<human description>";
  config = lib.mkIf cfg.enable {
    # ... pkgs.foo, never with pkgs;
  };
}
```

The option is self-declared in the module. The host file is the only place `enable = true` appears.

---

## Conventions

- **No `with pkgs;`** — always `pkgs.foo`. Statix enforces this.
- **No cross-module imports** — home modules do not import each other. `dconf.nix` is the sole exception: it imports its fragment files, which are not themselves feature modules (they have no option declarations).
- **`home.file` is a last resort** — use it only when a program has no home-manager module option (`fonts-home.nix`, `kando.nix` autostart). If a program has an `programs.*` option, use that.
- **Never duplicate flatpak packages** — packages declared in `flatpak-home.nix` must not also appear in `home-pkgs.nix` or anywhere else in `home.packages`.

---

## Dependencies & Relationships

| Direction | Target | Why |
|---|---|---|
| Imported by | `hosts/aierNixOS/home.nix` | Only consumer |
| Reads from | `modules/options.nix` | `myConfig.*` option declarations |
| Requires system side | `modules/system/flatpak.nix` | `services.flatpak.enable` must be true before nix-flatpak can install user packages |
| nix-flatpak HM module | Injected by `lib/default.nix` (`mkHome`) | `flatpak-home.nix` uses `services.flatpak` from the nix-flatpak home-manager module |

---

## Notes

- **GNOME extensions are imperative.** `gnome-shell.nix` and `gnome-night-theme.nix` exist in `gnome-dconf/` but are commented out of the imports list in `dconf.nix`. Declarative extension settings caused crashes on baremetal due to extension version mismatches (locked decision L8 in `DESIGN.md`). Manage extensions via the GNOME Extensions app; manage extension settings in-extension or via `dconf-editor`.
- **vscode config intentionally absent.** Settings Sync keeps extensions, keybindings, and settings in sync via a GitHub Gist. Adding `programs.vscode.userSettings` in Nix would conflict with that sync. `vscode.nix` is install-only by design (locked decision L10).
- **yazi `shellWrapperName = "y"`** was set explicitly to adopt the upcoming 26.05 default and silence a cosmetic deprecation warning about the name changing.
- **Stylix is deferred.** When adopted, it will target GTK theme, cursor, fonts, Ghostty theme, and yazi theme — but not GNOME shell dconf settings, which stay in these fragment files regardless.
