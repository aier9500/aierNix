# theming — Home-Manager Theming Modules

Home-manager modules that configure GNOME appearance, fonts, and color theming for the aierNix flake. All modules are under `modules/home/theming/` and are imported exclusively by `hosts/aierNixOS/home.nix`.

Rebuild after any change here:
```bash
nh home switch   # alias: homesw
```

---

## Directory Structure

```
theming/
├── fonts.nix               # myHome.fonts — user font symlinks into ~/.local/share/fonts
├── stylix.nix              # myConfig.themeName — Stylix theme-selector framework
├── dconf.nix               # myHome.theming.gnome — GNOME dconf aggregator
└── gnome-dconf/            # dconf fragment files (imported by dconf.nix)
    ├── gnome-desktop-interface.nix   # clock, cursor, font-name dconf keys, GTK theme, hot-corners
    ├── gnome-clipboard.nix           # Super+M → toggle notification tray
    ├── gnome-keybindings.nix         # WM + media-key bindings
    ├── gnome-tweaks.nix              # titlebar buttons, volume above 100%, fractional scaling
    └── gnome-input-sources.nix       # Colemak-DH xkb layout + ibus/Rime input source
```

---

## Key Components

### `fonts.nix` — `myHome.fonts`

**Sole owner of font installation in this repo.** Installs fonts by symlinking Nix store paths into `~/.local/share/fonts/` via `home.file`. The formerly-existing system-side font module (`modules/system/desktop/fonts.nix`) was a dead empty stub and has been removed; all font installation now happens here.

| `home.file` target | Package | Contents |
|---|---|---|
| `~/.local/share/fonts/JetBrainsMonoNerd` | `pkgs.nerd-fonts.jetbrains-mono` | Full braille/box/symbol/icon coverage — needed so the VS Code terminal (Claude Code TUI spinner, etc.) renders without tofu boxes |
| `~/.local/share/fonts/NotoCjkSerif` | `pkgs.noto-fonts-cjk-serif` | Noto CJK Serif (OTF) |
| `~/.local/share/fonts/NotoCjkSans` | `pkgs.noto-fonts-cjk-sans` | Noto CJK Sans (OTF) |

IBM Plex (serif/sans/mono) is **not** installed here — Stylix installs it via its `font-packages` target (`stylix.targets.font-packages.enable = true`), which is always on. Duplicating it here was removed to avoid double-installation.

Enable in the host:
```nix
myHome.fonts.enable = true;
```

---

### `stylix.nix` — `myConfig.themeName`

Theme-selector framework. A single option (`myConfig.themeName`, declared in `modules/options.nix`) selects which profile is active. Set it in `hosts/aierNixOS/home.nix`:

```nix
myConfig.themeName = "vanilla";   # or "catppuccin", "everforest", "wallpaper-based"
```

An unknown name throws at eval time with a clear error listing known themes.

**`stylix.autoEnable = false`** is set globally — no target fires unless explicitly opted in. Each theme profile declares exactly which targets are enabled.

#### Theme registry

| Name | Color source | GTK | Ghostty | Yazi | Notes |
|---|---|---|---|---|---|
| `vanilla` | `grayscale-dark` (inert placeholder) | off | off | off | Reproduces current look exactly; no visual change |
| `catppuccin` | `catppuccin-mocha` | on | on | on | Full recolor; `fontSizeApplications = 11` to match dconf 11pt sizes |
| `everforest` | `everforest-dark-hard` | on | on | on | Same constraints as catppuccin |
| `wallpaper-based` | derived from `nixos-artwork` wallpaper image | on | on | on | Stylix generates the base16 palette from the image at build time |

**Key invariant — `targets.gnome = false` in every theme.** The GNOME Shell User-Themes extension crashed on baremetal previously; GNOME shell colors are managed entirely via `gnome-dconf/` instead.

**`gtk.flatpakSupport.enable = false` in every theme.** `nix-flatpak` manages Flatpak theming declaratively; letting Stylix also write Flatpak overrides creates a conflict.

#### Adding a new theme

1. Add an entry to the `themes` attrset in `stylix.nix` following the pattern of `catppuccin` or `everforest`.
2. Switch by setting `myConfig.themeName = "<your-name>"` in `hosts/aierNixOS/home.nix`.
3. Run `nh home switch`.

#### Cursor

All themes use `vanillaCursor` (`Bibata-Original-Ice`, size 24). Stylix drives `home.pointerCursor` (sets `XCURSOR_THEME`, `~/.icons`, GTK cursor). It does **not** write the `org/gnome/desktop/interface/cursor-theme` dconf key — that is set separately in `gnome-desktop-interface.nix` (the two coexist without conflict).

#### GTK fallback

