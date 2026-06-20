# aierNix — ROADMAP

Transfer the `tuxies-wiki` aiers-fedora-checklist setup into a clean, maintainable declarative Nix config. My preferences are canonical; the wiki is the starting point.

Design decisions and doctrine live in `DESIGN.md`. Working-pattern and orientation details live in `MEMORY.md`.

---

## Current State / Next Pickup

**For a fresh agent picking this up cold:** read this section first, then the detailed lists below.

### What's done

- **Best-practice rebuild (P0–P3) is complete and merged to `main`.** Layout is `hosts/` + `modules/` with standalone home-manager and `nh`. `default/` tree is deleted. See Changelog below for the full history.
- **This session (2026-06-19) completed:** Stylix theme-selector framework + vanilla profile; fastfetch via `programs.fastfetch.settings`; fzf default options; cursor DRY (dconf reads stylix cursor name); Kando + Solaar installed but their app-owned configs kept **imperative** (no embedded config files — see GUI-Owned Config doctrine); README "Manual setup (imperative)" section added; legacy catppuccin-grub theme removed; secrets imperative-by-design formally documented; GNOME battery charge-limit active on ASUS Zenbook S 16.
- **This session (2026-06-20) completed:** touchpad scroll-factor on Wayland via a declarative `libinput-config` (new `pkgs/libinput-config/` derivation + `modules/system/libinput-config.nix`, `mySystem.libinputConfig.enable`, scroll-factor `0.3`) — verified live (wrapper mapped into gnome-shell; scroll confirmed slower) and **completing OVERRIDE.md** (now cleared). Logged the key NixOS gotcha: glibc reads `/etc/ld-nix.so.preload`, **not** `/etc/ld.so.preload`.
- **Local `tuxies-wiki/` clone is already gone** — the directory does not exist. Everything needed was ported in-repo. The canonical reference wiki lives at GitHub `Theory-Y/tuxies-wiki`.

### Items of notice for the incoming agent

- **Repo rules now live in `CLAUDE.md` (read it).** Two hard rules: (1) **any system-config change requires explicit user approval before proceeding** — even in auto mode, even if requested — because this repo is a minimal universal template and system clobber must be avoided; (2) changes covered by Theory-Y's wiki (`~/Projects/tuxies-wiki`) **prompt the user** to dispatch an `opus-manager` to mirror them per that wiki's rules.

- **Kando + Solaar configs are imperative** (2026-06-19 refactor). The flake installs the Kando package + autostart and Solaar via `hardware.logitech.wireless`, but the menus (`config.json`/`menus.json`) and Solaar rules (`rules.yaml`) are owned by the apps' GUIs — a declarative symlink is read-only and blocks the editor's save (DESIGN.md L11). **Every manual post-install step now lives in README → "Manual setup (imperative)"** (Kando, Solaar, GNOME extensions, Bitwarden, VS Code). The **Kando Integration** GNOME extension stays **imperative** — install + enable it via the GNOME Extensions app before the Haptic-button → pie-menu chain works. (It is version-matched in nixpkgs and a home-side declarative install would be discoverable, but keeping it imperative is the deliberate leanness/GUI-owned decision — see L8.) After a fresh `nh home switch` Kando/Solaar configs reset to defaults; prior config is in git history + the wiki.
- **Stylix colorful themes:** the framework is already in place (`myConfig.themeName` selector in `hosts/aierNixOS/home.nix`, theme registry + `vanilla` profile in `modules/home/theming/stylix.nix`, with a commented `everforest` stub showing the full pattern). Adding a colorful theme = add an entry to the `themes` attrset + flip `themeName`. See the file header for step-by-step instructions.
- **Working pattern:** the agent builds and verifies in-harness (`nix flake check`, `nh os build`, `nh home build`, `nix store diff-closures`). The USER runs the live `nh os switch` / `nh home switch` in their own terminal. Never auto-activate. See `MEMORY.md` for the full pattern.
- **High-stakes deferred items** (Howdy) require explicit user go-ahead before any work is started. See annotations in Future/Deferred below.

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
- **Declarative GNOME extensions** — *decided against* (2026-06-19): extensions are fully imperative by choice (leanness / simpler mental model). See L8 + changelog. (Was Phase 0/1; reverted.)
- [ ] **Howdy facial login** — **requires explicit user go-ahead before starting; highest-stakes item (PAM integration, lockout risk).** Deferred until baremetal + user motivation.
- [ ] **Second host (laptop)** — **blocked on hardware (not present).** `hosts/` + `modules/` structure is ready; add when the device arrives.
- [ ] **nixfmt deprecation warning** — `nix flake check` emits `nixfmt-rfc-style is now the same as pkgs.nixfmt which should be used instead` on every run. Low-priority hygiene: switch the formatter/devShell reference from `nixfmt-rfc-style` to `pkgs.nixfmt`.
- [ ] **disko** — declarative partitioning; reinstall-time change. **Deferred indefinitely — do NOT raise unless the user explicitly asks.**
- [ ] **impermanence** — ephemeral root; requires disko first. **Deferred indefinitely — do NOT raise unless the user explicitly asks.**

