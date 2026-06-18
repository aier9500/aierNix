# aierNix Structuring Rebuild — Action Plan

**Goal:** Rebuild the aierNix flake from its current flat `default/` layout into a best-practice `hosts/` + `modules/` structure with a `lib/` helper layer, standalone home-manager, and a full quality gate — without losing any working user functionality.

---

## Scope

**In scope:**
- Full directory restructure: `lib/`, `hosts/aierNixOS/`, `modules/system/`, `modules/home/`
- Rewrite `flake.nix`: vanilla flake + `mkHost`/`mkHome` helpers, rename outputs to `aierNixOS`, standalone HM
- Feature-toggle options pattern for all non-essential modules
- `modules/options.nix` for cross-cutting values (`myConfig.*`)
- Quality gate: nixfmt-rfc-style formatter, statix + deadnix linters, git-hooks.nix pre-commit hook
- `devShell` + `.envrc` (nix-direnv), `programs.nh` with periodic GC
- VSCode moved from system to home (install-only, no Nix config)
- Delete homesw.sh / sysw.sh / MyBash and their `home.file` emission; replace with `nh` aliases
- Remove all `with pkgs;` usage; replace with `pkgs.foo`
- Remove dead/commented code (system-solaar commented import, empty home-modules.nix, etc.)
- Port bash config (PS1, aliases, yazi `y()`) declaratively into the home bash module
- Scaffold `overlays/` and `pkgs/` directories (empty, for future use)
- P3 doc updates: rewrite ROADMAP.md, finalize DESIGN.md, update README.md, regenerate subdir READMEs, convert OVERRIDE.md to pointer, final `nix flake check`, merge `rebuild` → `main`

**Out of scope (deferred — see ROADMAP.md Future section):**
- Stylix theming
- Flatpak → nixpkgs migration
- Declarative config files for Kando, Solaar, obs-studio, fastfetch, fzf
- disko + impermanence
- Secrets backend
- Declarative GNOME extensions
- Second host

---

## Locked Architecture Decisions

| # | Decision | Detail |
|---|---|---|
| A1 | Flake style | Vanilla flake + `lib/default.nix` with `mkHost`/`mkHome` helpers |
| A2 | Output naming | `nixosConfigurations.aierNixOS` and `homeConfigurations.aier` (by hostname/user, not `.default`) |
| A3 | home-manager mode | **Standalone** — NOT wired as NixOS module. System: `nh os switch`. Home: `nh home switch`. |
| A4 | Options pattern | Feature-toggle modules: each module declares its own `mySystem.<feature>.enable` or `myHome.<feature>.enable` via `lib.mkEnableOption`; gates config with `lib.mkIf cfg.enable`. Core modules (boot, fs, networking, locale, users) are always-on. |
| A5 | Cross-cutting values | `modules/options.nix` declares `myConfig.*` (user, hostname, timezone, locale, theme name, etc.) only — not feature toggles |
| A6 | Host file role | `hosts/aierNixOS/default.nix` sets `myConfig.*` values and flips on feature toggles for this machine |
| A7 | Channel | Stay on `nixos-unstable` |
| A8 | Quality gate | nixfmt-rfc-style (formatter), statix + deadnix (linters), git-hooks.nix pre-commit, devShell via `nix develop` |
| A9 | Tooling | `nh` via `programs.nh` (flake path + periodic GC). Delete hand-rolled scripts. Day-to-day: `nh os switch` / `nh home switch` / `nh clean` |
| A10 | No CI | Quality gate is local only (pre-commit + `nix flake check`) |

---

## Target Directory Layout

