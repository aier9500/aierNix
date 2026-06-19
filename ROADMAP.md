# aierNix — ROADMAP

Transfer the `tuxies-wiki` aiers-fedora-checklist setup into a clean, maintainable declarative Nix config. My preferences are canonical; the wiki is the starting point.

Design decisions and doctrine live in `DESIGN.md`. Working-pattern and orientation details live in `MEMORY.md`.

---

## Current State / Next Pickup

**For a fresh agent picking this up cold:** read this section first, then the detailed lists below.

### What's done

- **Best-practice rebuild (P0–P3) is complete and merged to `main`.** Layout is `hosts/` + `modules/` with standalone home-manager and `nh`. `default/` tree is deleted. See Changelog below for the full history.
- **This session (2026-06-19) completed:** Stylix theme-selector framework + vanilla profile; fastfetch via `programs.fastfetch.settings`; fzf default options; cursor DRY (dconf reads stylix cursor name); Kando + Solaar declared in-repo (config files embedded under `modules/home/misc/`); legacy catppuccin-grub theme removed; secrets imperative-by-design formally documented; GNOME battery charge-limit active on ASUS Zenbook S 16.
- **Local `tuxies-wiki/` clone is already gone** — the directory does not exist. Everything needed was ported in-repo. The canonical reference wiki lives at GitHub `Theory-Y/tuxies-wiki`.

### Items of notice for the incoming agent

- **Kando + Solaar are declared** but the Kando setup requires one manual step: install the "Kando Integration" GNOME extension via GNOME Extensions app, then restart Kando. The Haptic-button → pie-menu chain won't work until that extension is active.
- **Stylix colorful themes:** the framework is already in place (`myConfig.themeName` selector in `hosts/aierNixOS/home.nix`, theme registry + `vanilla` profile in `modules/home/theming/stylix.nix`, with a commented `everforest` stub showing the full pattern). Adding a colorful theme = add an entry to the `themes` attrset + flip `themeName`. See the file header for step-by-step instructions.
- **Working pattern:** the agent builds and verifies in-harness (`nix flake check`, `nh os build`, `nh home build`, `nix store diff-closures`). The USER runs the live `nh os switch` / `nh home switch` in their own terminal. Never auto-activate. See `MEMORY.md` for the full pattern.
- **High-stakes deferred items** (Howdy, declarative GNOME extensions) require explicit user go-ahead before any work is started. See annotations in Future/Deferred below.

---

## Active Plan — Best-Practice Rebuild

Full restructure into `hosts/` + `modules/` layout with standalone home-manager and quality gate. See `action-plans/nix-structuring-rebuild.md` for the complete phase breakdown, step-by-step instructions, and file mapping table.

- [x] **P0 — Scaffold:** Create `rebuild` branch; write `lib/mkHost+mkHome`; scaffold `hosts/aierNixOS/`, `modules/`, `overlays/`, `pkgs/`; rewrite `flake.nix` (standalone HM, rename to `.aierNixOS`, add devShell + git-hooks + `.envrc`); wire `programs.nh`. Gate: `nix flake check` + `nixos-rebuild build`.
- [x] **P1 — System modularization:** Port all system config into `modules/system/` feature-toggle modules; always-on core (boot, fs, networking, locale, users); feature toggles for GNOME, pipewire, keyd, snapper, virtualisation, ibus-rime, power, printing, flatpak. Gate: `nh os switch` boots correctly.
- [x] **P2 — Home modularization + cleanup:** Port all home config into `modules/home/` modules; replace homesw/sysw/MyBash with `nh` aliases; move VSCode to home (install-only); eliminate `with pkgs;`; port bash (PS1, aliases, `y()` function); delete dead code and scripts. Gate: `nh home switch`, `statix` + `deadnix` clean, no `with pkgs;`.
- [x] **P3 — Docs + cutover:** Rewrite README.md (new layout + nh workflow); add subdir READMEs; delete old `default/` tree; final `nix flake check`; merge `rebuild` → `main`; clear OVERRIDE.md.

**Rebuild complete.** All four phases merged to `main`. `default/` tree deleted; closures verified byte-identical across every phase boundary.

---

## Future / Deferred

- [ ] **Stylix colorful theme profiles** — framework is already in place (see Current State above). Remaining work: add a colorful theme entry (e.g. Everforest/Catppuccin/wallpaper-based via `stylix.image`) and flip `themeName`. Scope: GTK/cursor/fonts/ghostty/yazi targets; keep GNOME shell + night-theme-switcher in dconf; do NOT enable `targets.gnome` (User Themes extension crashed baremetal).
- [ ] **Flatpak → nixpkgs migration** — evaluate per-app: Obsidian, Bitwarden, MissionCenter are packaged in nixpkgs; Zen stays flatpak. See DESIGN.md minimize-policy.
- [ ] **rime-cantonese** — greenfield IME: system-level `i18n.inputMethod` ibus engine + home-side rime schemas (luna_pinyin + jyut6ping3). Prior home-only config was removed in the rebuild as it was never functional. Start fresh.
- [ ] **Declarative GNOME extensions** — **requires explicit user go-ahead before starting.** Previously crashed baremetal (extension version mismatch, 2026-06-18). Re-attempt only when nixpkgs version-matching for extensions is reliable.
- [ ] **Howdy facial login** — **requires explicit user go-ahead before starting; highest-stakes item (PAM integration, lockout risk).** Deferred until baremetal + user motivation.
- [ ] **Second host (laptop)** — **blocked on hardware (not present).** `hosts/` + `modules/` structure is ready; add when the device arrives.
- [ ] **disko** — declarative partitioning; reinstall-time change. **Deferred indefinitely — do NOT raise unless the user explicitly asks.**
- [ ] **impermanence** — ephemeral root; requires disko first. **Deferred indefinitely — do NOT raise unless the user explicitly asks.**

