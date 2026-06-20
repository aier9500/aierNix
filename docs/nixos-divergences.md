# NixOS divergences — what other distros give free that NixOS makes you declare

> **What this is.** A conceptual companion to the walkthrough of this repo: the places where a
> working Fedora/Ubuntu setup needs *extra, explicit* configuration on NixOS. It's the repo-side
> counterpart to the wiki's distro-general `aiers-fedora-checklist` — and per repo convention,
> NixOS-specific fixes live here, **not** mirrored to the general wiki.
>
> **How to read it.** Two kinds of divergence:
> - **A. Porting gotchas** — things that silently *broke* a working setup until configured. These
>   are the ones that bite; most cost real debugging time.
> - **B. Declarative-model baseline** — things NixOS makes you state explicitly *by design*. Not
>   bugs; just the cost of a reproducible, declarative system.
>
> Each entry: **what other distros do automatically → what NixOS needs → where → why.**

---

## A. Porting gotchas (the ones that bite)

### A1. Logitech / Solaar key remaps don't fire on Wayland
- **Other distros:** Solaar's "Key press" rules just work — the daemon can synthesize keystrokes.
- **NixOS needs:** `hardware.uinput.enable = true;` **and** the user in the `uinput` group
  (`users.users.<you>.extraGroups = [ "uinput" ];`).
- **Where:** `modules/system/solaar.nix` + `modules/system/core/users.nix`.
- **Why:** On Wayland, Solaar injects keys through the kernel's `/dev/uinput` device (XTest is
  X11-only and can't reach the Wayland compositor). That node is `root:uinput 0660`, and NixOS
  doesn't grant the `uinput` group by default — Fedora does. Without write access the injection
  fails *silently*. **Gotcha within the gotcha:** group membership only applies to processes
  started in a *new login session*, so after the switch you must **reboot / full re-login** (a
  Solaar restart in the old session still lacks the group). System change → needs approval.

### A2. Clipboard image-paste fails (Claude Code, terminal tools)
- **Other distros:** `xclip` / `wl-clipboard` ship by default, so tools that shell out to them work.
- **NixOS needs:** add `wl-clipboard` + `xclip` to `home.packages`.
- **Where:** `modules/home/apps/home-pkgs.nix`.
- **Why:** Claude Code reads a pasted image via `xclip … || wl-paste …`. NixOS ships neither.
  `wl-clipboard` covers the native Wayland clipboard; `xclip` covers XWayland-sourced images.

### A3. Legacy GTK apps render unthemed (wrong colors / default Adwaita)
- **Other distros:** the desktop theme reaches GTK2 / non-libadwaita GTK3 apps automatically.
- **NixOS needs:** enable the home-manager `gtk` module **unconditionally** and set
  `gtk.theme.name = "adw-gtk3"` (+ `adw-gtk3` available as a package).
- **Where:** `modules/home/theming/stylix.nix` (+ `home-pkgs.nix`).
- **Why:** Legacy GTK3 apps read `~/.config/gtk-3.0/settings.ini`, *not* the
  `org/gnome/desktop/interface/gtk-theme` dconf key. Only the home-manager `gtk` module writes that
  `settings.ini`. If the gtk module is gated behind a colorful theme, plain (vanilla) sessions leave
  legacy apps unthemed. libadwaita-default alone doesn't theme them.

### A4. Keyboard layout (Colemak-DH) on a Wayland session
- **Other distros / old NixOS habit:** set the layout in X11's `services.xserver.xkb`.
- **NixOS needs (Wayland):** set the GNOME **input source** via dconf to `us+colemak_dh`.
- **Where:** `modules/home/theming/gnome-dconf/gnome-input-sources.nix`.
- **Why:** GDM/GNOME on Wayland (L3) takes its layout from GNOME input-sources, not the X11 XKB
  system option (which has no effect on a Wayland session). Easy to set in the wrong place.

