# modules/home/misc — Miscellaneous Home Modules

Catch-all for home-manager feature modules that do not belong under `apps/` (GUI applications managed declaratively) or `cli/` (terminal tooling). Currently contains two modules: the Kando radial menu daemon and the Rime input-method schema selection.

---

## Directory Structure

```
modules/home/misc/
├── kando.nix      # myHome.kando — install + autostart for the Kando radial menu
└── ibus-rime.nix  # myHome.ibusRime — Rime schema selection (home half of ibus-rime split)
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

## ibus-rime.nix

Writes `~/.config/ibus/rime/default.custom.yaml` (via `xdg.configFile`) to enable two Rime schemas: `luna_pinyin` (Pinyin) and `jyut6ping3` (Cantonese Jyutping).

| What | How |
|---|---|
| Option | `myHome.ibusRime.enable` |
| Enabled in | `hosts/aierNixOS/home.nix` |
| File written | `~/.config/ibus/rime/default.custom.yaml` (declarative, read-only store symlink) |
| System half | `modules/system/ibus.nix` (`mySystem.ibus.enable`) |
| GNOME input source | `modules/home/theming/gnome-dconf/gnome-input-sources.nix` |

### Why a read-only symlink is correct here

This is the inverse of the Kando case. Rime only **reads** `default.custom.yaml` and compiles its deployment into `~/.config/ibus/rime/build/` — it never writes back to the source file. A read-only Nix-store symlink is therefore safe and correct, making this fully declarative-appropriate.

Contrast: Kando's `config.json` and `menus.json` are written by the app's own editor, so they must stay outside Nix's control.

### Three-part ibus-rime split (DESIGN.md L6)

The complete ibus-rime setup is spread across three locations:

| Part | Where | What |
|---|---|---|
| Framework + engine | `modules/system/ibus.nix` | `i18n.inputMethod` (type `ibus`), Rime engine, bundled rime-data |
| Schema selection | `modules/home/misc/ibus-rime.nix` (this file) | `default.custom.yaml` — `luna_pinyin` + `jyut6ping3` |
| GNOME input source | `modules/home/theming/gnome-dconf/gnome-input-sources.nix` | Registers `('ibus','rime')` as a GNOME input source |

### Usage notes

- Switch input sources (e.g. English ↔ Rime): **Super+Space**
- Switch Rime schema (Pinyin ↔ Jyutping): **F4** or **Ctrl+\`**
- After changing `default.custom.yaml`, Rime must redeploy: right-click the ibus-rime tray icon → "Deploy".

---

## Solaar

Solaar is **not here**. Its system-level install and udev rules live in `modules/system/solaar.nix`; its per-device rules are configured imperatively through the Solaar GUI (same GUI-owned-config reason as Kando above).

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
- If a new module belongs here, ask: does the app own its own config files? If yes, do not declare them; declare only packages and non-user-editable enablement files (autostart, systemd user units, etc.). If the app only reads the config file (like Rime), a declarative `xdg.configFile` is correct.

---

## Dependencies & Relationships

| Direction | Target | Why |
|---|---|---|
| Imported by | `hosts/aierNixOS/home.nix` | Host flips `myHome.kando.enable` and `myHome.ibusRime.enable` |
| Reads from | `modules/options.nix` | Shared `myHome.*` / `myConfig.*` option namespace |
| Paired with (ibus-rime) | `modules/system/ibus.nix` | System installs the ibus framework + Rime engine |
| Paired with (ibus-rime) | `modules/home/theming/gnome-dconf/gnome-input-sources.nix` | Registers the GNOME input source |