---

## Changelog

### 2026-06-20 — Touchpad scroll-factor on Wayland (declarative libinput-config) — completes OVERRIDE

Ported the `shivasai573/touchpad-sensitivity-tweak` fix (GNOME/mutter on Wayland exposes no scroll-speed slider) to a declarative module instead of its FHS installer (apt/dnf/pacman + `ninja install` to `/usr/local` + `/etc/ld.so.preload` — none of which work on NixOS; its `install_fix.sh` has no NixOS branch and dies at `meson setup`). New `pkgs/libinput-config/default.nix` builds the wrapper (lz42 mirror, rev `986afe8`, ISC) against the system `libinput-1.31.3`, skipping upstream's `/etc/ld.so.preload`-editing install script and installing only the `.so` (which links nothing but glibc — it interposes libinput symbols at runtime via `RTLD_NEXT`). New `modules/system/libinput-config.nix` (`mySystem.libinputConfig.enable` + `scrollFactor`, str, default `"0.3"`) writes the preload file + `/etc/libinput.conf` with `scroll-factor` only (so GNOME keeps owning tap/natural-scroll). Host wired: import + `libinputConfig.enable = true`.

**Key NixOS gotcha (cost a debug cycle, now in MEMORY):** nixpkgs patches glibc's loader to read **`/etc/ld-nix.so.preload`**, NOT the standard `/etc/ld.so.preload` the upstream tool and every FHS distro use (verify: `grep -a 'ld-nix.so.preload' <glibc>/lib/ld-linux-x86-64.so.2`). The first version wrote `/etc/ld.so.preload` → the loader silently ignored it → the wrapper never loaded → scrolling stayed at the default factor (1.0). Fixed by targeting `environment.etc."ld-nix.so.preload"`. The `LD_PRELOAD` env var works fine; only the file name differs.

Verified after `nixos-rebuild switch` + relogin: the wrapper is mapped into the live compositor (`grep -c libinput-config /proc/<gnome-shell>/maps` > 0) and scrolling is confirmed slower. Gate: `nixos-rebuild build` (closure builds) + live verification. **System change (user-approved + user-activated).** NixOS-specific (the `ld-nix.so.preload` mechanism), so **not** mirrored to the wiki.

This completes **OVERRIDE.md item 1** (the touchpad-sensitivity-tweak port). Item 2 (keyd virtual-keyboard quirk → `AttrKeyboardIntegration=internal` so disable-while-typing works) is implemented in `modules/system/keyd.nix` and **verified live this session**: the keyd virtual keyboard (`event25`, name exact-match) reports `AttrKeyboardIntegration=internal` via `libinput quirks list`, the quirk file passes `libinput quirks validate`, and the touchpad (`ASUF1209:00 2808:0219 Touchpad`, `event19`) is an internal multitouch DWT-capable device on mutter/Wayland's libinput backend. The only un-run check is the cosmetic `sudo libinput list-devices` → touchpad `Disable-while-typing: enabled` line (needs root). OVERRIDE.md is cleared.