### A5. Modifier remaps (capslock→backspace, shift+shift→capslock) on Wayland
- **Other distros:** ship `keyd` as a package you enable.
- **NixOS needs:** `services.keyd` configured declaratively.
- **Where:** `modules/system/keyd.nix`.
- **Why:** keyd works at the **evdev** level (below the compositor), so it survives the Wayland
  switch where XKB-based modifier tricks don't. Note the division of labor (L4): keyd does
  *modifiers only*; the Colemak **letter** layout comes from the GNOME xkb input source (A4).

### A6. CJK input (Rime) needs *two* halves
- **Other distros:** install an ibus engine package and it's discovered.
- **NixOS needs:** **system** half — `i18n.inputMethod` (type `ibus`, engine `ibus-engines.rime`);
  **home** half — write `~/.config/ibus/rime/default.custom.yaml` (schemas: luna_pinyin, jyut6ping3).
- **Where:** `modules/system/ibus.nix` + `modules/home/misc/ibus-rime.nix`.
- **Why:** GNOME's ibus-daemon scans `/run/current-system/sw/share/ibus/component/` for engine XML —
  the system option registers the engine there. A system-only install leaves you with the engine but
  no schemas; the home half supplies those. (An earlier home-only attempt failed for exactly this
  reason — no system registration.)

### A7. Power profiles + battery charge-limit
- **Other distros:** ship one power daemon wired up; charge-limit "just appears" via distro udev/hwdb.
- **NixOS needs:** `services.power-profiles-daemon.enable = true;` **and disable** `services.tlp`
  (they conflict); plus device-specific `udev`/`hwdb` rules for the charge threshold.
- **Where:** `modules/system/power.nix`.
- **Why:** systemd allows only one power manager. And GNOME 50's charge-limit needs matching
  udev/hwdb entries per device (e.g. the ASUS Zenbook exposes only an end-threshold; a hwdb entry
  backfills the start-threshold so upower reports `ChargeThresholdSupported`).

---

## B. Declarative-model baseline (NixOS by design)

These aren't surprises so much as the tax of a reproducible system — you state explicitly what other
distros decide for you at install time.

### B1. `hardware-configuration.nix` must be **git-tracked**
- Flakes only copy files that git knows about. An untracked hardware-config → "file not found" build
  failure. Generated by `nixos-generate-config`, then `git add`-ed (L7). It's also exempt from the
  formatter/linters (machine-generated).

### B2. Bootloader + filesystems are declared, not auto-detected
- `boot.loader.grub`/`efi` and `fileSystems.*` are explicit. GRUB chosen over systemd-boot for OS-prober
  dual-boot support (L2). Other distros' installers do this silently.

### B3. User group membership is explicit
- `users.users.<you>.extraGroups` — every capability (`wheel` for sudo, `networkmanager`, `uinput`)
  is declared. There's no interactive `usermod -aG`; group changes take effect on next login.
  *(A1's uinput group is a special case of this.)*

### B4. Fonts symlinked from the Nix store
- Nix store paths are isolated, and home-manager has no built-in font module, so user fonts are
  symlinked into `~/.local/share/fonts` via `home.file` (`modules/home/theming/fonts.nix`).

### B5. Flatpak needs the system service first
- nix-flatpak's home module can't install user flatpaks without `services.flatpak.enable` at the
  system level (`modules/system/flatpak.nix`). Flatpak is treated as a bridge, not a destination —
  migrate apps to nixpkgs when cleanly packaged.

### B6. GNOME's extension metapackage is excluded
- The GNOME system config otherwise pulls in `gnome-shell-extensions` (bloat, given extensions are
  managed imperatively — L8). Excluded via `environment.gnome.excludePackages`
  (`modules/system/desktop/gnome.nix`).

---

## The pattern behind the gotchas

Most of section A reduces to one theme: **NixOS grants nothing implicitly.** Other distros ship a pile
of default udev rules, group memberships, helper packages, and service wiring that "just happen" to be
there. NixOS makes each of those a line you write — which is the whole point (reproducible, auditable),
but it means *porting a working setup surfaces every invisible dependency it relied on*. The Wayland
cases (A1, A4, A5) add a second theme: the X11-era way of doing a thing is silently inert on Wayland,
so the fix often lives in a different layer than muscle memory expects (dconf/evdev/uinput, not XKB/XTest).