```
flake.nix
flake.lock
README.md
ROADMAP.md
DESIGN.md
.envrc

lib/
  default.nix                  # mkHost + mkHome helper functions

hosts/
  aierNixOS/
    default.nix                # sets myConfig.* values, enables feature toggles, imports hardware-configuration.nix
    hardware-configuration.nix # tracked (flakes require git-visible files)
    home.nix                   # home-manager entry for this host (sets myConfig.*, enables home toggles)

modules/
  options.nix                  # myConfig.* cross-cutting values (user, hostname, timezone, locale, theme)
  system/
    core/
      boot.nix                 # bootloader (grub EFI + catppuccin theme, grub-btrfs), btrfs fs-support — always-on
      fs.nix                   # snapper btrfs timeline snapshots — always-on
      networking.nix           # hostname, networkmanager, hostId — always-on
      locale.nix               # timezone, i18n, locale settings — always-on
      users.nix                # users.users.aier definition, extraGroups — always-on
    desktop/
      gnome.nix                # GNOME + GDM + Wayland + excludePackages — mySystem.desktop.gnome.enable
      pipewire.nix             # pipewire + rtkit + alsa + pulse, disable pulseaudio — mySystem.desktop.pipewire.enable
      fonts.nix                # system-level font packages (noto-cjk-serif, noto-cjk-sans, ibm-plex) — mySystem.desktop.fonts.enable
    keyd.nix                   # keyd Colemak DH remap — mySystem.keyd.enable
    snapper.nix                # snapper btrfs timeline config for root — mySystem.snapper.enable
    virtualisation.nix         # libvirtd — mySystem.virtualisation.enable
    flatpak.nix                # services.flatpak.enable (system-level enablement) — mySystem.flatpak.enable
    ibus-rime.nix              # ibus + ibus-engines.rime override (rime-cantonese) — mySystem.ibusRime.enable
    power.nix                  # power-profiles-daemon — mySystem.power.enable
    printing.nix               # CUPS printing — mySystem.printing.enable
    nix.nix                    # nix.settings: experimental-features, programs.nh, nixpkgs.config.allowUnfree, system.stateVersion
    system-pkgs.nix            # environment.systemPackages: git, gparted, ffmpeg-full, home-manager, ntfs3g, usbutils; programs.git, localsend, nautilus-open-any-terminal, appimage
  home/
    shell/
      bash.nix                 # programs.bash: PS1, bashrcExtra (fastfetch call), aliases (nh-based homesw/sysw replacements, cls, cmd, zh, nixse, eza tree aliases), yazi y() function — myHome.shell.bash.enable
    cli/
      eza.nix                  # programs.eza — myHome.cli.eza.enable
      fzf.nix                  # programs.fzf — myHome.cli.fzf.enable
      zoxide.nix               # programs.zoxide — myHome.cli.zoxide.enable
      yazi.nix                 # programs.yazi (settings, keymap, theme) — myHome.cli.yazi.enable
      fastfetch.nix            # programs.fastfetch — myHome.cli.fastfetch.enable
    terminal/
      ghostty.nix              # programs.ghostty (theme, opacity, blur, window size) — myHome.terminal.ghostty.enable
    apps/
      vscode.nix               # home.packages = [pkgs.vscode] only — no Nix config; Settings Sync handles config — myHome.apps.vscode.enable
      obs-studio.nix           # programs.obs-studio — myHome.apps.obsStudio.enable
      flatpak-home.nix         # services.flatpak + nix-flatpak packages list — myHome.apps.flatpak.enable
    theming/
      gnome-dconf/
        gnome-desktop-interface.nix  # (moved from default/home/home-dconf/)
        gnome-clipboard.nix          # (moved)
        gnome-keybindings.nix        # (moved)
        gnome-tweaks.nix             # (moved)
        gnome-input-sources.nix      # (moved)
        gnome-shell.nix              # (moved — keep file, remains commented in aggregator; GNOME extension deferred)
        gnome-night-theme.nix        # (moved — keep file, remains commented in aggregator; deferred)
      dconf.nix                # aggregator: imports gnome-dconf/*.nix (same commented pattern as current home-dconf.nix) — myHome.theming.gnome.enable
      cursors.nix              # bibata-cursors install — myHome.theming.cursors.enable
    misc/
      ibus-rime-home.nix       # home.file .config/ibus/rime/default.custom.yaml (luna_pinyin + jyut6ping3) — myHome.ibusRime.enable
      kando.nix                # kando autostart .desktop + home.packages [pkgs.kando] — myHome.kando.enable
      fonts-home.nix           # home.file font symlinks (ibm-plex, noto-cjk-serif, noto-cjk-sans) — myHome.fonts.enable

overlays/
  default.nix                  # empty overlay scaffold

pkgs/
  default.nix                  # empty custom packages scaffold
```