`stylix.nix` always enables the HM `gtk` module with `adw-gtk3` at `lib.mkDefault` priority. When a colorful theme with `targets.gtk = true` is active, the Stylix gtk target overrides this at normal priority. Under `vanilla`, `adw-gtk3` applies to both GTK3/GTK2 legacy apps (via `settings.ini`/`.gtkrc-2.0`) and GNOME dconf.

---

### `dconf.nix` — `myHome.theming.gnome`

Aggregator module. Declares the `myHome.theming.gnome.enable` option and imports all `gnome-dconf/` fragments. Contains no settings itself — all settings live in the fragments.

Enable in the host:
```nix
myHome.theming.gnome.enable = true;
```

#### `gnome-dconf/` fragments

All fragments are unconditionally imported by `dconf.nix`. They are not themselves feature modules (no `enable` options).

| Fragment | What it sets |
|---|---|
| `gnome-desktop-interface.nix` | 24h clock, `Bibata-Original-Ice` cursor (`lib.mkDefault`), IBM Plex fonts at 11pt, `Adwaita` GTK theme (`lib.mkDefault`), hot-corners off, battery % on |
| `gnome-clipboard.nix` | `Super+M` → toggle notification tray (`org/gnome/shell/keybindings`) |
| `gnome-keybindings.nix` | Workspace navigation (`Ctrl+Super+Left/Right`), window move (`Super+[/]`), `Alt+Tab` windows, `Super+Tab` apps, `Super+Return` → Ghostty, `Ctrl+Shift+Escape` → Mission Center, `Super+F` fullscreen, `Super+X` / `Alt+F4` close, `Super+I` Settings, `Super+E` Files |
| `gnome-tweaks.nix` | Titlebar buttons (`:minimize,maximize,close`), volume above 100%, `scale-monitor-framebuffer` experimental flag for fractional scaling |
| `gnome-input-sources.nix` | `xkb/us+colemak_dh` as primary layout + `ibus/rime` as secondary; declaring this array overrides any GUI-added sources on the next switch |

**Priority note for `gnome-desktop-interface.nix`:** `cursor-theme`, `font-name`, and `gtk-theme` use `lib.mkDefault` so the Stylix GTK target can override them at normal priority when a colorful theme is active. `document-font-name` and `monospace-font-name` are at normal priority (Stylix does not write those keys).

---

## Conventions

- **No `with pkgs;`** — always `pkgs.foo`. Statix enforces this.
- **Feature-toggle pattern** — `fonts.nix` and `dconf.nix` each self-declare their `enable` option. `stylix.nix` is driven by `myConfig.themeName` (always active; the `vanilla` profile is inert).
- **`home.file` for fonts** — `home.file` is the accepted mechanism here because there is no home-manager `programs.*` option for user font path installation (per `DESIGN.md`).
- **No fragment cross-imports** — `gnome-dconf/` files are leaf fragments; they do not import each other.
- **GNOME extensions are fully imperative** — extension installation and settings are managed via the GNOME Extensions app, never in these files (DESIGN.md L8). There are no commented-out shell or night-theme fragments in this directory.

---

## Dependencies & Relationships

| Direction | Target | Why |
|---|---|---|
| Imported by | `hosts/aierNixOS/home.nix` | Only consumer |
| Reads from | `modules/options.nix` | `myConfig.themeName` declaration |
| Stylix HM module | Injected by `lib/default.nix` (`mkHome`) via flake inputs | `stylix.nix` uses `stylix.*` options from the Stylix home-manager module |
| Cursor complement | `gnome-desktop-interface.nix` sets `cursor-theme` dconf key; `stylix.nix` sets `home.pointerCursor` | Both must agree on cursor name — currently both use `Bibata-Original-Ice` |
| Font complement | `fonts.nix` installs JetBrainsMono Nerd + Noto CJK; `stylix.nix` installs IBM Plex via `font-packages` target | Together they cover all fonts in use |

---

## Notes

- **No system-side font module.** `modules/system/desktop/fonts.nix` was a dead empty stub and has been deleted. `myHome.fonts` (`fonts.nix`) is now the only font installation path in this repo.
- **`targets.gnome` is permanently false.** The GNOME Shell User-Themes extension caused crashes on baremetal with Stylix GNOME coloring enabled. GNOME shell appearance is managed via `gnome-dconf/` fragments only.
- **Stylix version-mismatch warning is suppressed.** `stylix.enableReleaseChecks = false` is set because Stylix targets nixos-unstable 26.11 while this flake tracks 26.05. The mismatch is cosmetic — all used options and targets are stable.
- **`wallpaper-based` theme and desktop wallpaper.** `stylix.image` seeds the color palette only — it does not set the GNOME desktop background. Set the wallpaper separately via GNOME Settings or dconf if desired.
- **Declaring `gnome-input-sources.nix` overrides GUI sources.** Any input source added or reordered via the GNOME Settings GUI will be reverted on the next `nh home switch`. Edit the sources array in `gnome-input-sources.nix` instead.