---

## Changelog

### 2026-06-19 — Secrets: imperative-by-design

Formally documented that no declarative secrets backend (sops-nix / agenix) will be used. Secrets are managed by the application (e.g. Bitwarden) and synced via the user's account. See DESIGN.md.

### 2026-06-19 — Declared Solaar + Kando; cursor DRY; catppuccin-grub removed

Declared Solaar (`hardware.logitech.wireless` + `rules.yaml`) and Kando (`config.json` / `menus.json`) from Theory-Y/tuxies-wiki, via in-repo `.source` under `modules/home/misc/`. Dconf cursor-theme now reads `config.stylix.cursor.name` (DRY). Removed legacy catppuccin-grub theme (kept 1920x1080 resolution).

### 2026-06-19 — Stylix theme-selector framework + vanilla profile; fonts + cli hygiene

Stylix theme-selector framework + vanilla profile (`themeName` selector in `myConfig`; `vanilla` profile in `modules/home/theming/stylix.nix`; commented `everforest` stub). Cursor kept GNOME-owned via dconf (no Stylix cursor target). Fonts module moved `misc/fonts-home.nix` → `theming/fonts.nix`. Fastfetch declared via `programs.fastfetch.settings` (root dotfile removed). Fzf default options declared.

### 2026-06-18 — Stylix trialled and reverted; vanilla preferred

Trialled Stylix partial theming (Everforest Dark Hard, home-only); reverted to vanilla per preference. Ghostty and yazi now use their default themes. Multi-theme switching deferred (see Future).

### 2026-06-18 — GNOME battery charge-limit enabled

GNOME 50 battery charge-limit enabled on the ASUS Zenbook S 16 — custom udev rule + hwdb `CHARGE_LIMIT=_,80` in `modules/system/power.nix` (asus_wmi exposes only an end threshold; upower's bundled rule needed a start threshold, so we backfill the hwdb import).

### 2026-06-18 — best-practice rebuild complete

Best-practice rebuild complete — full `hosts/` + `modules/` restructure, standalone HM, quality gate, `nh` workflow; `default/` tree deleted; P0–P3 merged to main. Closures verified byte-identical across every phase boundary.

### 2026-06-18 — planning artifacts written

Planned the full best-practice rebuild. Wrote `action-plans/nix-structuring-rebuild.md` (staged execution plan), `DESIGN.md` (doctrine), and updated ROADMAP + OVERRIDE. Rebuild executes in the next session on the `rebuild` branch.

### 2026-06-18 — Node.js added

Added `nodejs` to home packages.

### 2026-06-18 — hardware-config tracking corrected

Flakes only copy git-tracked files — corrected all docs and `.gitignore` to reflect that `hardware-configuration.nix` must be tracked. Strategy: single tracked file per machine.

### 2026-06-18 — dconf: GNOME shortcuts + tweaks ported

Ported tuxies-wiki gnome.md guide into home dconf:

- `gnome-keybindings.nix` — WM keybindings (workspace switching, window management, panel-run-dialog, media keys), Ghostty `<Super>Return`, Mission Center `<Ctrl><Shift>Esc`.
- `gnome-tweaks.nix` (new) — titlebar button layout, allow-volume-above-100-percent, mutter scale-monitor-framebuffer.

### 2026-06-18 — baremetal dconf crash fix

First baremetal run: declarative GNOME extension settings (gnome-shell + night-theme-switcher dconf) crashed due to extension version mismatch. Resolution: extensions are now fully imperative (GNOME Extensions app). Removed declarative package install and dconf enable blocks. Safe dconf (interface, clipboard, keybindings, input-sources) remains declarative.

### 2026-06-18 — declutter + hygiene

- yazi + ghostty migrated from `home.file` blobs to `programs.yazi` / `programs.ghostty`.
- Solaar + Kando config files sourced via `home.file .source` from tuxies-wiki resources (subsequently committed in-repo 2026-06-19).
- Won't-port items struck: Tiling Shell, v4l2loopback, Waydroid, Fluent icons/cursor.

### 2026-06-18 — Wayland, grub-btrfs, ibus-rime, Solaar, Kando, portability

- **Wayland switch** — GDM Wayland on; removed X11 xkb block; `gnome-input-sources.nix` → GNOME layout `us+colemak_dh`.
- **grub-btrfs** — `services.grub-btrfs.enable` (pairs with snapper).
- **ibus-rime Cantonese schemas** — system engine override adds `rime-cantonese`; home config enables `luna_pinyin` + `jyut6ping3` (subsequently removed in rebuild; greenfield future item).
- **Solaar** — `services.solaar`; subsequently committed in-repo 2026-06-19.
- **Kando** — `kando` pkg; autostart `.desktop`; config committed in-repo 2026-06-19.
- **Portability** — per-device setup section in README.
