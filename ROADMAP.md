# aierNix — ROADMAP

Transfer the `tuxies-wiki` aiers-fedora-checklist setup into a clean, maintainable declarative Nix config. My preferences are canonical; the wiki is the starting point.

Design decisions and doctrine live in `DESIGN.md`. Working-pattern and orientation details live in `MEMORY.md`.

> **Status: archived.** The port is complete (~95% of the Fedora setup). This file is now a record of progress plus a list of deferred ideas for anyone forking.

---

## Current State

### Done

- **Best-practice rebuild (P0–P3) complete and merged to `main`.** Layout is `hosts/` + `modules/` with standalone home-manager and `nh`; the old `default/` tree is gone; closures verified byte-identical across every phase boundary.
- **Theming:** Stylix theme-selector framework in place — `vanilla` active, with `catppuccin`, `everforest`, and `wallpaper-based` profiles defined and ready to select via `myConfig.themeName`. Legacy GTK apps themed via adw-gtk3.
- **Input:** Colemak-DH (xkb), keyd modifier remaps + disable-touchpad-while-typing, ibus + Rime (Pinyin + Cantonese Jyutping), and touchpad scroll-factor on Wayland (declarative libinput-config).
- **Desktop:** GNOME/Wayland; dconf (interface, clipboard, keybindings, tweaks, input sources); pipewire; fonts; battery charge-limit (ASUS Zenbook S 16).
- **Apps:** most apps native via `home.packages`; flatpak trimmed to the few that want the sandbox (Bitwarden, Zen, Flatseal, rclone-manager); VS Code install-only (Settings Sync owns config).
- **Imperative by design:** Kando menus, Solaar device rules, GNOME extensions, and secrets are GUI/account-owned — installed declaratively, configured manually (README → Manual setup).
- **OpenWhispr** voice dictation added (upstream flake module + Wayland auto-paste plumbing). Browser sign-in works; auto-paste does not (see below).

### Known open

- **OpenWhispr auto-paste is UNTESTED / broken.** Web sign-in via the `openwhispr://` handler works, but auto-paste likely types a literal `v` (the Ctrl modifier is dropped from the injected Ctrl+V). Suspected: a uinput device-enumeration race, or keyd intercepting the injected event under Colemak-DH. Needs investigation before OpenWhispr is usable end-to-end.

### Notes for anyone forking

- **Repo rules live in `CLAUDE.md`:** (1) system-config changes need explicit user approval first — this is a minimal template, so system clobber must be avoided; (2) wiki-covered changes prompt before mirroring to `~/Projects/tuxies-wiki`.
- **Working pattern:** the agent builds + verifies (`nix flake check`, `nh os/home build`, `nix store diff-closures`); the user runs the live `nh os/home switch`. Never auto-activate. See `MEMORY.md`.
- **High-stakes deferred items (Howdy) need explicit user go-ahead before any work starts.**

---

## Active Plan — Best-Practice Rebuild (complete)

Full restructure into `hosts/` + `modules/` with standalone home-manager and a quality gate. See `action-plans/nix-structuring-rebuild.md` for the phase breakdown and file-mapping table.

- [x] **P0 — Scaffold:** `rebuild` branch; `lib/mkHost+mkHome`; host/module/overlay/pkg scaffold; `flake.nix` (standalone HM, devShell, git-hooks, `.envrc`); `programs.nh`.
- [x] **P1 — System modularization:** all system config ported into feature-toggle modules; always-on core (boot, fs, networking, locale, users).
- [x] **P2 — Home modularization + cleanup:** all home config into modules; `nh` aliases; VS Code → home (install-only); no `with pkgs;`; dead code removed.
- [x] **P3 — Docs + cutover:** README rewrite (new layout + `nh`); subdir READMEs; `default/` deleted; merged `rebuild` → `main`.

All four phases merged. Closures byte-identical across every phase boundary.

---

## Future / Deferred

- [ ] **Stylix colorful theme** — framework and profiles (catppuccin / everforest / wallpaper-based) are already defined. Remaining work: flip `myConfig.themeName` to one of them. Scope: GTK/cursor/fonts/ghostty/yazi targets; keep GNOME shell + night-theme-switcher in dconf; do **not** enable `targets.gnome` (User Themes extension crashed baremetal).
- **Declarative GNOME extensions** — *decided against* (2026-06-19): extensions are fully imperative by choice (leanness / simpler mental model). See DESIGN L8.
- [ ] **Howdy facial login** — **requires explicit user go-ahead before starting; highest-stakes item (PAM integration, lockout risk).** Deferred until baremetal + user motivation.
- [ ] **Second host (laptop)** — **blocked on hardware (not present).** The `hosts/` + `modules/` structure is ready; add when the device arrives.
- [ ] **nixfmt deprecation warning** — `nix flake check` emits `nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead`. Low-priority hygiene: switch the formatter/devShell reference to `pkgs.nixfmt`.
- [ ] **disko** — declarative partitioning; reinstall-time change. **Deferred indefinitely — do NOT raise unless the user explicitly asks.**
- [ ] **impermanence** — ephemeral root; requires disko first. **Deferred indefinitely — do NOT raise unless the user explicitly asks.**

---

## Changelog

### 2026-06-20 — OpenWhispr voice dictation; module consolidation; repo archived