---

## File-by-File OLD → NEW Mapping

| Current Path | New Path | Action | Notes |
|---|---|---|---|
| `flake.nix` | `flake.nix` | **Rewrite** | Vanilla + helpers, rename outputs, standalone HM, add devShell + .envrc + git-hooks input |
| `default/configuration.nix` | — | **Delete / split** | Content distributed into `hosts/aierNixOS/default.nix` + `modules/system/core/*` |
| `default/hardware-configuration.nix` | `hosts/aierNixOS/hardware-configuration.nix` | **Move** | Stays tracked |
| `default/home.nix` | `hosts/aierNixOS/home.nix` | **Move + rewrite** | Becomes HM entry pointing to modules |
| `default/imports/system-imports.nix` | — | **Delete** | Replaced by `hosts/aierNixOS/default.nix` imports list |
| `default/imports/home-imports.nix` | — | **Delete** | Replaced by `hosts/aierNixOS/home.nix` imports list |
| `default/system/system-apps.nix` | `modules/system/system-pkgs.nix` + split | **Split** | Non-essential programs move to respective feature modules; essentials to system-pkgs.nix; VSCode moves to `modules/home/apps/vscode.nix` |
| `default/system/system-configs.nix` | Split into `modules/system/core/boot.nix`, `core/fs.nix`, `modules/system/snapper.nix`, `modules/system/nix.nix`, `modules/system/power.nix`, `modules/system/printing.nix` | **Split** | Desktop config moves to `modules/system/desktop/gnome.nix` + `pipewire.nix` |
| `default/system/system-modules.nix` | — | **Delete** | Replaced by feature module imports in host file |
| `default/system/system-modules/system-keyd.nix` | `modules/system/keyd.nix` | **Move + toggle** | Add `mySystem.keyd.enable` option |
| `default/system/system-modules/system-solaar.nix` | — | **Delete** | Commented out + dead; Solaar config deferred |
| `default/home/home-apps.nix` | Split into `modules/home/cli/`, `modules/home/apps/`, `modules/home/theming/` | **Split** | CLI tools → cli/; apps → apps/; theming packages → theming/ |
| `default/home/home-configs.nix` | Split into `modules/home/terminal/ghostty.nix`, `modules/home/shell/bash.nix`, `modules/home/cli/yazi.nix`, `modules/home/cli/eza.nix`, `modules/home/cli/fzf.nix`, `modules/home/cli/zoxide.nix`, `modules/home/cli/fastfetch.nix` | **Split** | Each program gets its own module |
| `default/home/home-files.nix` | Split into `modules/home/misc/ibus-rime-home.nix`, `modules/home/misc/kando.nix`, `modules/home/misc/fonts-home.nix` | **Split** | MyBash/homesw/sysw entries deleted; font symlinks → fonts-home.nix |
| `default/home/home-modules.nix` | — | **Delete** | Empty file |
| `default/home/home-dconf.nix` | `modules/home/theming/dconf.nix` | **Move** | Same aggregator pattern |
| `default/home/home-dconf/gnome-desktop-interface.nix` | `modules/home/theming/gnome-dconf/gnome-desktop-interface.nix` | **Move** | |
| `default/home/home-dconf/gnome-clipboard.nix` | `modules/home/theming/gnome-dconf/gnome-clipboard.nix` | **Move** | |
| `default/home/home-dconf/gnome-keybindings.nix` | `modules/home/theming/gnome-dconf/gnome-keybindings.nix` | **Move** | |
| `default/home/home-dconf/gnome-tweaks.nix` | `modules/home/theming/gnome-dconf/gnome-tweaks.nix` | **Move** | |
| `default/home/home-dconf/gnome-input-sources.nix` | `modules/home/theming/gnome-dconf/gnome-input-sources.nix` | **Move** | |
| `default/home/home-dconf/gnome-shell.nix` | `modules/home/theming/gnome-dconf/gnome-shell.nix` | **Move** | Keep file; remains commented in aggregator (extension deferred) |
| `default/home/home-dconf/gnome-night-theme.nix` | `modules/home/theming/gnome-dconf/gnome-night-theme.nix` | **Move** | Keep file; remains commented in aggregator (extension deferred) |
| `scripts/gen-hardware-config.sh` | — | **Delete** | `nh` replaces the switch workflow; hardware-config regeneration is one command (`nixos-generate-config`), no script needed |
| `default/README.md` | — | **Delete in P3** | Replaced by new subdir READMEs matching new layout |
| `default/system/README.md` | — | **Delete in P3** | |
| `default/home/README.md` | — | **Delete in P3** | |
| `ROADMAP.md` | `ROADMAP.md` | **Rewrite (P3)** | Done in this planning session |
| `DESIGN.md` | `DESIGN.md` | **New (planning session)** | Doctrine doc |
| `OVERRIDE.md` | `OVERRIDE.md` | **Update (planning session)** | Pointer only |
| — | `lib/default.nix` | **New** | mkHost + mkHome helpers |
| — | `modules/options.nix` | **New** | myConfig.* declarations |
| — | `.envrc` | **New** | `use flake` for nix-direnv |
| — | `overlays/default.nix` | **New (scaffold)** | Empty |
| — | `pkgs/default.nix` | **New (scaffold)** | Empty |

