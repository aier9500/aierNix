# modules/home/misc — Miscellaneous Home Modules

Catch-all for home-manager feature modules that do not belong under `apps/` (GUI applications managed declaratively) or `cli/` (terminal tooling). Currently contains one module: the Kando radial menu daemon.

---

## Directory Structure

```
modules/home/misc/
└── kando.nix   # myHome.kando — install + autostart for the Kando radial menu
```

---

## kando.nix

Installs the `kando` package and writes an XDG autostart `.desktop` entry so the daemon launches at login.

| What | How |
|---|---|
| Option | `myHome.kando.enable` |
| Enabled in | `hosts/aierNixOS/home.nix` |
| Package | `pkgs.kando` via `home.packages` |
| Autostart | `~/.config/autostart/kando.desktop` (declarative — written by Nix) |
| GNOME extension | **Imperative** — install + enable via the GNOME Extensions app; see below |
| Config files | **Not managed** — see below |

### GUI-Owned Config — Imperative by Design

`config.json` (settings + global hotkey) and `menus.json` (pie menu definitions) are owned entirely by Kando's built-in settings editor. They are **not** declared in Nix.

Reason: an `xdg.configFile.….source` entry resolves to a read-only symlink into the Nix store. Kando cannot write back to a read-only path, so any in-app save would fail. Build and edit menus through the Kando UI; the files live at `~/.config/kando/` and are outside version control.

Autostart is the exception: it is enablement (guarantees the daemon runs at login), not user-editable config, so the read-only symlink is correct.

This pattern is the **GUI-Owned Config** doctrine — see `DESIGN.md` L11 and the "Manual setup (imperative)" section in the repo-root `README.md` for the full rationale.

### GNOME extension — imperative

On Wayland, Kando needs the **Kando Integration** GNOME Shell extension to bind its global shortcut. It is kept **imperative**: install and enable it via the GNOME Extensions app. (It is version-matched in nixpkgs — `gnomeExtensions.kando-integration` — and *could* be installed declaratively, but only from a system module, since gnome-shell does not scan the standalone home-manager profile. Declined to keep the system config lean; see `DESIGN.md` L8.)

---

## Solaar

Solaar is **not here**. Its system-level install and udev rules live in `modules/system/solaar.nix`; its per-device rules are configured imperatively through the Solaar GUI (same GUI-owned-config reason as above).

---

## Conventions

- Follow the same feature-toggle template used everywhere else in the repo:
  ```nix
  { config, lib, pkgs, ... }:
  let cfg = config.myHome.<feature>;
  in {
    options.myHome.<feature>.enable = lib.mkEnableOption "<description>";
    config = lib.mkIf cfg.enable { … };
  }
  ```
- Never `with pkgs;` — always `pkgs.foo`.
- If a new module belongs here, ask: does the app own its own config files? If yes, do not declare them; declare only packages and non-user-editable enablement files (autostart, systemd user units, etc.).

---

## Dependencies & Relationships

| Direction | Target | Why |
|---|---|---|
| Imported by | `hosts/aierNixOS/home.nix` | Host flips `myHome.kando.enable = true` |
| Reads from | `modules/options.nix` | Shared `myHome.*` / `myConfig.*` option namespace |