### 2026-06-19 — Reverted declarative GNOME extensions → fully imperative by choice

Reverted Phase 0 (the 6 `gnomeExtensions.*` packages in `home-pkgs.nix`) and dropped the never-wired Phase 1 (the `enabled-extensions` dconf in `gnome-dconf/gnome-shell.nix` — a commented-out import in `dconf.nix`, so it was never active). Deleted `gnome-shell.nix` and `gnome-night-theme.nix` (both extension dconf, both un-imported), removed their commented imports from `dconf.nix`, dropped the stale `copyous` comment in `gnome-clipboard.nix`, and removed `action-plans/declarative-gnome-extensions.md`. Decision (supersedes the Phase 0/1 plan): all GNOME extensions are installed + managed **imperatively** via the GNOME Extensions app — to cut maintenance scope, simplify the repo's mental model, and rely on the well-documented manual steps in tuxies-wiki. The L8 *factual* correction stands (a `home.packages` install IS gnome-shell-discoverable); we simply choose not to use it. Extensions keep working through the revert (imperative copies in `~/.local/share/gnome-shell/extensions/` untouched; live `enabled-extensions` dconf was never managed). Gate: `nix flake check` + `nh home build`.

### 2026-06-19 — Stylix colorful theme profiles + legacy GTK (adw-gtk3) fix

Added three selectable colorful Stylix profiles alongside `vanilla` (still active) via the `themeName` selector in `modules/home/theming/stylix.nix`: **catppuccin** (Mocha), **everforest** (Dark Hard), **wallpaper-based** (`stylix.image`, NixOS `simple-dark-gray` default). Each turns on the GTK/cursor/fonts/ghostty/yazi targets with `gnome = false` (User-Themes shell target stays off — it crashed baremetal) and pins `fontSizeApplications = 11`. **Legacy GTK fix:** the home-manager `gtk` module is now enabled unconditionally (`theme.name = adw-gtk3` for GTK2/3, `gtk4.theme = mkDefault null`) so legacy / non-libadwaita GTK apps render with adw-gtk3 under `vanilla` too — they were previously unthemed. Reconciled the hand-set dconf `org/gnome/desktop/interface` keys (`font-name`/`gtk-theme`/`cursor-theme`) to `lib.mkDefault` so the gtk module wins when a colorful profile is active and the defaults hold under vanilla. Confirmed after `nh home switch` (legacy apps now adw-gtk3). Gate: `nix flake check` + `nh home build`. Action plan: `action-plans/stylix-colorful-theme.md`.

### 2026-06-19 — Solaar KeyPress on Wayland (uinput access)

**Fixed** Solaar "Key press" rules (Haptic→Kando + every keyboard/mouse remap) silently failing on Wayland: Solaar injects keystrokes via `/dev/uinput` on Wayland (XTest is X11-only), but the node is `root:uinput 0660` and the user wasn't in the `uinput` group, so injection got permission-denied. Enabled `hardware.uinput.enable` (`modules/system/solaar.nix`) and added `aier` to the `uinput` group (`modules/system/core/users.nix`). Verified against Solaar 1.1.19 source (`diversion.py`: the Wayland path calls `setup_uinput` → `simulate_uinput`) and live `/proc/<pid>/environ`. **NixOS-specific** — Fedora grants uinput access out of the box; NixOS does not. Requires `nh os switch` + **reboot/re-login** for the group to apply (a Solaar process from the pre-change session lacks it). Confirmed working after reboot. System change (user-approved). NixOS-specific, so **not** mirrored to the wiki.

### 2026-06-19 — Claude Code image paste (clipboard tools)

