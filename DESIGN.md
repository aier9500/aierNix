# aierNix — Design Document

Philosophy, conventions, and locked decisions for the aierNix dotfiles repo. Read this before making architectural changes. Implementation details live in `action-plans/`. Ongoing work lives in `ROADMAP.md`.

---

## Design Philosophy

**Portable and maintainable above all.** The repo must build and boot on any x86_64 machine after regenerating `hardware-configuration.nix`. Maintainability takes precedence over convenience: if a hand-rolled script can be replaced by a single command a user can remember, delete the script. The repo should be navigable by someone who was not present when it was written.

**Minimal surface area in system (root) config.** System config should contain only what makes a NixOS installation functional and bootable: boot, filesystem, networking, locale, users, core system programs (git, gparted, ffmpeg-full), and the system-level halves of services that require root (keyd, ibus, GNOME/GDM, pipewire, snapper). Everything else belongs in home-manager.

**Prefer declarative options over config files.** `home.file` is a last resort. If a program has a home-manager module option, use it. Only use `home.file` for programs with no HM module or for config formats that cannot be expressed as Nix options (e.g., ibus-rime YAML patches, kando autostart .desktop).

**No `with pkgs;`.** Always write `pkgs.foo`. Statix enforces this. The convenience is not worth the readability cost.

**Feature wiki is me, not the wiki.** The featureset originates from Theory-Y/tuxies-wiki (gnome.md, aiers-gnome, keyd, bash customization, ghostty, kando). My preferences are canonical and override the wiki. When a config choice deviates from the wiki, flag it — the wiki may need updating.

---

## System vs Home Split Doctrine

| Layer | Role | Examples |
|---|---|---|
| System (`/etc/nixos` / `nixosConfigurations`) | Functional essentials — what the machine needs to boot and be managed | Boot, FS, networking, locale, users, keyd (evdev — must be system-level), ibus service, GDM/GNOME, pipewire, snapper, system packages (git, gparted, ffmpeg-full, ntfs3g, usbutils) |
| Home (`homeConfigurations`) | User environment — everything customizable and user-specific | Shell (bash config, aliases, PS1), CLI tools (eza, fzf, zoxide, yazi, fastfetch), terminal (ghostty), apps (vscode, obs-studio, darktable, vesktop, etc.), flatpak packages, GNOME dconf theming, dotfiles/config files |

**Rule of thumb:** if removing it from the system config would prevent the machine from booting or being SSH-able, it belongs in system. Everything else belongs in home. The home rebuild cycle is much faster than the system cycle, so keeping home rich means faster iteration.

