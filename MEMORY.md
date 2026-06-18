# MEMORY — aierNix (for future agents)

Quick-orient file. Read this + `ROADMAP.md` before working. ROADMAP is the live source of truth
(decisions table, current stage, changelog, open work). This file is the stable orientation layer.

## What this repo is

Personal **NixOS + home-manager flake**, single host `nixosConfigurations.default` /
`homeConfigurations.default`. Mission: transfer the `tuxies-wiki`
**aiers-fedora-checklist.md** setup into declarative Nix configs.

## Hard constraints

- **No builds in-harness.** The sandbox cannot run `nixos-rebuild` / `nix build` / `nix flake check`.
  Agents make **static edits + static review only**; the **user builds** in their own terminal.
  Never instruct an agent to build — surface build-time checks to the user instead.
- **Device-portable.** `default/hardware-configuration.nix` is **tracked** (Nix flakes only copy
  git-tracked files — gitignoring it breaks the build), regenerated + `git add`-ed per machine via
  `scripts/gen-hardware-config.sh`. Single tracked file = one machine at a time; per-host folders
  deferred until a 2nd device. Don't hardcode device-specific values into shared modules.

## Locked decisions (2026-06-18)

| Area | Decision |
|---|---|
| Display | **GDM Wayland** (X11-session keymap dropped) |
| Keyboard | Colemak DH via GNOME `input-sources` dconf (`us+colemak_dh`) + keyd (evdev, layout-independent) |
| Packages | declarative nixpkgs + nix-flatpak |
| IME | iBus + Rime; system `ibus-engines.rime` override adds `rime-cantonese`; per-user schema_list (luna_pinyin + jyut6ping3) in `~/.config/ibus/rime/default.custom.yaml` |
| Theming | **keep current** (bibata cursors, Plex Serif, Catppuccin GRUB) |
| Deferred | Howdy, v4l2loopback, Waydroid, Fluent icons/cursor |

## Layout

- `default/configuration.nix` — system entry. `default/home.nix` — home entry.
- `default/system/` — system modules (`system-configs`, `system-apps`, `system-modules/`).
- `default/home/` — home modules (`home-files`, `home-configs`, `home-apps`, `home-dconf/`).
- `default/imports/` — import aggregators. `scripts/` — setup helpers.
- `tuxies-wiki/` — embedded docs source (checklist lives here, mirrors the TheoryY wiki repo).

## Conventions

- New GNOME dconf → add a file under `home-dconf/` using `with lib.hm.gvariant;` + `mkTuple`,
  register in `home-dconf.nix` (match existing files).
- New system module → `system-modules/<name>.nix`, register in `system-modules.nix`.
- Verify nixpkgs pkg/option names exist; if uncertain, flag for user build rather than inventing.