---

## Phase Breakdown

### P0 — Scaffold + Flake Rewire

**Goal:** New skeleton compiles and `nix flake check` passes. The existing `default/` tree is still intact (not yet deleted) but the new flake wiring points to `hosts/aierNixOS/`.

**Steps:**
1. `git checkout -b rebuild` from current `main`
2. Create `lib/default.nix` — write `mkHost` and `mkHome` helper functions:
   - `mkHost` wraps `nixpkgs.lib.nixosSystem`; accepts `{ system, modules }` + auto-injects `modules/options.nix`
   - `mkHome` wraps `home-manager.lib.homeManagerConfiguration`; accepts `{ pkgs, modules }` + auto-injects `modules/options.nix`
3. Create `modules/options.nix` — declare `myConfig` options:
   ```
   myConfig.user        (string)
   myConfig.hostname    (string)
   myConfig.timezone    (string)
   myConfig.locale      (string)
   myConfig.themeName   (string, for future stylix hook)
   ```
4. Create `hosts/aierNixOS/` directory:
   - `hosts/aierNixOS/hardware-configuration.nix` — copy (do not delete old yet)
   - `hosts/aierNixOS/default.nix` — minimal skeleton: imports hardware-configuration.nix + a stub `modules/system/core/` import; sets `myConfig.*` values; temporarily imports `../../default/configuration.nix` as a passthrough so it still builds
   - `hosts/aierNixOS/home.nix` — minimal skeleton: temporarily imports `../../default/home.nix` as passthrough
5. Rewrite `flake.nix`:
   - Inputs: nixpkgs (unstable), home-manager, nix-flatpak, git-hooks (pre-commit-hooks.nix). NOTE: nix-direnv is NOT a flake input — it is enabled in the home bash/direnv module via `programs.direnv.enable = true; programs.direnv.nix-direnv.enable = true;`, and `.envrc` simply contains `use flake`.
   - Add `lib = import ./lib/default.nix { inherit inputs; };` in `let`
   - `nixosConfigurations.aierNixOS = lib.mkHost { ... modules = [ ./hosts/aierNixOS/default.nix ]; }`
   - `homeConfigurations.aier = lib.mkHome { ... modules = [ ./hosts/aierNixOS/home.nix ]; }`
   - Remove HM-as-NixOS-module wiring (no `home-manager.nixosModules.home-manager` anywhere)
   - Add `devShells.x86_64-linux.default` with: nixfmt-rfc-style, statix, deadnix, nh
   - Add `formatter.x86_64-linux = nixfmt-rfc-style`
6. Create `.envrc`: `use flake`
7. Add `programs.nh` to the system config (within the P0 passthrough skeleton or as a standalone always-on nix.nix):
   ```nix
   programs.nh = {
     enable = true;
     flake = "/home/aier/.dotfiles/aierNix";
     clean = { enable = true; extraArgs = "--keep-since 4d --keep 3"; };
   };
   ```
