# aierNix

<!-- ════════════════════════════════════════════════════════════════════ -->

> [!NOTE]
> ## ✍️ Final thoughts
>
> _Placeholder — my closing reflections, to be written before archiving._
>
> <!-- write here -->
>
> &nbsp;

<!-- ════════════════════════════════════════════════════════════════════ -->

---

> [!IMPORTANT]
> ## 📦 Archived — an experimental 3-day port
>
> This repo ports my personal Fedora setup (~95%) and customisation habits onto
> NixOS + home-manager — declarative, define-once, never-set-up-again — built in
> three days with AI agents handling the most tedious work.
>
> A modular, option-based Nix config had been a ~2-year dream of mine; what always
> stopped me was the sheer tedium of the setup. This was both a way to learn Nix and
> an experiment in how much of that tedium an AI agent could take off my hands. It
> turned out to be enough to finally make the dream real — with just my hands and AI
> agents.
>
> It is archived as a starting-point **template** to fork and adapt — **not** a
> polished, battle-hardened config. Expect to review every module, adjust hardware
> settings, and test features before relying on them; not everything is verified on
> hardware other than the original machine.

---

Personal NixOS + home-manager flake. Declarative config transferred from the
[tuxies-wiki](https://github.com/theory-y/tuxies-wiki) aiers-fedora-checklist,
restructured into a best-practice `hosts/` + `modules/` layout with standalone
home-manager and a local quality gate.

Doctrine lives in `DESIGN.md`. Rebuild plan and changelog live in `ROADMAP.md`.

---

## Layout

```
flake.nix                          # inputs + outputs (nixosConfigurations.aierNixOS, homeConfigurations.aier)
flake.lock
.envrc                             # use flake (nix-direnv auto-loads devShell on cd)

lib/
  default.nix                      # mkHost + mkHome helper functions

hosts/
  aierNixOS/
    default.nix                    # sets myConfig.* values, flips feature toggles on, imports core modules
    home.nix                       # home-manager entry: sets myConfig.*, enables home toggles, imports home modules
    hardware-configuration.nix     # machine-specific (tracked — flakes only see git-tracked files)

modules/
  options.nix                      # myConfig.* cross-cutting values (user, hostname, timezone, locale, themeName)
  system/
    core/                          # always-on (no enable option) — always imported by host
      boot.nix                     # GRUB EFI + Catppuccin theme, grub-btrfs, btrfs fs-support
      fs.nix                       # snapper btrfs timeline snapshots
      networking.nix               # hostname, networkmanager, hostId
      locale.nix                   # timezone, i18n, LC_* settings
      users.nix                    # users.users.aier definition, extraGroups
    desktop/
      gnome.nix                    # GNOME + GDM + Wayland + excludePackages  [mySystem.desktop.gnome.enable]
      pipewire.nix                 # pipewire stack, disable pulseaudio         [mySystem.desktop.pipewire.enable]
      fonts.nix                    # system-level font packages                 [mySystem.desktop.fonts.enable]
    keyd.nix                       # Colemak DH evdev remap                     [mySystem.keyd.enable]
    snapper.nix                    # btrfs timeline snapshots for root           [mySystem.snapper.enable]
    virtualisation.nix             # libvirtd                                    [mySystem.virtualisation.enable]
    flatpak.nix                    # services.flatpak system-level enablement    [mySystem.flatpak.enable]
    power.nix                      # power-profiles-daemon + battery charge-limit [mySystem.power.enable]
    printing.nix                   # CUPS                                        [mySystem.printing.enable]
    solaar.nix                     # Logitech: hardware.logitech.wireless + udev [mySystem.solaar.enable]
    ibus.nix                       # ibus + Rime engine (luna_pinyin, jyut6ping3) [mySystem.ibus.enable]
    openwhispr.nix                 # voice dictation (upstream flake module, protocol handler) [mySystem.openwhispr.enable]
    nix.nix                        # nix.settings, programs.nh, allowUnfree, stateVersion
    system-pkgs.nix                # environment.systemPackages (git, gparted, ffmpeg-full, home-manager, …)
  home/
    shell/
      bash.nix                     # PS1, aliases, yazi y(), fastfetch call      [myHome.shell.bash.enable]
    cli/
      eza.nix                      #                                             [myHome.cli.eza.enable]
      fzf.nix                      #                                             [myHome.cli.fzf.enable]
      zoxide.nix                   #                                             [myHome.cli.zoxide.enable]
      gh.nix                       # GitHub CLI                                  [myHome.cli.gh.enable]
      yazi.nix                     # settings, keymap, theme                     [myHome.cli.yazi.enable]
      fastfetch.nix                #                                             [myHome.cli.fastfetch.enable]
    terminal/
      ghostty.nix                  # theme, opacity, blur, window size           [myHome.terminal.ghostty.enable]
    apps/
      vscode.nix                   # install-only; Settings Sync handles config  [myHome.apps.vscode.enable]
      obs-studio.nix               #                                             [myHome.apps.obsStudio.enable]
      flatpak-home.nix             # nix-flatpak packages list                   [myHome.apps.flatpak.enable]
      home-pkgs.nix                # general home packages (darktable, vesktop, claude-code, …)
    theming/
      dconf.nix                    # aggregator for gnome-dconf/*                [myHome.theming.gnome.enable]
      gnome-dconf/                 # desktop-interface, clipboard, keybindings, tweaks, input-sources, shell, night-theme
      stylix.nix                   # theme-selector framework + vanilla profile  [myConfig.themeName]
      fonts.nix                    # home.file font symlinks                     [myHome.fonts.enable]
    misc/
      kando.nix                    # package + autostart .desktop (config imperative)  [myHome.kando.enable]
      ibus-rime.nix                # Rime schema list (default.custom.yaml)             [myHome.ibusRime.enable]

overlays/
  default.nix                      # overlay scaffold (empty)

pkgs/
  default.nix                      # custom packages scaffold (empty)
```

Each subdirectory has its own README for detail. See `DESIGN.md` for doctrine
(feature-toggle convention, system/home split, standalone HM, quality gate).

---

## Output names

| Flake output | Command target |
|---|---|
| `nixosConfigurations.aierNixOS` | `nh os switch` / `sudo nixos-rebuild switch --flake .#aierNixOS` |
| `homeConfigurations.aier` | `nh home switch` / `home-manager switch --flake .#aier` |

---

## Install on a new machine

Run each step in order.

### 1. Get `git`

A fresh NixOS install has no `git`. Drop into a temporary shell:

```bash
nix-shell -p git
```

Stay in this shell for the next steps. It vanishes when you `exit` — `git`
becomes permanent once you build the config.

### 2. Enable flakes for this terminal

Flakes are off by default on a fresh system. The config you are about to build
turns them on permanently — but the first few commands run before that:

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
```

After the first system switch (step 5) flakes are on system-wide and you never
set this again.

### 3. Clone the repo

Clone to exactly `~/.dotfiles/aierNix` — this is the path `programs.nh.flake`
exports as `NH_FLAKE` and the path the `homesw`/`sysw` aliases resolve to.

```bash
git clone <repo-url> ~/.dotfiles/aierNix
cd ~/.dotfiles/aierNix
```

### 4. Generate and track this machine's hardware config

Every machine has different disks, so each needs its own
`hardware-configuration.nix`. Generate it directly:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/aierNixOS/hardware-configuration.nix
```

Then **git-add it** — Nix flakes only copy git-tracked files; an untracked
hardware config causes a "file not found" build failure:

```bash
git add hosts/aierNixOS/hardware-configuration.nix
```

Check where the EFI System Partition (ESP) is and add an override if needed:

```bash
findmnt /boot /boot/efi
lsblk -f
```

- **ESP at `/boot`** (default): nothing to add — works as-is.
- **ESP at `/boot/efi`** (separate): add to `hardware-configuration.nix`:
  ```nix
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  ```
- **BIOS/legacy-boot VM**: add to `hardware-configuration.nix`:
  ```nix
  boot.loader.grub.efiSupport = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.devices = lib.mkForce [ "/dev/vda" ];
  ```

### 5. First-switch bootstrap

On a machine that does not yet have `nh` installed, bootstrap with raw commands:

```bash
# Home-manager first (-b backup keeps any pre-existing dotfiles)
home-manager switch --flake .#aier -b backup

# Then system
sudo nixos-rebuild switch --flake .#aierNixOS
```

After the system switch, `nh` is installed and `programs.nh.flake` exports
`NH_FLAKE=/home/aier/.dotfiles/aierNix` into `/etc/set-environment`. This file
is loaded at **login**, so the bare `nh` form and the `homesw`/`sysw` aliases
become available on the next login (or after `source /etc/set-environment` in
your current shell).

### 6. Commit the hardware config

```bash
git commit -m "hardware-config for <hostname>"
```

Done. Reboot if the build changed the bootloader or kernel.

---

## Manual setup (imperative)

Some things are **intentionally not declared** in this flake. These apps own config
files that their own GUI rewrites at runtime — a Nix-managed file would be a
read-only symlink the app cannot save to — or they hold per-account secrets. So the
flake installs them and stops there; the one-time configuration is a manual step on
each new machine. Same philosophy as VS Code Settings Sync and the
secrets-imperative policy (see `DESIGN.md`).

> **After a fresh `nh home switch`, Kando and Solaar start from defaults.** Their
> prior config is recoverable from git history (the in-repo copies were removed in
> the 2026-06-19 imperative refactor) and lives canonically in the
> [tuxies-wiki](https://github.com/theory-y/tuxies-wiki).

### Kando (radial menu)

*Declared:* package + autostart `.desktop` (`modules/home/misc/kando.nix`).

1. Install **and** enable the **Kando Integration** GNOME extension via the GNOME
   Extensions app, then restart Kando. On Wayland this extension is what lets Kando
   bind its global shortcut — the Haptic-button → pie-menu chain does **not** work
   until it's active. (It is version-matched in nixpkgs and *could* be installed
   declaratively, but is kept imperative to let the GNOME Extensions app own it;
   see DESIGN.md L8.)
2. Build your pie menus in the Kando settings editor. Kando writes
   `~/.config/kando/{config.json,menus.json}` itself.

### Solaar (Logitech devices)

*Declared:* install + udev rules via `hardware.logitech.wireless`, **plus** the
autostart `.desktop` (`/etc/xdg/autostart/solaar.desktop`) — all in
`modules/system/solaar.nix`.

- **Start at login is declared** — you do **not** need to toggle Solaar's GUI
  "Start at login" option; the declaration handles it (launches minimized to the
  tray via `--window=hide`). If you previously enabled that GUI toggle, it left a
  redundant `~/.config/autostart/solaar.desktop`; harmless, but you can delete it.
- Configure device rules and button remaps in the Solaar GUI. Solaar saves them to
  `~/.config/solaar/rules.yaml` (the device-serial-specific `config.yaml` is also
  regenerated by the app).

### GNOME extensions

*Declared:* nothing — extensions are **fully imperative** (DESIGN.md **L8**).

- Install and enable each extension via the GNOME Extensions app (or the
  **Extension Manager** flatpak); the extensions own their own settings.
- For reference: a `home.packages` install *is* discoverable by gnome-shell (the
  old "needs a system module" claim was wrong), but extensions are kept fully
  imperative by choice — for leanness and a simpler mental model. The manual list
  lives in tuxies-wiki.

### Bitwarden (secrets)

*Declared:* flatpak install `com.bitwarden.desktop`
(`modules/home/apps/flatpak-home.nix`).

- Sign in to your account; secrets sync from the vault. There is **no** declarative
  secrets backend (no sops-nix / agenix) — secrets are imperative by design
  (`DESIGN.md`).

### VS Code (settings)

*Declared:* install-only (`modules/home/apps/vscode.nix`).

- Sign in to **Settings Sync**; settings and extensions restore from your GitHub
  account. Nix-managed settings would conflict (DESIGN.md **L10**).

### OpenWhispr (voice dictation) — UNTESTED

*Declared:* `modules/system/openwhispr.nix`; toggle: `mySystem.openwhispr.enable`.

Integrates OpenWhispr via its upstream flake NixOS module
(`inputs.openwhispr.nixosModules.default`), which handles the system-side
Wayland auto-paste dependencies: enables `programs.ydotool` (ydotoold daemon +
`ydotool` group + socket), enables `hardware.uinput` (kernel module + udev
rule), and adds the declared user to the `ydotool`, `uinput`, and `input`
groups. A re-login is required for group membership to take effect.

> **Browser / web sign-in: WORKS.**
> OpenWhispr (Electron) gates social login on `isDefaultProtocolClient`, which
> checks `${app.name}.desktop`. The app name is `open-whispr` (hyphenated), and
> Electron overwrites `$CHROME_DESKTOP` to that value at startup — so
> launch-time environment tricks do not stick. The fix is to register a desktop
> entry with that exact id (`open-whispr.desktop`) as the `openwhispr://`
> protocol handler and set it as the scheme default via
> `xdg.mime.defaultApplications`. This is done in `openwhispr.nix`.

> **Wayland auto-paste: NOT WORKING / UNTESTED.**
> Auto-paste may type a literal `v` instead of pasting — the Ctrl modifier
> appears to be dropped from the injected Ctrl+V key event. Two suspected
> causes, not yet resolved as of archiving: (1) a uinput device-enumeration
> race between ydotoold and the OpenWhispr process, and (2) keyd (Colemak DH +
> modifier remaps) intercepting the synthetic input events before they reach the
> target window. Do not rely on auto-paste without verifying it on your hardware.

---

## Day-to-day cheatsheet

After the bootstrap, all switches go through `nh`:

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

### Flake path behavior

`nh os switch` and `nh home switch` take a flake path. From inside the repo
the path is `.`. The **bare form** (no path argument) works from anywhere because
`programs.nh.flake` sets `NH_FLAKE=/home/aier/.dotfiles/aierNix` in
`/etc/set-environment`, which is loaded at login. If you just ran a system
switch in a fresh terminal you may need a new login (or
`source /etc/set-environment`) before the bare form resolves.

### Aliases

```
homesw  →  nh home switch
sysw    →  nh os switch
nixse   →  nix search nixpkgs
```

These are declared in `modules/home/shell/bash.nix`.

---

## Quality gate

All tooling is available in the devShell. `.envrc` (`use flake`) auto-loads it
via nix-direnv on `cd`.

| Tool | Role | How to run |
|---|---|---|
| nixfmt-rfc-style | Formatter | `nix fmt` |
| statix | Linter (anti-patterns, `with pkgs;` detection) | `statix check .` |
| deadnix | Dead code elimination | `deadnix .` |
| git-hooks.nix | Pre-commit: runs all three on staged `.nix` files | automatic on `git commit` |

`nix flake check` must pass before any merge to `main`.
