# aierNix — ROADMAP

Transfer the `tuxies-wiki` aiers-fedora-checklist setup into a clean, maintainable declarative Nix config. My preferences are canonical; the wiki is the starting point.

Design decisions and doctrine live in `DESIGN.md`. Active rebuild plan lives in `action-plans/nix-structuring-rebuild.md`.

---

## Active Plan — Best-Practice Rebuild

Full restructure into `hosts/` + `modules/` layout with standalone home-manager and quality gate. See `action-plans/nix-structuring-rebuild.md` for the complete phase breakdown, step-by-step instructions, and file mapping table.

Work on the `rebuild` branch. Each phase ends with a `nixos-rebuild build`-verified checkpoint before switch.

- [x] **P0 — Scaffold:** Create `rebuild` branch; write `lib/mkHost+mkHome`; scaffold `hosts/aierNixOS/`, `modules/`, `overlays/`, `pkgs/`; rewrite `flake.nix` (standalone HM, rename to `.aierNixOS`, add devShell + git-hooks + `.envrc`); wire `programs.nh`. Gate: `nix flake check` + `nixos-rebuild build`.
- [x] **P1 — System modularization:** Port all system config into `modules/system/` feature-toggle modules; always-on core (boot, fs, networking, locale, users); feature toggles for GNOME, pipewire, keyd, snapper, virtualisation, ibus-rime, power, printing, flatpak. Gate: `nh os switch` boots correctly.
- [x] **P2 — Home modularization + cleanup:** Port all home config into `modules/home/` modules; replace homesw/sysw/MyBash with `nh` aliases; move VSCode to home (install-only); eliminate `with pkgs;`; port bash (PS1, aliases, `y()` function); delete dead code and scripts. Gate: `nh home switch`, `statix` + `deadnix` clean, no `with pkgs;`.
- [x] **P3 — Docs + cutover:** Rewrite README.md (new layout + nh workflow); add subdir READMEs; delete old `default/` tree; final `nix flake check`; merge `rebuild` → `main`; clear OVERRIDE.md.

**Rebuild complete.** All four phases merged to `main`. `default/` tree deleted; closures verified byte-identical across every phase boundary.

---

## Future / Deferred

- [ ] **Stylix multi-theme theming** — trialled partial Stylix (Everforest) and reverted (vanilla preferred for now). Future: define several base16 schemes and/or wallpaper-derived palettes (`stylix.image`), selectable via the reserved `myConfig.themeName` hook, switchable by rebuild (or runtime via NixOS specialisations). Scope GTK/cursor/fonts/ghostty/yazi; keep GNOME shell + night-theme-switcher in dconf; do NOT enable `targets.gnome` (User Themes extension crashed baremetal).
- [ ] **Flatpak → nixpkgs migration** — evaluate per-app: Obsidian, Bitwarden, MissionCenter are packaged; Zen stays flatpak; see DESIGN.md minimize-policy.
- [ ] **Declarative Kando config** — source `config.json` and `menus.json` from tuxies-wiki resources once layout is stable.
- [ ] **Declarative Solaar rules** — source `rules.yaml` from tuxies-wiki resources.
- [ ] **Declarative GNOME extensions** — re-attempt when nixpkgs version-matching for extensions is reliable (crashed baremetal 2026-06-18).
- [ ] **fastfetch config.jsonc** — declare custom fastfetch config once finalized.
- [ ] **fzf keybindings + defaultOptions** — declare when preferences are settled.
- [ ] **disko** — declarative partitioning; reinstall-time change.
- [ ] **impermanence** — ephemeral root; requires disko first.
- [ ] **Howdy facial login** — fiddly PAM; deferred until baremetal + motivation.
- [ ] **Second host (laptop)** — hosts/ + modules/ structure is ready; add when hardware arrives.
- [ ] **ibus-rime / rime-cantonese** — set up from scratch (system-level i18n.inputMethod ibus engine + home-side rime schemas); not currently configured (the prior home-only config was removed in the rebuild as it was never functional).

---

## Changelog

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

Flakes only copy git-tracked files — corrected all docs and `.gitignore` to reflect that `hardware-configuration.nix` must be tracked. Commit `8283da0` already re-tracked the file; docs lagged. Updated README install flow (8 numbered steps), `scripts/gen-hardware-config.sh` header. Strategy: single tracked file per machine.

### 2026-06-18 — dconf: GNOME shortcuts + tweaks ported

Ported tuxies-wiki gnome.md guide into home dconf:

- `gnome-keybindings.nix` — WM keybindings (workspace switching, window management, panel-run-dialog, media keys), Ghostty `<Super>Return`, Mission Center `<Ctrl><Shift>Esc`.
- `gnome-tweaks.nix` (new) — titlebar button layout, allow-volume-above-100-percent, mutter scale-monitor-framebuffer.

### 2026-06-18 — baremetal dconf crash fix

First baremetal run: declarative GNOME extension settings (gnome-shell + night-theme-switcher dconf) crashed due to extension version mismatch. Resolution: extensions are now fully imperative (GNOME Extensions app). Removed declarative package install and dconf enable blocks. Safe dconf (interface, clipboard, keybindings, input-sources) remains declarative.

### 2026-06-18 — declutter + hygiene

- yazi + ghostty migrated from `home.file` blobs to `programs.yazi` / `programs.ghostty` in home-configs.nix.
- Solaar + Kando config files sourced via `home.file .source` from tuxies-wiki resources (subsequently commented out — deferred).
- Won't-port items struck: Tiling Shell, v4l2loopback, Waydroid, Fluent icons/cursor.
- Added 3 subfolder READMEs (`default/`, `default/system/`, `default/home/`).

### 2026-06-18 — Wayland, grub-btrfs, ibus-rime, Solaar, Kando, portability

- **Wayland switch** — GDM Wayland on; removed X11 xkb block; `gnome-input-sources.nix` → GNOME layout `us+colemak_dh`.
- **grub-btrfs** — `services.grub-btrfs.enable` (pairs with snapper).
- **ibus-rime Cantonese schemas** — system engine override adds `rime-cantonese`; home config enables `luna_pinyin` + `jyut6ping3`.
- **Solaar** — `system-modules/system-solaar.nix` (`services.solaar`, tray-hide); subsequently commented out (deferred).
- **Kando** — `kando` pkg in system-apps; `~/.config/autostart/kando.desktop` in home.
- **Portability** — `scripts/gen-hardware-config.sh`; README per-device setup section.