8. Add git-hooks pre-commit config to devShell or a `checks` output:
   ```nix
   # runs nixfmt-rfc-style, statix, deadnix on staged nix files
   ```
9. Scaffold `overlays/default.nix` and `pkgs/default.nix` (empty, returning `{}`)
10. `git add -A && git stash` or incremental commits as skeleton grows

**Verification gate P0:**
- `nix flake check` — no errors
- `nixos-rebuild build --flake .#aierNixOS` — evaluates (builds derivation, does not switch)
- `nix develop` — shell opens with nixfmt, statix, deadnix, nh available
- `nix fmt` — runs without error on the skeleton files

---

### P1 — System Modularization

**Goal:** All system config ported into `modules/system/` feature-toggle modules. The `default/` system files are no longer referenced.

**Steps (in order — each must build before proceeding):**

1. **Core always-on modules** (no enable option — always imported by host):
   - `modules/system/core/networking.nix` — hostname (`aierNixOS`), hostId (`76a9986d`), networkmanager
   - `modules/system/core/locale.nix` — timezone (`America/Caracas`), i18n, LC_* settings
   - `modules/system/core/users.nix` — `users.users.aier`: isNormalUser, description, extraGroups
   - `modules/system/core/boot.nix` — grub EFI config, catppuccin-grub theme, gfxmode 1920x1080, useOSProber, `boot.zfs.forceImportRoot = false`, `boot.supportedFilesystems` list
   - `modules/system/nix.nix` — `nix.settings.experimental-features`, `nixpkgs.config.allowUnfree`, `system.stateVersion = "24.05"`, `programs.nh` config
   - `modules/system/system-pkgs.nix` — `environment.systemPackages` with explicit `pkgs.foo`: pkgs.git, pkgs.gparted, pkgs.ffmpeg-full, pkgs.home-manager, pkgs.ntfs3g, pkgs.usbutils; plus `programs.git.enable`, `programs.localsend`, `programs.nautilus-open-any-terminal`, `programs.appimage`

2. **Feature-toggle modules** (each self-declares `mySystem.<x>.enable` via `lib.mkEnableOption`):
   - `modules/system/desktop/gnome.nix` — `services.displayManager.gdm.enable`, `services.desktopManager.gnome.enable`, `environment.gnome.excludePackages`
   - `modules/system/desktop/pipewire.nix` — pipewire stack (alsa, alsa.support32Bit, pulse), `services.pulseaudio.enable = false`, `security.rtkit.enable`
   - `modules/system/desktop/fonts.nix` — system font packages (if any remain after moving font symlinks to home)
   - `modules/system/keyd.nix` — keyd Colemak DH (capslock→backspace, leftshift+rightshift→capslock, leftshift+leftmeta+f23→layer(control))
   - `modules/system/snapper.nix` — snapper root config with all TIMELINE_LIMIT_* settings
   - `modules/system/virtualisation.nix` — libvirtd
   - `modules/system/flatpak.nix` — `services.flatpak.enable` (system-level; nix-flatpak home module handles the packages)
   - `modules/system/ibus-rime.nix` — ibus + `i18n.inputMethod.ibus.engines` override adding rime-cantonese
   - `modules/system/power.nix` — `services.power-profiles-daemon.enable`, `services.tlp.enable = false`
   - `modules/system/printing.nix` — `services.printing.enable`

3. Update `hosts/aierNixOS/default.nix`:
   - Remove passthrough import of `../../default/configuration.nix`
   - Import all core modules (always-on)
   - Set feature toggles: `mySystem.desktop.gnome.enable = true`, `mySystem.keyd.enable = true`, etc.

4. `git add` and verify

**Verification gate P1:**
- `nixos-rebuild build --flake .#aierNixOS` — clean build
- `nix flake check` — passes
- `statix check . && deadnix .` — no warnings (or all suppressions justified)
- `nix fmt && git diff --exit-code` — no reformatting needed (all files already formatted)
- Switch: `nh os switch` — system boots correctly, GDM starts, keyd active

---

### P2 — Home Modularization + Cleanup

**Goal:** All home config ported into `modules/home/` feature-toggle modules. Scripts deleted. `with pkgs;` eliminated. VSCode moved to home. Bash cleaned up with `nh` aliases.

