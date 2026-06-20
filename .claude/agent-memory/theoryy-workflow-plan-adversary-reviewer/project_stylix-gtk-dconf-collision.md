---
name: stylix-gtk-dconf-collision
description: How Stylix gtk target collides with hand-written org/gnome/desktop/interface dconf keys, and the 11->12pt font-size footgun
metadata:
  type: project
---

When a Stylix theme sets `targets.gtk.enable = true`, home-manager's gtk module
(modules/misc/gtk/gtk3.nix in the HM source) writes these dconf keys into
`org/gnome/desktop/interface` at **normal priority**, dropping null ones via
`filterAttrs`: font-name, gtk-theme, icon-theme, cursor-theme, cursor-size, color-scheme.

Which actually get written depends on what Stylix/HM populate:
- **font-name** (= gtk.font, size from `fonts.sizes.applications`, Stylix default 12)
- **gtk-theme** (= `adw-gtk3`, from the Stylix gtk target)
- **cursor-theme + cursor-size** — written even with gtk target OFF reasoning aside,
  because Stylix's HM cursor module (stylix/hm/cursor.nix) sets
  `home.pointerCursor.gtk.enable = true` whenever `stylix.cursor != null`, which sets
  `gtk.cursorTheme` (with size) → flows into gtk3 dconf. BUT the gtk3 dconf block is
  gated `mkIf (gtk.enable && gtk3.enable)`, and `gtk.enable` is only true when the
  Stylix gtk target is on. So cursor-theme/size are written only when gtk target is on.
- **icon-theme / color-scheme** — NOT set by the Stylix gtk target → null → dropped.
  color-scheme being absent is why night-theme-switcher (imperative `dconf write`,
  also commented out of imports) never collides at the Nix level.

The repo's hand-written `gnome-desktop-interface.nix` only sets font-name, gtk-theme,
cursor-theme (of the colliding set) — so `lib.mkDefault` on exactly those three is
correct and minimal. cursor-size/icon-theme/color-scheme are absent from that file so
no collision even though the gtk module may write cursor-size.

**Why:** `mkDefault` (priority 1000) only yields to a normal-priority (100) competitor.
Under vanilla (gtk target off) there is no competitor, so the defaults apply unchanged —
provably a no-op. Verified empirically via
`nix eval --json '.#homeConfigurations.aier.config.dconf.settings."org/gnome/desktop/interface"'`
under both themeName values.

**FOOTGUN (the real finding):** under catppuccin the gtk module writes
`font-name = "IBM Plex Sans 12"` (Stylix applications size default 12), overriding the
dconf default of 11. But document-font-name and monospace-font-name stay at 11 (not
written by the gtk module). Net: GNOME Shell UI font silently jumps 11->12pt and becomes
inconsistent with the 11pt doc/mono fonts whenever a gtk-target theme is active.

**How to apply:** when reviewing any new Stylix colorful-theme plan in this repo, check
`fonts.sizes.applications` (or confirm it's left default 12) against the dconf font-name
default, and flag the size drift / inter-font inconsistency. To pin it, set
`stylix.fonts.sizes.applications = 11` in the theme entry, or accept 12 and bump
document/monospace to match.
