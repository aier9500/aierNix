---
name: standalone-hm-gui-env-propagation
description: Standalone HM home.sessionVariables/home.language only reach login bash, NOT GDM-Wayland GUI apps — a recurring silent-failure trap for any env-var/locale plan
metadata:
  type: project
---

In this repo HM runs **standalone** (not the NixOS module — see DESIGN.md "Standalone Home-Manager Decision"). Consequence verified against HM source (modules/home-environment.nix, programs/bash.nix, systemd.nix, config/i18n.nix) on 2026-06-20:

- `home.language` → `home.sessionVariables` → exported ONLY via `~/.profile` + `~/.bashrc`. Login/interactive **bash only**.
- `home.sessionVariables` does **NOT** flow into `systemd.user.sessionVariables`, so it is **NOT** written to `~/.config/environment.d/`.
- Only `config/i18n.nix` writes to env.d, and it pushes only `LOCALE_ARCHIVE_2_27` (the archive *path*), never LANG/LC_* values. Confirmed empirically: live `~/.config/environment.d/10-home-manager.conf` had only LOCALE_ARCHIVE + XDG vars.
- Desktop = GDM Wayland + GNOME (gnome.nix). GDM does NOT source `~/.profile`. So GUI apps read `/etc/locale.conf` (pam_env, the system i18n baseline) — home overrides are invisible in the GUI.

**Why:** This makes any home-side env-var personalization (locale LC_*, EDITOR for GUI launchers, etc.) silently terminal-only. The nix-eval check `home.sessionVariables` shows the value set, which falsely reassures — eval can't see the env.d gap, and the terminal test passes while the GUI shows the system value.

**How to apply:** For any plan that sets env vars in home and expects them in GUI apps, flag CRITICAL unless it ALSO sets `systemd.user.sessionVariables`. Require the verification be done **in the GUI after a full logout/login** (env.d is read by `systemd --user` at session start, not on `nh home switch`), never just `echo $VAR` in a terminal. The HM locale archive (`pkgs.glibcLocales`, allLocales = ~840 locales) means home sessions resolve any locale regardless of system `i18n.supportedLocales` — so system supportedLocales entries are NOT what backs home overrides. Related: [[plan-validation-nix-eval-blind-spots]].