**Steps:**

1. **Shell module:**
   - `modules/home/shell/bash.nix` — port from current `home-configs.nix` bash block:
     - `programs.bash.bashrcExtra`: fastfetch call + PS1 (verbatim) + yazi `y()` function
     - `programs.bash.shellAliases`: all eza tree aliases (lsd/lst/lsda/lsta families), cls, cmd, zh, nixse
     - **Replace** `homesw = "cd ~/MyBash && ./homesw.sh"` with `homesw = "nh home switch"`
     - **Replace** `sysw = "cd ~/MyBash && ./sysw.sh"` with `sysw = "nh os switch"`
     - Declare `myHome.shell.bash.enable` option

2. **CLI modules** (each self-declares `myHome.cli.<x>.enable`):
   - `modules/home/cli/eza.nix` — `programs.eza.enable = true; enableBashIntegration = true`
   - `modules/home/cli/fzf.nix` — `programs.fzf.enable = true`
   - `modules/home/cli/zoxide.nix` — `programs.zoxide.enable = true; enableBashIntegration = true`
   - `modules/home/cli/fastfetch.nix` — `programs.fastfetch.enable = true`
   - `modules/home/cli/yazi.nix` — full yazi config from current `home-configs.nix` (settings, keymap, theme); `enableBashIntegration = true`

3. **Terminal module:**
   - `modules/home/terminal/ghostty.nix` — full ghostty config from current `home-configs.nix`

4. **App modules:**
   - `modules/home/apps/vscode.nix` — `home.packages = [ pkgs.vscode ]` only; comment: "Settings managed via VS Code Settings Sync / GitHub — no Nix config intentional"
   - `modules/home/apps/obs-studio.nix` — `programs.obs-studio.enable = true; plugins = []`
   - `modules/home/apps/flatpak-home.nix` — `services.flatpak.enable = true` + nix-flatpak module import + all flatpak packages list (zen, gradia, bitwarden, flatseal, extension-manager, kooha, rclone-manager, missioncenter, obsidian)

5. **Theming modules:**
   - `modules/home/theming/gnome-dconf/` — move all 7 dconf files verbatim (gnome-desktop-interface, gnome-clipboard, gnome-keybindings, gnome-tweaks, gnome-input-sources, gnome-shell, gnome-night-theme)
   - `modules/home/theming/dconf.nix` — aggregator with same commented pattern as current `home-dconf.nix`
   - `modules/home/theming/cursors.nix` — `home.packages = [ pkgs.bibata-cursors ]`

6. **Misc modules:**
   - `modules/home/misc/ibus-rime-home.nix` — `home.file.".config/ibus/rime/default.custom.yaml"` with luna_pinyin + jyut6ping3
   - `modules/home/misc/kando.nix` — `home.file.".config/autostart/kando.desktop"` + optionally `home.packages = [ pkgs.kando ]` if moved from system (confirm with user)
   - `modules/home/misc/fonts-home.nix` — `home.file` entries for ibm-plex, noto-cjk-serif, noto-cjk-sans font symlinks (with `pkgs.foo` not `with pkgs;`)

7. **Apps module for general home packages:**
   - Port darktable, dconf-editor, gnome-boxes, gnome-tweaks, proton-vpn, vesktop, claude-code, dconf2nix, nodejs, openconnect, python3, adw-gtk3 into an `modules/home/apps/home-pkgs.nix` with explicit `pkgs.foo` (no `with pkgs;`)

8. Update `hosts/aierNixOS/home.nix`:
   - Remove passthrough import of `../../default/home.nix`
   - Set `home.username`, `home.homeDirectory`, `myConfig.*`
   - Import all home modules; set feature toggles

9. **Cleanup:**
   - Delete `home.file` entries for homesw.sh and sysw.sh (and the MyBash directory reference)
   - Delete `scripts/gen-hardware-config.sh`
   - All `with pkgs;` replaced with explicit `pkgs.foo` throughout
   - Remove empty `default/home/home-modules.nix`
   - Confirm commented system-solaar.nix is fully deleted (not just commented)

