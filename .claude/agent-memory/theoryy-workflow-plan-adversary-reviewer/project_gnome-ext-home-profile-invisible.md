---
name: gnome-ext-home-profile-invisible
description: Why home.packages GNOME extensions are invisible to gnome-shell in this repo (standalone HM), and the false-pass trap when imperative copies still exist
metadata:
  type: project
---

In aierNix, gnome-shell does **not** discover GNOME extensions installed via
home-manager `home.packages`. Recorded as DESIGN.md **L8** and ROADMAP 2026-06-19:
gnome-shell scans `/run/current-system/sw/share` (system) but **not** the standalone
home-manager profile. A `home.packages` copy is invisible to the shell — declarative
*install* of an extension requires a **system** module (`environment.systemPackages`),
which is gated under CLAUDE.md and was declined 2026-06-19 ("keep system config lean").

Reinforcing fact: this repo runs **standalone** home-manager
(`programs.home-manager.enable = true` in `hosts/aierNixOS/home.nix`), NOT the NixOS
home-manager module. So `home-manager.useUserPackages` is a no-op here (it's a
NixOS-module knob), and home packages land in `~/.nix-profile/share`, not
`/etc/profiles/per-user/aier/share` (which has no gnome-shell extensions dir).

**Why:** This is the spine-breaker for any "declarative GNOME extensions via the home
path" plan. It is structural (session-env / scan-path), not a nixpkgs-version issue —
a version bump won't fix it.

**How to apply:** When reviewing any plan to make GNOME extensions declarative:
(1) Reject the "home-side therefore ungated" framing — a *functional* install must go
system-side, which is gated + previously declined. (2) Watch for the FALSE-PASS trap:
the 7 in-use extensions are still imperatively installed in
`~/.local/share/gnome-shell/extensions/` and load from there (verified ACTIVE), so any
test like "confirm all extensions still load after switch" passes regardless of whether
the declarative package is discoverable — it only fails on a fresh machine. Demand a
discriminating test (move the `~/.local/share` copy aside, confirm the Nix copy loads).
(3) dconf `enabled-extensions` in `gnome-shell.nix` is written authoritatively (no
mkDefault) — partial lists disable the rest; this part of such plans is usually correct.
See [[stylix-gtk-dconf-collision]] for the other dconf-priority footgun in this repo.
