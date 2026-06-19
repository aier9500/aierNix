# Action Plan — rime-cantonese IME (greenfield)

**Goal:** working ibus-rime input with `luna_pinyin` (Pinyin) + `jyut6ping3` (Cantonese
Jyutping) on GNOME Wayland. The prior home-only attempt was removed in the rebuild
("never functional" — almost certainly because there was no system engine
registration). This does **both** halves: system engine + home schema config + dconf
input source.

## Verified pre-conditions (2026-06-19, pinned nixpkgs)
- `ibus-engines.rime` 1.6.1, `rime-data` 0.38.20231116.
- The engine's bundled `share/rime-data` includes BOTH `jyut6ping3.schema.yaml` and
  `luna_pinyin.schema.yaml` → **no `rimeDataPkgs` override needed** (the prior attempt
  overrode it).
- ibus component `im.rime.Rime`; engine `<name>` is `rime` (lang `zh`) → dconf tuple
  `('ibus','rime')`.
- GNOME integrates ibus via the input-source mechanism (text-input-v3), not the
  `GTK_IM_MODULE` env vars — so no env tuning.

## Changes
1. **System** — `modules/system/ibus.nix` (`mySystem.ibus.enable`):
   `i18n.inputMethod = { enable = true; type = "ibus"; ibus.engines = [ pkgs.ibus-engines.rime ]; };`
   Wired in `hosts/aierNixOS/default.nix` (import + `ibus.enable = true`).
2. **Home** — `modules/home/misc/ibus-rime.nix` (`myHome.ibusRime.enable`):
   `xdg.configFile."ibus/rime/default.custom.yaml"` patching `schema_list` →
   `luna_pinyin`, `jyut6ping3`. Declarative is fine here: rime only *reads* this file
   (it deploys into `~/.config/ibus/rime/build/`), so no read-only-symlink conflict.
   Wired in `hosts/aierNixOS/home.nix` (import + `ibusRime.enable = true`).
3. **dconf** — `gnome-input-sources.nix`: set `org/gnome/desktop/input-sources`
   `sources = [('xkb','us'), ('ibus','rime')]`.

## Gate (in-harness)
`nix flake check`; `nh os build` then confirm the component lands at
`/run/current-system/sw/share/ibus/component/rime.xml` (store≠runtime check); `nh home build`.

## User verification (live)
- `nh os switch` + `nh home switch`, then **log out / log back in** (Wayland can't
  restart gnome-shell / the ibus-daemon in place).
- Super+Space to switch to Rime. First use: rime **deploys** schemas (brief delay,
  not hung).
- Default schema is `luna_pinyin`; switch to `jyut6ping3` within rime via `F4` or
  `` Ctrl+` ``.

## Notes / tradeoffs
- Declarative `input-sources.sources` means any input source added/reordered via the
  GNOME Settings GUI reverts on the next `nh home switch` (intended — declarative).
- Keyboard layout stays Colemak-DH via keyd (evdev, below ibus); the `('xkb','us')`
  base source is correct (keyd remaps underneath).