**Verification gate P2:**
- `nh home build` — clean evaluation
- `nh home switch` — home activation succeeds
- Bash opens with correct PS1, aliases work (`homesw` calls nh, `sysw` calls nh)
- `nix flake check` — clean
- `statix check . && deadnix .` — clean
- No `with pkgs;` occurrences: `grep -r 'with pkgs' . --include='*.nix'` returns empty

---

### P3 — Docs + Cutover

**Goal:** Docs match the new layout; `default/` tree removed; `rebuild` merged to `main`.

**Steps:**
1. Rewrite `README.md` — nh-based install/usage, new layout diagram, updated day-to-day cheatsheet (`nh os switch`, `nh home switch`, `nh clean`, `nix develop`, `nix fmt`)
2. Add subdir READMEs for `lib/`, `hosts/aierNixOS/`, `modules/system/`, `modules/home/`, `overlays/`, `pkgs/`
3. Delete old `default/` READMEs (`default/README.md`, `default/system/README.md`, `default/home/README.md`)
4. Delete the entire `default/` tree (all files confirmed migrated)
5. Final `nix flake check` — must be clean
6. Final `nix fmt && git diff --exit-code` — no reformatting needed
7. `git add -A && git commit -m "P3: docs, cleanup, final check"`
8. `git checkout main && git merge rebuild --no-ff -m "rebuild: best-practice restructure complete"`
9. Update OVERRIDE.md to indicate rebuild is complete (clear the active override)

**Verification gate P3:**
- `nix flake check` — clean
- `nh os switch` — full system rebuild from new layout succeeds
- `nh home switch` — home activation succeeds
- No references to old paths (`default/`, `homesw.sh`, `sysw.sh`, `.#default`) remain in any .nix file
- `grep -r 'with pkgs' . --include='*.nix'` — empty
- `grep -r '\.#default' . --include='*.nix' --include='*.md'` — empty

---

## Rollback Strategy

- Each phase ends with a verifiable `nixos-rebuild build` (not switch) before committing.
- Work is on the `rebuild` branch; `main` is untouched until P3 merge.
- snapper is enabled on the root subvolume with daily snapshots — in the event of a bad switch, boot into a previous snapshot via grub-btrfs.
- To abort: `git checkout main` — the old config is intact and `nh os switch --flake .#default` (old syntax) still works until P3 merge.
- Nuclear fallback: snapper rollback via `snapper rollback` or grub-btrfs snapshot boot, then `nixos-rebuild switch --flake /path/to/snapshot/.#default`.

---

## Implementation Notes for the Executing Agent

- **No `with pkgs;` anywhere** — always write `pkgs.foo`. This is a hard rule enforced by statix.
- **Module file template:** Every feature module should follow:
  ```nix
  { config, lib, pkgs, ... }:
  let cfg = config.mySystem.<feature>;  # or myHome.<feature>
  in {
    options.mySystem.<feature>.enable = lib.mkEnableOption "<feature description>";
    config = lib.mkIf cfg.enable { ... };
  }
  ```
- **Core modules** (always-on): do NOT use the enable option pattern — just emit config directly.
- **`modules/options.nix`** declares `myConfig.*` using `lib.mkOption` with `lib.types.str` (or appropriate type). It does NOT gate anything behind an enable toggle.
- **kando placement:** Currently in `environment.systemPackages` in system-apps.nix. The plan moves it to `modules/home/misc/kando.nix` as a home package + autostart. Verify with user if kando should be system or home — flag before executing if unclear.
- **ibus-rime split:** The system module installs ibus engines; the home module writes the user config file. Both must be enabled together. Consider adding a `lib.mkIf` assert or a note in the host file.
- **nix-flatpak:** The `nix-flatpak.homeManagerModules.nix-flatpak` import goes into `mkHome`'s default modules list (or into `modules/home/apps/flatpak-home.nix`). Confirm placement.
- **git-hooks input name:** The nix-community project is `git-hooks.nix` (formerly `pre-commit-hooks.nix`). The flake input URL is `github:cachix/git-hooks.nix`. Use `checks.${system}.pre-commit-check` pattern.
- **`home.stateVersion`:** Must be set in `hosts/aierNixOS/home.nix` — do not forget.