- OpenWhispr via the upstream flake (`nixosModules.default`): new `modules/system/openwhispr.nix` sets up the ydotool/uinput/input groups and registers `open-whispr.desktop` as the `openwhispr://` handler (fixes browser sign-in). System change (user-approved).
- Consolidation: deleted the dead `desktop/fonts.nix` stub; moved per-user locale to `hosts/aierNixOS/locale.nix` (system-wide); documented flatpak's required system/home split.
- Repo archived as a community starting-point template.
- **Known open:** OpenWhispr auto-paste UNTESTED / broken (see Known open above).

### 2026-06-20 — Solaar autostart declared

Declarative autostart `.desktop` for Solaar (`Exec=solaar --window=hide`, system-side in `/etc/xdg/autostart`), so "start at login" no longer needs the GUI toggle. Device rules stay imperative. System change (user-approved).

### 2026-06-20 — Touchpad scroll-factor on Wayland (completes OVERRIDE)

Declarative `libinput-config` (new `pkgs/libinput-config/` + `modules/system/libinput-config.nix`) instead of the upstream FHS installer. **Key NixOS gotcha:** nixpkgs' loader reads `/etc/ld-nix.so.preload`, not `/etc/ld.so.preload` (now in MEMORY). Verified live. Also completed the keyd internal-keyboard quirk (disable-while-typing). System change (user-approved + activated). OVERRIDE cleared.

### 2026-06-19 — GNOME extensions → fully imperative (declarative reverted)

Reverted the declarative extension packages/dconf; all GNOME extensions are now installed + managed imperatively by choice (leanness, simpler mental model). The factual L8 correction stands — a `home.packages` install IS gnome-shell-discoverable; we simply choose not to use it.

### 2026-06-19 — Stylix colorful profiles + legacy GTK fix

Added `catppuccin`, `everforest`, and `wallpaper-based` profiles alongside `vanilla` (still active), each with `gnome = false` (User Themes crashed baremetal) and the GTK app font pinned to 11. Legacy GTK apps now render with adw-gtk3 (HM gtk module enabled unconditionally).

### 2026-06-19 — Solaar KeyPress on Wayland (uinput access)

Fixed Solaar key-injection silently failing on Wayland: enabled `hardware.uinput` and added the user to the `uinput` group (Solaar injects via `/dev/uinput`; XTest is X11-only). NixOS-specific. System change (user-approved).

### 2026-06-19 — Claude Code image paste

Added `wl-clipboard` + `xclip` so Claude Code's terminal image paste works on Wayland (NixOS ships neither by default).

### 2026-06-19 — Colemak-DH fix, fastfetch de-box, yazi g→.; repo rules

Colemak letters come from the `us+colemak_dh` xkb source, not keyd (doctrine corrected, DESIGN L4). De-boxed the fastfetch headers; added yazi `g .` → `~/.dotfiles`. New `CLAUDE.md` repo rules.

### 2026-06-19 — rime-cantonese IME (greenfield)

Re-implemented ibus-rime doing both halves: system engine registration (`modules/system/ibus.nix`) + home schema list (`modules/home/misc/ibus-rime.nix`: luna_pinyin + jyut6ping3). The prior home-only attempt had no system engine — likely why it never worked.

### 2026-06-19 — Flatpak → nixpkgs migration

Moved 5 cleanly-packaged apps off flatpak into `home.packages` (flatpak count 9 → 4). Bitwarden stayed on flatpak (its nixpkgs build pulls an insecure electron, and a sandbox is preferable for a secrets app).

### 2026-06-19 — GNOME extensions Phase 0 + DESIGN L8 correction

(Superseded by the later full-imperative revert.) Declared 6 extensions home-side and corrected the false claim that a system module was required — gnome-shell's `XDG_DATA_DIRS` includes the HM profile, so `home.packages` extensions ARE discovered.

### 2026-06-19 — Kando + Solaar configs made imperative; README "Manual setup"

A declarative config symlink is a read-only store path, so the apps' own editors can't save to it. Install + enablement stay declarative; the config files (Kando menus, Solaar rules) are now GUI-owned. Added the DESIGN "GUI-Owned Config" doctrine + L11 and the README "Manual setup (imperative)" section.

### 2026-06-19 — Secrets: imperative-by-design

No declarative secrets backend (sops-nix / agenix). Secrets are app-managed (e.g. Bitwarden) and synced via the user's account.

### 2026-06-18 — GNOME battery charge-limit

Enabled on the ASUS Zenbook S 16 — custom udev rule + hwdb `CHARGE_LIMIT=_,80` in `modules/system/power.nix` (asus_wmi exposes only an end threshold, so the start threshold is backfilled via hwdb).

### 2026-06-18 — best-practice rebuild complete

Full `hosts/` + `modules/` restructure, standalone HM, quality gate, `nh` workflow; `default/` tree deleted; P0–P3 merged to main. Closures byte-identical across every phase boundary.

### 2026-06-18 — planning + earlier groundwork

- Planning artifacts written: `action-plans/nix-structuring-rebuild.md`, `DESIGN.md`, ROADMAP + OVERRIDE.
- hardware-config tracking corrected — flakes only copy git-tracked files, so `hardware-configuration.nix` must be tracked.
- dconf: GNOME shortcuts + tweaks ported from the wiki guide.
- Baremetal dconf crash fix → extensions made imperative; safe dconf (interface, clipboard, keybindings, input-sources) stays declarative.
- Stylix trialled and reverted to vanilla; yazi/ghostty migrated to `programs.*`.
- Wayland switch (GDM Wayland, `us+colemak_dh`), grub-btrfs, initial ibus-rime/Solaar/Kando, `nodejs` added, portability/per-device README section.
