# How this repo works — a walkthrough

> **Personal orientation doc — temporary.** Scratch notes to get the mental model to click;
> delete once familiar. Not part of the maintained doc set (the canonical docs are `DESIGN.md`,
> `ROADMAP.md`, `README.md`, and the subdir `README.md` files).

## The one idea
NixOS is **declarative**: you write a description of what the machine should be, and a *build* turns
that description into the real system. This repo *is* that description — organized so that turning a
feature on or off is flipping a single switch.

## 1. The bootstrap chain — how text becomes a running machine
A **flake** (`flake.nix`) is the front door. It pins your **inputs** (`nixpkgs` = the package universe
on the nixos-unstable channel; `home-manager`; `stylix` for theming; a few more) and declares
**outputs** — the things it can build. Two matter:
- `nixosConfigurations.aierNixOS` — your system
- `homeConfigurations.aier` — your user environment

`flake.nix` doesn't assemble those itself; it hands off to two tiny helpers in `lib/`:
- **`mkHost`** wraps nixpkgs' system builder (`nixosSystem`)
- **`mkHome`** wraps home-manager's builder

Both do one clever thing: they **auto-inject `modules/options.nix`** into every build and thread your
flake inputs through (as `specialArgs`). So every piece of config can see shared values without you
re-wiring it each time.

**The chain:** `flake.nix` → `lib/mkHost|mkHome` → `hosts/aierNixOS/` → `modules/`. The **host**
(`hosts/aierNixOS/default.nix` for system, `home.nix` for home) is the assembly point: it imports the
modules and sets the knobs — your identity (`myConfig.user = "aier"`, hostname, timezone, locale) and
which features are on.

## 2. The feature-toggle pattern — the one pattern that explains the whole repo
This is the heart of it. Every feature is a self-contained **module** with two halves:
- an **option** (the switch): `options.mySystem.keyd.enable = lib.mkEnableOption "…"`
- **guarded config**: `config = lib.mkIf cfg.enable { services.keyd = {…}; }`

The host flips the switch: `mySystem.keyd.enable = true;`. `lib.mkIf` means *"include this block only
if the switch is on"* — so an imported-but-disabled module contributes nothing.

**That's the skeleton key:** to understand any feature, open its module — the option line names the
switch, the `mkIf` block is what it does. To disable something, flip its switch in the host. Naming
convention: `mySystem.*` (system features), `myHome.*` (home features), `myConfig.*` (shared values
like `themeName`).

## 3. The two layers — system vs home
The repo splits into **two configs you build separately**:

- **System** (`modules/system/`, built by `nh os switch`) — root-owned essentials: bootloader,
  filesystems, networking, locale, users, and the *root halves* of services (GNOME/GDM, audio, keyd,
  ibus, printing, Solaar's udev + uinput). Rule of thumb: *if removing it would stop the machine
  booting or being reachable, it's system.*
- **Home** (`modules/home/`, built by `nh home switch`) — your user environment: shell, CLI tools,
  terminal, apps, theming, dotfiles. Everything customizable.

**Why two builds?** Home-manager runs **standalone** (not bolted into the system build), so the
boundary stays crisp: `nh os switch` touches only the system, `nh home switch` touches only your user
files — and the latter is far faster, so daily tweaks are cheap. This split is also why **system
changes are gated** (they can break boot for anyone using this as a template, so they need explicit
sign-off) while **home changes are not**.

## 4. The system layer, briefly
**Always-on core** (no toggle — load-bearing): `core/boot.nix` (GRUB+EFI), filesystems, networking
(NetworkManager), locale, users, `nix.nix` (flakes on, the `nh` wrapper, garbage collection).
**Toggled features:** gnome, pipewire (audio), keyd (modifier remaps), snapper (btrfs snapshots),
virtualisation (KVM), flatpak, power (profiles + battery charge-limit), printing, solaar, ibus.

## 5. The home layer, briefly
Grouped: `apps/` (packages; VS Code install-only; the flatpak bridge), `cli/` (eza, fzf, zoxide, yazi,
fastfetch), `shell/bash.nix` (your PS1 + aliases like `homesw`/`sysw`), `terminal/ghostty.nix`,
`theming/`, `misc/` (kando, ibus-rime).

## 6. Theming
Two tiers:
- **Stylix** (`theming/stylix.nix`): a theme registry keyed by `myConfig.themeName`. `vanilla` = inert
  (fonts/cursor only, no colors); `catppuccin`/`everforest`/`wallpaper-based` = colorful profiles that
  flip Stylix **targets** (GTK, ghostty, yazi) on. Changing theme = change one word + `nh home switch`.
  The **legacy-GTK fix** lives here: the home-manager `gtk` module is on unconditionally so `adw-gtk3`
  reaches old GTK apps even under vanilla.
- **dconf** (`theming/dconf.nix`): an aggregator importing small `gnome-dconf/` fragments — interface
  (fonts/cursor), keybindings, tweaks, input-sources (Colemak-DH + Rime). Plain GNOME settings, written
  declaratively. (Extensions are *not* here — they're fully imperative, L8.)

## 7. The quality gate
`nix flake check` runs three linters as pre-commit hooks: **nixfmt** (formatting), **statix**
(anti-patterns), **deadnix** (dead code) — `hardware-configuration.nix` is exempt (machine-generated).
The **devShell** (auto-loaded by direnv via `.envrc`) puts those + `nh` on your PATH. `nh … build` =
dry-run verify; `nh … switch` = build + activate. Test-first loop: verify uncommitted → switch →
commit on confirm.

## 8. The escape hatches — why some things are *not* declarative
Not everything belongs in Nix, and the repo is explicit about it:
- **GUI-owned config** (L11): Kando menus, Solaar rules — the app's editor rewrites these, and a Nix
  symlink is *read-only*, so the app couldn't save. Nix installs + enables; the app owns the file.
- **GNOME extensions** (L8): fully imperative — install/manage in the Extensions app.
- **Secrets**: no sops/agenix — apps sync their own (Bitwarden).
- **Flatpak**: a bridge, not a home — migrate to nixpkgs when cleanly packaged.

These escape hatches are where "NixOS's declarative ideal" meets the messy real world — and several are
the same spots where a working Fedora setup needs extra NixOS wiring (see `docs/nixos-divergences.md`).