**Specific decisions:**
- `git` — system (`programs.git.enable = true`), because it is needed to manage the flake itself
- `home-manager` — system packages (bootstrap requirement)
- `vscode` — home only (install-only; Settings Sync handles config; no Nix-managed settings)
- `kando` — home (package install + autostart .desktop; user-space daemon). Menus/settings stay **imperative** (Kando's editor owns `config.json`/`menus.json`); the GNOME Shell integration extension is also **imperative** (install + enable via the GNOME Extensions app — declarative install would need a system module, declined to keep system config lean; L8). See GUI-Owned Config doctrine below
- `solaar` — split: system installs the app + udev rules (`hardware.logitech.wireless`); device rules (`rules.yaml`) are **imperative** (Solaar GUI owns them) — no home module
- `ghostty` — home (terminal emulator; user config)
- `ibus-rime` — split: system installs engines; home writes the user config file (`default.custom.yaml`)
- Font symlinks — home (`home.file` pointing into nix store font paths)

---

## Feature-Toggle Options Convention

Every non-essential module self-declares its own enable option and gates its config behind it. This makes host files the single source of truth for what is enabled on a given machine.

### Naming

| Namespace | Purpose | Example |
|---|---|---|
| `myConfig.*` | Cross-cutting values shared across system and home | `myConfig.user`, `myConfig.hostname`, `myConfig.timezone`, `myConfig.locale`, `myConfig.themeName` |
| `mySystem.*` | System (NixOS) feature toggles | `mySystem.keyd.enable`, `mySystem.desktop.gnome.enable`, `mySystem.snapper.enable` |
| `myHome.*` | Home-manager feature toggles | `myHome.shell.bash.enable`, `myHome.cli.yazi.enable`, `myHome.theming.gnome.enable` |

### Module Template

```nix
{ config, lib, pkgs, ... }:
let cfg = config.mySystem.<feature>;
in {
  options.mySystem.<feature>.enable = lib.mkEnableOption "<human description>";
  config = lib.mkIf cfg.enable {
    # ... feature config here, all pkgs.foo not with pkgs;
  };
}
```

Core modules (boot, fs, networking, locale, users) are **always-on** — they emit config directly with no enable option and are always imported by the host file.

### `modules/options.nix`

Declares only `myConfig.*` cross-cutting values. Does not declare feature toggles (those live in the feature modules themselves).

```nix
options.myConfig = {
  user     = lib.mkOption { type = lib.types.str; };
  hostname = lib.mkOption { type = lib.types.str; };
  timezone = lib.mkOption { type = lib.types.str; };
  locale   = lib.mkOption { type = lib.types.str; };
  themeName = lib.mkOption { type = lib.types.str; default = ""; };
};
```

### Host File Role

`hosts/aierNixOS/default.nix` (system) and `hosts/aierNixOS/home.nix` (home) are the only files that:
1. Set `myConfig.*` values
2. Import feature modules and flip their toggles on

No feature module imports another feature module. Composition happens only in the host file.

---

## Standalone Home-Manager Decision

home-manager runs **standalone** — not as a NixOS module (`home-manager.nixosModules.home-manager`).

**Why:** Running HM both as a NixOS module and via the standalone CLI creates a duplicate-activation smell: the system build runs HM once, and `home-manager switch` runs it again. The two activations can diverge. Standalone mode makes the boundary explicit: `nh os switch` touches system; `nh home switch` touches user.

**Consequence:** `home-manager` must be installed as a system package (bootstrap requirement) and the first `nh home switch` must be run after a fresh install before the user environment is active.

**Day-to-day tooling (nh):**

| Task | Command |
|---|---|
| Rebuild + switch system | `nh os switch` |
| Rebuild + switch home | `nh home switch` |
| Build system (no switch) | `nh os build` |
| Build home (no switch) | `nh home build` |
| GC old generations | `nh clean all` |
| Search packages | `nix search nixpkgs <term>` |
| Enter dev shell | `nix develop` |

Aliases in the bash module:
- `sysw` → `nh os switch`
- `homesw` → `nh home switch`
- `nixse` → `nix search nixpkgs`

---

## Quality Gate

All quality tooling is available in the devShell (`nix develop`). `.envrc` with `use flake` auto-loads it via nix-direnv on `cd`.

| Tool | Role | Run via |
|---|---|---|
| nixfmt-rfc-style | Formatter | `nix fmt` |
| statix | Linter (anti-patterns, `with pkgs;` detection) | `statix check .` |
| deadnix | Dead code elimination | `deadnix .` |
| git-hooks.nix | Pre-commit hook running all three | Automatic on `git commit` |
| nh | Switch/build/GC helper | `nh os switch`, `nh home switch`, `nh clean` |

`nix flake check` must pass before any merge to `main`.

---

## Flatpak — Minimize Policy

Flatpak is a bridge, not a destination. The policy is: migrate any app to nixpkgs when it is packaged, works correctly, and does not require special runtime isolation.

**Migrated to nixpkgs (2026-06-19):** Obsidian, Mission Center, Kooha, Extension Manager (`gnome-extension-manager`), Gradia — packaged and non-broken; now in `modules/home/apps/home-pkgs.nix`.

**Stay on flatpak:**
- Zen browser — not packaged; browser sandboxing is desirable anyway
- Bitwarden — packaged (`bitwarden-desktop`) but its nixpkgs build pulls an insecure electron (`electron-39.8.10`); flatpak's sandbox + bundled runtime is preferable for a secrets app (would otherwise need `permittedInsecurePackages`)
- Flatseal — not packaged; manages flatpak permissions
- rclone-manager — not packaged

Re-evaluate any of these whenever it gains a working / non-insecure nixpkgs package.

**Never declare flatpak packages twice** — nix-flatpak manages the list declaratively; do not also list them in `home.packages`.

---

## Secrets — Imperative by Design

No declarative secrets backend (no sops-nix / agenix). Secrets are managed by the application (e.g. Bitwarden) and synced via the user's account — the same philosophy as VS Code settings (install the app only, no Nix-side secret config). If a concrete in-config secret ever becomes unavoidable, revisit; until then, declarative secrets are intentionally out of scope.

---

## GUI-Owned Config — Imperative by Design

Some apps own their config files and rewrite them through their own GUI at runtime — Kando's menu editor writes `config.json`/`menus.json`; Solaar's rule editor writes `rules.yaml`. For these, do **not** manage the config with `home.file` / `xdg.configFile` at all. This is **stronger** than the "`home.file` is a last resort" guideline above: a `.source` link is a *read-only symlink into the Nix store*, so the instant the app tries to save, it fails. Declare only install and enablement (package, autostart `.desktop`, `hardware.logitech.wireless`, udev); let the app own the config file.

Same install-only philosophy as VS Code (L10) and the secrets-imperative policy above. The one-time setup on a new machine is documented in the README "Manual setup (imperative)" section. Prior config is preserved in git history and in Theory-Y/tuxies-wiki.

| App | Declarative (this flake) | Imperative (the app / the user) |
|---|---|---|
| Kando | `pkgs.kando` + autostart `.desktop` | `config.json`, `menus.json` (settings editor) + the Kando Integration GNOME extension |
| Solaar | `hardware.logitech.wireless` (install + udev) | `rules.yaml` (rule editor) |

GNOME extensions land on the imperative side for a *different* reason — *enabling* them via dconf risks version-mismatch crashes (L8), not file ownership. *Installing* a version-matched extension (e.g. `gnomeExtensions.kando-integration`) is technically viable, but only from a system module (gnome-shell doesn't scan the standalone home-manager profile); declined to keep the system config lean (L8), so extensions are installed + enabled via the GNOME Extensions app.

---

## Partial Stylix Policy (Deferred)

Stylix will be adopted for theming when implemented, but only for a targeted subset of themes. The goal is NOT to let Stylix manage everything.

**Stylix targets (when adopted):**
- GTK theme (adw-gtk3 / Catppuccin variant)
- Cursor theme (bibata-cursors)
- Fonts (Plex Serif, Noto CJK)
- Ghostty theme
- Yazi theme

**NOT managed by Stylix:**
- GNOME shell settings — stay in dconf (`gnome-shell.nix`)
- night-theme-switcher extension settings — stay in dconf (`gnome-night-theme.nix`)
- Any extension config (extensions remain imperative)

Rationale: the dconf GNOME shell and extension settings interact with extension versions in ways Stylix cannot control. Keeping them in dconf preserves the ability to comment them out during extension version transitions without affecting the rest of theming.

---

## Locked Decisions

| # | Decision | Rationale |
|---|---|---|
| L1 | nixos-unstable channel | Access to latest packages; consistent with wiki spec |
| L2 | GRUB (not systemd-boot) | EFI + OS prober for dual-boot; Catppuccin GRUB theme removed (caused grub activation failure — legacy theme; kept 1920x1080 resolution) |
| L3 | GDM Wayland | Drop X11 session; keyboard layout via GNOME input-sources dconf |
| L4 | Colemak DH via keyd | keyd operates at evdev level — layout-independent, works on Wayland without X11 xkb config |
| L5 | Bash (not zsh/fish/starship) | Custom PS1 already tuned; no reason to switch |
| L6 | ibus-rime for CJK input | luna_pinyin + jyut6ping3; system engine + user schema config file |
| L7 | hardware-configuration.nix tracked in git | Nix flakes only copy git-tracked files; ignored hardware-config causes build failures |
| L8 | GNOME extensions — imperative (install + enable) | Declarative *enable* via dconf crashed on baremetal (version mismatch, 2026-06-18); manage on/off via the GNOME Extensions app. Declarative *install* is technically viable for a version-matched extension (e.g. `gnomeExtensions.kando-integration`) but needs a **system** module — gnome-shell doesn't scan the standalone home-manager profile; declined 2026-06-19 to keep the system config lean. *Enable* would stay imperative regardless (home-manager dconf sets the whole `enabled-extensions` list and would clobber hand-enabled extensions) |
| L9 | No CI | Local quality gate (pre-commit + `nix flake check`) is sufficient for a single-person dotfiles repo |
| L10 | VSCode install-only in home | Settings managed via VS Code Settings Sync / GitHub Gist; Nix-managed settings would conflict |
| L11 | GUI-owned config (Kando menus, Solaar rules) imperative | A declarative `xdg.configFile`/`.source` link is a read-only Nix-store symlink — the app's own editor cannot save to it. Install + enablement declarative; config owned by the app. See GUI-Owned Config doctrine |

---

## Deferred / Out of Scope

| Item | Status | Rationale |
|---|---|---|
| Stylix theming | Deferred | Requires careful scoping (partial targets only); not blocking the rebuild |
| Flatpak → nixpkgs migration | Deferred | Requires per-app evaluation; nix-flatpak bridge is stable |
| Declarative obs-studio (scenes/profiles) | Deferred | Binary-format configs; not Nix-manageable cleanly |
| Declarative fastfetch config | Deferred | Works with defaults; custom config.jsonc deferred |
| Declarative fzf keybindings/defaultOptions | Deferred | Low priority |
| disko (declarative partitioning) | Deferred | Reinstall-time change; not worth disrupting a running system |
| impermanence (ephemeral root) | Deferred | Requires disko first; reinstall-time |
| sops-nix / agenix secrets | Deferred | No concrete secrets in config yet; adopt when needed |
| Declarative GNOME extensions | Deferred | Extension version mismatch caused crash (L8 above); re-evaluate when nixpkgs version-matching is reliable |
| Howdy facial login | Deferred | Fiddly PAM integration; not for VM; revisit on baremetal |
| Second host (laptop) | Deferred | hosts/ + modules/ structure is ready for it |
| Multi-host NVIDIA/Asahi handling | Deferred | Depends on second host hardware |
