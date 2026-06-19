# Action plan — Stylix multi-profile theme framework

Status: **staged, uncommitted, un-switched** (all four profiles built green).
Scope: **home-side only** (`modules/home/**`, `hosts/aierNixOS/home.nix`). No system/NixOS config touched.
Active theme: **vanilla** (`themeName = "vanilla"` in `hosts/aierNixOS/home.nix`).

## Overview

Four selectable theme profiles live in `modules/home/theming/stylix.nix`:

| `themeName` | Palette source | Visual effect |
|---|---|---|
| `vanilla` | grayscale-dark (placeholder) | Inert — no color targets fire; GNOME stays Adwaita |
| `catppuccin` | catppuccin-mocha base16 | Full Catppuccin Mocha recolor (GTK, ghostty, yazi) |
| `everforest` | everforest-dark-hard base16 | Full Everforest Dark Hard recolor (GTK, ghostty, yazi) |
| `wallpaper-based` | `stylix.image` (NixOS simple-dark-gray wallpaper) | Palette auto-derived from wallpaper image |

Switch profiles by changing `myConfig.themeName` in `hosts/aierNixOS/home.nix` then running `nh home switch`.

## Framework design

`modules/home/theming/stylix.nix`:
- `myConfig.themeName` selects an entry from the `themes` attrset.
- Unknown names throw loudly at eval time.
- The `stylixBase` let-binding holds all `stylix.*` settings except the scheme source.
- Scheme source is conditional: `lib.optionalAttrs (selected ? base16Scheme)` injects `stylix.base16Scheme` for named-scheme profiles; `lib.optionalAttrs (selected ? image)` injects `stylix.image` for the wallpaper profile. Stylix rejects both being set simultaneously.
- `stylix.autoEnable = false` globally — no target fires unless explicitly opted in per-profile.
- The HM `gtk` module is **always enabled** (unconditionally) for the legacy-GTK fix (see below).

## Theme profiles

### vanilla

Inert grayscale placeholder. No color targets fire. GNOME stays Adwaita. However, the
always-on HM `gtk` module (legacy-GTK fix) does write `settings.ini` and `.gtkrc-2.0`
with `gtk-theme-name=adw-gtk3`, so **vanilla is no longer fully inert for legacy apps** —
they will correctly pick up the adw-gtk3 theme. The GNOME shell UI stays Adwaita-controlled
via dconf `gtk-theme = "adw-gtk3"` (which the HM gtk module writes at normal priority).

### catppuccin (Catppuccin Mocha)

- `base16Scheme`: `${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml`
- `targets.gtk = true`, `targets.gnome = false` (NEVER true — User Themes ext crashed baremetal)
- `fontSizeApplications = 11` (pins GTK applications font to 11pt to match doc/mono 11pt)
- Recolors: GTK, ghostty, yazi

### everforest (Everforest Dark Hard)

- `base16Scheme`: `${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml`
- Dark Hard variant (darkest bg, highest contrast); soft/medium variants available at
  `everforest-dark-soft.yaml` / `everforest-dark-medium.yaml` if preferred.
- `targets.gtk = true`, `targets.gnome = false`
- `fontSizeApplications = 11`
- Recolors: GTK, ghostty, yazi

### wallpaper-based

