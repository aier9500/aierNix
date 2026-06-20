# Memory index — theoryy-workflow plan-adversary-reviewer (aierNix)

One line per memory; the body lives in the linked file.

- [Stylix gtk/dconf collision](project_stylix-gtk-dconf-collision.md) — which dconf interface keys the HM gtk target writes, why mkDefault on 3 keys is correct, and the silent 11→12pt font-size footgun under colorful themes
- [GNOME ext home-profile invisible](project_gnome-ext-home-profile-invisible.md) — gnome-shell ignores home.packages extensions (standalone HM); declarative install needs a system module (gated/declined); false-pass trap from leftover imperative copies
- [Standalone HM GUI env propagation](project_standalone-hm-gui-env-propagation.md) — home.sessionVariables/home.language reach login bash only, NOT GDM-Wayland GUI; need systemd.user.sessionVariables; nix-eval is blind to the gap
- [Auto-timezone VPN risk](project_auto-timezone-vpn-risk.md) — automatic-timezoned wanders to UTC/VPN-country on this ProtonVPN host (dead MLS, sparse beacondb); fixed time.timeZone is the safer default
