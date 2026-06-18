# aierNix Restructure — align to tuxies-wiki habits (2026-06-17)

Goal: bring 2-yr-old aierNix in line with current solidified Linux habits documented in
`tuxies-wiki`. Viable launch = builds + boots in Nix VM with core habits live; baremetal later.

## Locked decisions
- Display: **GNOME Wayland** (drop X11 session + X11 keymap)
- Keyboard: **OS keymap = Colemak DH**, **keyd** layered on top (caps=backspace,
  Lshift+Rshift=capslock, copilot-key→ctrl layer). Remove Kanata.
- Packages: **nix-flatpak** declarative for wiki's flatpak apps.
- Theming: **strip to wiki spec** — remove Marble/Adw-Gtk3, WhiteSur/Catppuccin cursors,
  IBM Plex Serif. Keep IBM Plex Sans/Mono + Noto CJK (functional for iBus pinyin).
- Clipboard ext: keep ClipboardIndicator (Copyous noted as alt). Howdy: skip (VM). ptyxis: none, ghostty bound to Super+Return.

## Work packages

### Phase 1 — Flake + System base (must build first)
- **WP1 flake.nix**: add `nix-flatpak` input; wire its nixos + home-manager modules. Keep nixos-unstable, stateVersion 24.05.
- **WP2 Wayland + Colemak**: GDM Wayland; set Colemak DH as console + GNOME input source; remove X11 Colemak keymap.
- **WP3 keyd module**: new `System/SystemModules/systemKeyd.nix` (services.keyd) replacing `systemKanata.nix`. Remove kanata refs in systemModules.nix.
- **WP4 system pkgs**: systemApps — remove Chromium; trim theme-only deps; keep dev/CLI tools.

### Phase 2 — Home (depends WP1)
- **WP5 flatpaks**: new home module declaring wiki flatpaks (Zen, Edge, Obsidian, Bitwarden, MissionCenter, Kando, Solaar, LocalSend, Gradia, Kooha, RClone-Manager, OBS, Flatseal, ExtensionManager, SaveDesktop) + flathub remote.
- **WP6 ghostty**: `programs.ghostty` — Everforest Dark Hard, opacity 0.8, blur, 120x40, save-state never.
- **WP7 yazi**: `programs.yazi` + keymap/theme/yazi.toml + deps; `y()` wrapper.
- **WP8 bash**: full eza aliases (lsd/lst/lsda/lsta +levels), fzf aliases (cmd, zh), zoxide, fastfetch; coordinate `y()` with WP7.
- **WP9 GNOME extensions**: ADD Caffeine, Fuzzy App Search, Shotzy, Night Theme Switcher, Tiling Shell, Kando Integration. REMOVE DashToDock, UserThemes, WindowNavigator, WindowTitleIsBack, LaunchNewInstance, QuickSettingsAudioPanel, PaperWM + disabled set.
- **WP10 dconf**: fonts (Plex Sans 11/12, Mono 11, grayscale/slight); button-layout minimize,maximize,close; volume>100%; fractional scaling; keybinding set; Just Perfection settings; custom shortcuts (Super+Return→ghostty, Ctrl+Shift+Esc→Mission Center). Delete stale extension dconf files. Depends WP9.
- **WP11 strip theming**: homeFiles — drop Marble themes, cursors, Plex Serif; keep Plex Sans/Mono + Noto CJK. Keep VSCode.

### Phase 3 — Verify
- **WP12**: `nix flake check` + `nixos-rebuild build` (or VM build). Adversarial review of diff.

## Dispatch waves
1. WP1 (solo, blocking)
2. WP2, WP3, WP4 (parallel — system) + WP5, WP6, WP7+WP8, WP9, WP11 (parallel — home)
3. WP10 (after WP9)
4. WP12 verify