- `image`: `${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray.png`
  (the user's current dark wallpaper, sourced as a reproducible package reference)
- Stylix derives the base16 palette from the image at build time — deterministic, GC-safe.
- `targets.gtk = true`, `targets.gnome = false`
- `fontSizeApplications = 11`
- Recolors: GTK, ghostty, yazi
- **Note**: `stylix.image` seeds the palette only; it does NOT set the GNOME desktop background.
  To swap the wallpaper used for palette derivation, change the `image` path in the theme entry.

## Legacy-GTK fix

**Symptom**: legacy (non-libadwaita) GTK3 apps not using adw-gtk3 under vanilla.

**Root cause**: the HM `gtk` module was not enabled, so `~/.config/gtk-3.0/settings.ini`
and `~/.gtkrc-2.0` were never written. Legacy GTK3 apps read `settings.ini` directly for
`gtk-theme-name`; they do not use dconf. Without `settings.ini`, they saw their compiled-in
default, not adw-gtk3.

**Fix**: the HM `gtk` module is now **always enabled** in `modules/home/theming/stylix.nix`
with a baseline:
```nix
gtk = {
  enable = true;
  theme = {
    name = lib.mkDefault "adw-gtk3";
    package = lib.mkDefault pkgs.adw-gtk3;
  };
  # lib.mkDefault null: adopt new HM default (GTK4/libadwaita themes natively).
  # mkDefault lets Stylix's normal-priority gtk4.theme write override this under
  # colorful profiles; without mkDefault, setting null conflicts with Stylix's
  # non-null write. Silences stateVersion < 26.05 migration warning on vanilla.
  gtk4.theme = lib.mkDefault null;
};
```

- Under **vanilla**: gtk module writes `settings.ini`/`.gtkrc-2.0` with `gtk-theme-name=adw-gtk3`.
  The dconf `gtk-theme` key resolves to `"adw-gtk3"` (gtk module writes it at normal priority,
  beating the `lib.mkDefault "Adwaita"` in `gnome-desktop-interface.nix`).
- Under **colorful themes**: Stylix gtk target also engages. Stylix writes `@define-color` CSS
  variable blocks directly into `~/.config/gtk-{3,4}.0/gtk.css`, redefining the standard named
  colors (accent, window-bg, fg, etc.) with the base16 palette. The `gtk.theme.name` remains
  `adw-gtk3` — Stylix does NOT change the theme name, it recolors via CSS custom properties.
  The module still writes `settings.ini` with `gtk-theme-name=adw-gtk3` as the base. Verified:
  catppuccin `gtk.css` opens with `@define-color accent_color #89b4fa;` and companion Mocha hex
  values; `settings.ini` has `gtk-theme-name=adw-gtk3`. Mechanism is `home.file`-written CSS,
  NOT `gtk3.extraCss`/`gtk4.extraCss` (those eval to empty string under colorful profiles).
- `gtk.font` / `gtk.cursorTheme` / `gtk.iconTheme` are intentionally NOT set here — leaving them
  unset means the gtk module does not write dconf `font-name`/`cursor-theme`, so those keys remain
  governed by their `lib.mkDefault` values in `gnome-desktop-interface.nix`.

**adw-gtk3 package**: already in `home.packages` via `home-pkgs.nix`. The `gtk.theme.package`
reference here additionally puts it in GTK's theme search path via the module.

## dconf collision reconciliation

`gnome-desktop-interface.nix` uses `lib.mkDefault` on three keys the HM gtk module also writes:
- `cursor-theme`: mkDefault → gtk module (or any higher-priority source) wins
- `font-name`: mkDefault → gtk module (or Stylix) wins when gtk target active; default applies under vanilla
- `gtk-theme`: mkDefault "Adwaita" → overridden by gtk module writing "adw-gtk3" at normal priority

`document-font-name` / `monospace-font-name` are NOT written by the gtk module → stay at normal priority.

## Changes (files modified)

1. `modules/home/theming/stylix.nix` — added everforest and wallpaper-based profiles; added
   legacy-GTK fix (unconditional HM gtk module); refactored scheme-source to conditional
   `optionalAttrs` merge (`stylixBase // ...`) to support both `base16Scheme` and `image` profiles;
   added `gtk4.theme = lib.mkDefault null` to embrace new HM default (GTK4 themes natively)
   and silence the stateVersion < 26.05 migration warning without conflicting with Stylix.
2. `hosts/aierNixOS/home.nix` — `themeName = "vanilla"` (restored from catppuccin; vanilla is the
   active live theme).
3. `modules/home/theming/gnome-dconf/gnome-desktop-interface.nix` — `lib.mkDefault` on
   `cursor-theme`, `font-name`, `gtk-theme` (done in prior agent; unchanged here).

## Verification (done in-harness)

- `nix build .#homeConfigurations.aier.activationPackage` with each of the four `themeName`
  values: **all GREEN** (exit 0, no warnings). Builds verified:
  - `vanilla` — gtk module writes settings.ini; inert color targets; no migration warnings
  - `catppuccin` — catppuccin-mocha CSS, ghostty-stylix-theme, yazi-theme derivations built
  - `everforest` — everforest-dark-hard CSS, ghostty-stylix-theme, yazi-theme derivations built
  - `wallpaper-based` — stylix palette derived from image; CSS, ghostty-stylix-theme, yazi-theme built
- `nix flake check`: **all checks passed** (nixfmt, statix, deadnix clean)
- **GTK recoloring confirmed**: catppuccin home-files at `/nix/store/8ihf4rchdsf2gp4hkvb09zwcvbi5p214-home-manager-files`:
  - `.config/gtk-3.0/gtk.css` opens with `@define-color accent_color #89b4fa;` (Catppuccin Mocha blue)
  - `.config/gtk-4.0/gtk.css` — identical Mocha palette recoloring
  - `.config/gtk-3.0/settings.ini` has `gtk-theme-name=adw-gtk3` and `gtk-font-name=IBM Plex Sans 11`
- `nix eval` under vanilla:
  - `config.gtk.theme.name = "adw-gtk3"` ✓
  - `dconf.settings."org/gnome/desktop/interface"."gtk-theme" = "adw-gtk3"` ✓
  - `dconf.settings."org/gnome/desktop/interface"."font-name" = "IBM Plex Sans 11"` ✓
  - `dconf.settings."org/gnome/desktop/interface"."cursor-theme" = "Bibata-Original-Ice"` ✓
- End state: `themeName = "vanilla"`, uncommitted, un-switched.

## What remains the USER's call

1. **Profile selection and activation.** To try any colorful profile:
   - Change `themeName` in `hosts/aierNixOS/home.nix`
   - Run `nh home switch` (agents never run live switches)
   - Confirm it looks right, then commit
2. **Wallpaper for `wallpaper-based`** (optional). The current palette source is the NixOS
   simple-dark-gray default wallpaper. To use a different image, change `image = ...` in the
   `wallpaper-based` entry to any absolute path or nix package reference.
3. **Commit.** Test-first convention — leave uncommitted until the user confirms the live result.

## Constraints

- `targets.gnome = false` for ALL colorful profiles — GNOME Shell User-Themes extension crashed baremetal previously. NEVER set gnome = true.
- `fontSizeApplications = 11` for ALL colorful profiles — keeps GTK applications font at 11pt to match dconf doc/mono.
- `gtkFlatpakSupport = false` everywhere — nix-flatpak owns Flatpak theming.

## Notes

- The Everforest Dark Hard variant was previously trialled and **reverted per preference** (ROADMAP changelog 2026-06-18). It is staged here as a selectable option, not the active theme.
- `stylix.image` seeds palette only — it does NOT set the GNOME desktop background.
- GTK4/libadwaita apps theme natively via Adwaita; adw-gtk3 is a GTK3 theme for legacy apps only.
