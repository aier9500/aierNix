# MEMORY — aierNix (for future agents)

Quick-orient file. Read this + `ROADMAP.md` before working. ROADMAP is the live source of truth
(decisions table, current stage, changelog, open work). This file is the stable orientation layer.
Doctrine lives in `DESIGN.md`. Each subdirectory has a README with further detail.

## What this repo is

Personal **NixOS + home-manager flake**, single host `nixosConfigurations.aierNixOS` /
`homeConfigurations.aier` (standalone home-manager — NOT wired as a NixOS module). Mission:
transfer the `tuxies-wiki` **aiers-fedora-checklist.md** setup into declarative Nix configs.
Best-practice rebuild (P0–P3) is complete; `default/` tree is deleted; `hosts/` + `modules/` layout
is live on `main`.

## Flake outputs

| Output | Command |
|---|---|
| `nixosConfigurations.aierNixOS` | `nh os switch` / `sudo nixos-rebuild switch --flake .#aierNixOS` |
| `homeConfigurations.aier` | `nh home switch` / `home-manager switch --flake .#aier` |

## Build / activation rules

- **Builds and evals run fine in-harness.** `nixos-rebuild build`, `nix build .#homeConfigurations.aier.activationPackage`, and `nix flake check` all work. Agents use these for build-only verification (including closure-hash equality via `nix store diff-closures`).
- **What stays the user's to run is the live ACTIVATION.** Never auto-run `nh os switch` / `nh home switch` — hand those commands to the user to run in their own terminal.
- **Activation order when both change:** home first (`nh home switch`), then system (`nh os switch`).

## Hardware config

`scripts/gen-hardware-config.sh` is **deleted**. The tracked file is
`hosts/aierNixOS/hardware-configuration.nix`, regenerated per-machine with:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/aierNixOS/hardware-configuration.nix
git add hosts/aierNixOS/hardware-configuration.nix
```

Nix flakes only copy git-tracked files — untracked hardware config causes "file not found" build
failures. The per-host `hosts/<name>/` structure is ready for a second device.

## Layout

```
flake.nix                          # outputs: nixosConfigurations.aierNixOS, homeConfigurations.aier
lib/                               # mkHost + mkHome helpers
hosts/aierNixOS/
  default.nix                      # sets myConfig.*, flips system toggles on
  home.nix                         # sets myConfig.*, flips home toggles on
  hardware-configuration.nix       # machine-specific (tracked)
modules/
  options.nix                      # myConfig.* cross-cutting values
  system/
    core/                          # always-on (boot, fs, networking, locale, users)
    desktop/                       # gnome, pipewire, fonts  [mySystem.desktop.*]
    keyd.nix                       # Colemak DH evdev remap  [mySystem.keyd.enable]
    snapper.nix / virtualisation.nix / flatpak.nix / power.nix / printing.nix / nix.nix / system-pkgs.nix
  home/
    shell/bash.nix                 # [myHome.shell.bash.enable]
    cli/                           # eza, fzf, zoxide, yazi, fastfetch  [myHome.cli.*]
    terminal/ghostty.nix           # [myHome.terminal.ghostty.enable]
    apps/                          # vscode, obs-studio, flatpak-home, home-pkgs  [myHome.apps.*]
    theming/
      dconf.nix                    # aggregator for gnome-dconf/*  [myHome.theming.gnome.enable]
      gnome-dconf/                 # desktop-interface, clipboard, keybindings, tweaks, input-sources
      stylix.nix                   # theme-selector framework (themeName → vanilla/colorful)
      fonts.nix                    # font packages [myHome.fonts.enable]
    misc/                          # kando, solaar  [myHome.kando.enable / myHome.solaar.enable]
overlays/ pkgs/                    # empty scaffolds
```

## Conventions

- **Feature-toggle pattern:** every non-core module self-declares `mySystem.<x>.enable` /
  `myHome.<x>.enable` via `lib.mkEnableOption` and gates with `lib.mkIf cfg.enable`.
- **Core modules** (boot, fs, networking, locale, users) are always-on — no enable option,
  always imported by the host file.
- **`myConfig.*`** holds cross-cutting values (user, hostname, timezone, locale, themeName).
- **No `with pkgs;`** — always write `pkgs.foo`. Statix enforces this.
- **New GNOME dconf setting** → add a file under `modules/home/theming/gnome-dconf/`, register it
  in `modules/home/theming/dconf.nix`.
- **New system module** → `modules/system/<name>.nix`, import it in the host file
  (`hosts/aierNixOS/default.nix`).
- **Verify** nixpkgs pkg/option names exist before using; flag unknowns to the user.

## Locked decisions (2026-06-18)

| Area | Decision |
|---|---|
| Display | **GDM Wayland** (X11-session keymap dropped) |
| Keyboard | Colemak DH via GNOME `input-sources` dconf (`us+colemak_dh`) + keyd (evdev, layout-independent) |
| Packages | declarative nixpkgs + nix-flatpak |
| Theming | bibata cursors, Plex Serif, Catppuccin GRUB |
| Standalone HM | home-manager runs standalone (`homeConfigurations.aier`), not as a NixOS module |
| GNOME extensions | Fully imperative (GNOME Extensions app) — declarative crashed baremetal 2026-06-18 |
| Deferred | Howdy, v4l2loopback, Waydroid, Fluent icons/cursor |
| IME (ibus-rime) | **Removed in rebuild** (prior home-only config was never functional). Greenfield future item — see ROADMAP. |

## Day-to-day cheatsheet

| Task | Command |
|---|---|
| Rebuild + switch system | `nh os switch` (alias: `sysw`) |
| Rebuild + switch home | `nh home switch` (alias: `homesw`) |
| Build system (no switch) | `nh os build` |
| Build home (no switch) | `nh home build` |
| GC old generations | `nh clean all` |
| Search packages | `nix search nixpkgs <term>` (alias: `nixse`) |
| Enter dev shell | `nix develop` |
| Run formatter | `nix fmt` |
| Verify closure | `nix store diff-closures` |

Bare `nh` form works from anywhere post-login because `programs.nh.flake` exports
`NH_FLAKE=/home/aier/.dotfiles/aierNix` via `/etc/set-environment` (loaded at login).

## Quality gate

| Tool | Role | How to run |
|---|---|---|
| nixfmt-rfc-style | Formatter | `nix fmt` |
| statix | Linter (anti-patterns, `with pkgs;`) | `statix check .` |
| deadnix | Dead code elimination | `deadnix .` |
| git-hooks.nix | Pre-commit: runs all three on staged `.nix` files | automatic on `git commit` |

`nix flake check` must pass before any merge to `main`.