- **Fixed** Claude Code's terminal image paste failing with "no image found in clipboard" on the Wayland GNOME session: added `wl-clipboard` + `xclip` to `home-pkgs.nix` (CLI/dev tools). Claude Code reads pasted images via `xclip … || wl-paste …` and NixOS ships neither by default (Fedora/Ubuntu do). `wl-clipboard` handles the Wayland clipboard; `xclip` covers XWayland-sourced images. Confirmed working after `nh home switch`. Home-side change (ungated). NixOS-specific, so **not** mirrored to the wiki.

### 2026-06-19 — Colemak-DH layout fix, fastfetch de-box, yazi g→.; repo rules

- **Colemak-DH:** set the GNOME xkb input source to `us+colemak_dh` (the rime input-source change had clobbered it to plain `us`). Corrected the doctrine — Colemak letters come from this xkb source, **not** keyd (keyd only remaps modifiers); DESIGN L4 fixed.
- **fastfetch:** de-boxed the 3 section headers — dropped the `┌`/`┐` corners, kept the centered dashed title (`──── Hardware ────`) — so long lines (e.g. Packages) no longer overflow a box border. (fastfetch's packages module is inherently single-line; true multi-line would need a custom command module.)
- **yazi:** added `g .` → `cd ~/.dotfiles`.
- **Repo rules (`CLAUDE.md`, new):** (1) system-config changes require explicit user approval before proceeding, even in auto mode; (2) wiki-covered changes prompt before mirroring to `~/Projects/tuxies-wiki` via an opus-manager.

Gate: `nix flake check` + `nh home build` (all home-side). Wiki mirror (fastfetch `config.jsonc` + yazi/terminal guides) dispatched to an opus-manager.

### 2026-06-19 — rime-cantonese IME (ibus-rime, greenfield)

Re-implemented ibus-rime input, doing **both** halves this time (the prior home-only attempt had no system engine registration — almost certainly why it never worked). System: `modules/system/ibus.nix` (`mySystem.ibus.enable`) sets `i18n.inputMethod` (type `ibus`, engine `ibus-engines.rime`). Home: `modules/home/misc/ibus-rime.nix` (`myHome.ibusRime.enable`) writes `default.custom.yaml` enabling `luna_pinyin` (Pinyin) + `jyut6ping3` (Cantonese Jyutping) — both ship in the engine's bundled rime-data, so no `rimeDataPkgs` override. dconf `gnome-input-sources.nix` adds the `('ibus','rime')` input source. Verified in-store: engine name `rime`, component lands at `/run/current-system/sw/share/ibus/component/rime.xml` (GNOME's ibus-daemon scans there), yaml renders valid. **Needs `nh os switch` + `nh home switch` + logout/login** (Wayland can't restart ibus in place); rime deploys schemas on first switch; default schema `luna_pinyin`, switch to `jyut6ping3` with F4 / Ctrl+`. Action plan: `action-plans/rime-cantonese-ime.md`. Gate: `nix flake check` + `nh os/home build`.

### 2026-06-19 — Flatpak → nixpkgs migration

Migrated 5 cleanly-packaged apps off flatpak into `home.packages` (`modules/home/apps/home-pkgs.nix`): Obsidian, Mission Center, Kooha, Extension Manager (`gnome-extension-manager`), Gradia. Removed from the nix-flatpak list (flatpak count 9 → 4). **Bitwarden stayed on flatpak** — its nixpkgs build (`bitwarden-desktop`) pulls an insecure electron (`electron-39.8.10`), and the sandbox is preferable for a secrets app anyway. Also staying (not packaged): Zen (browser; sandbox desirable), Flatseal (flatpak-perms tool), rclone-manager. Per DESIGN minimize-policy. Note: nix-flatpak uninstalls the 5 on switch and `~/.var/app/` data does not carry to native config dirs — re-open the Obsidian vault (vault files untouched); the other 4 hold no meaningful state. Kooha relies on the PipeWire screencast portal (GNOME provides it). Also updated the Mission Center custom keybinding (`<Ctrl><Shift>Esc`) from `flatpak run io.missioncenter.MissionCenter` to the native `missioncenter` command (it had been ported from the flatpak-oriented wiki) — verified the binary resolves on the gsd-media-keys PATH via `~/.nix-profile/bin`. Gate: `nix flake check` + `nh home build`.

### 2026-06-19 — GNOME extensions Phase 0: packages declared home-side; DESIGN L8 corrected

- **Phase 0 implemented:** added 6 version-matched GNOME Shell extensions to `home.packages` in `modules/home/apps/home-pkgs.nix`: `gnomeExtensions.appindicator`, `.blur-my-shell`, `.caffeine`, `.copyous`, `.focus-changer`, `.dash-to-dock`. No dconf change (enablement still imperative). kando-integration deliberately excluded (stays fully imperative — leanness/GUI-owned decision). This is purely additive: extensions are already imperatively installed and enabled; Phase 0 only puts Nix-managed copies on the HM profile share path.
- **DESIGN L8 corrected (false mechanism claim):** the previous L8 stated declarative extension install via `home.packages` requires a system module because gnome-shell doesn't scan the standalone HM profile. This was **empirically refuted**: direct `/proc/<pid>/environ` measurement shows gnome-shell's actual `XDG_DATA_DIRS` (from the systemd `--user` environment) includes `~/.nix-profile/share`, which resolves to the standalone HM profile. `pkgs.gnomeExtensions.*` packages install to `<profile>/share/gnome-shell/extensions/<uuid>/` and ARE discovered by gnome-shell. The home-side path is ungated (home-manager, not system). Caveat: discoverable ≠ live without re-login on Wayland — a newly-added extension isn't loaded by the running shell until the next login. L8, the GUI-Owned Config doctrine, and the Kando changelog entry updated accordingly.

### 2026-06-19 — Kando Integration extension kept imperative (declarative install evaluated, declined)

Evaluated installing the Kando Integration GNOME extension declaratively, then declined to keep the system config lean. Findings (recorded so this isn't re-litigated): the extension is version-matched in nixpkgs (`gnomeExtensions.kando-integration`, metadata `shell-version` includes our GNOME 50). The declarative install path was evaluated as a **home-side** path (`home.packages`) — this is viable because gnome-shell's real `XDG_DATA_DIRS` (verified via `/proc/<pid>/environ` 2026-06-19) includes `~/.nix-profile/share`, resolving to the standalone HM profile; a `home.packages` extension IS discovered (the earlier finding that a system module was required was incorrect — see 2026-06-19 correction below). Declined regardless: the Kando Integration extension stays **imperative** (install + enable via the GNOME Extensions app) on **leanness and GUI-owned** grounds, not a discoverability constraint — consistent with L8 as corrected. *Enable* was never going to be declarative anyway (home-manager dconf would clobber the other hand-enabled extensions).

### 2026-06-19 — Kando + Solaar configs made imperative; README "Manual setup" section

Reverted the declarative config-file management for Kando and Solaar. A declarative `xdg.configFile`/`.source` link is a read-only Nix-store symlink, so the apps' own editors cannot save to it. Now: install + enablement stay declarative (Kando package + autostart `.desktop`; Solaar via `hardware.logitech.wireless` + udev), but `kando-config.json`, `kando-menus.json`, and `solaar-rules.yaml` were deleted and those configs are owned imperatively by the app GUIs. Deleted the Solaar home module (`modules/home/misc/solaar.nix`) entirely + removed its import/toggle; the system module stays. Added DESIGN.md "GUI-Owned Config — Imperative by Design" doctrine + L11. New README section **"Manual setup (imperative)"** documents every manual post-install step (Kando, Solaar, GNOME extensions, Bitwarden, VS Code). Fixed adjacent README layout drift (gh.nix, theming fonts/stylix, system solaar). Prior config preserved in git history + Theory-Y/tuxies-wiki. Gate: `nix flake check` passed.

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
