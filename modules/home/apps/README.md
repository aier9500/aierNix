# modules/home/apps — Home-Manager Application Modules

Home-manager modules for user-space applications. Each file declares a `myHome.apps.<name>.enable` toggle; the host flips those toggles in `hosts/aierNixOS/home.nix`. This directory is the correct place for any GUI or CLI application that should be installed at the user level rather than system-wide.

---

## Directory Structure

```
modules/home/apps/
├── flatpak-home.nix   # myHome.apps.flatpak    — declarative Flatpak user packages (nix-flatpak)
├── home-pkgs.nix      # myHome.apps.homePkgs   — general install-only packages via home.packages
├── obs-studio.nix     # myHome.apps.obsStudio  — OBS Studio via programs.obs-studio
└── vscode.nix         # myHome.apps.vscode     — VS Code (install-only; Settings Sync owns config)
```

---

## Module Reference

### [`vscode.nix`](./vscode.nix)

| What | Value |
|---|---|
| Option | `myHome.apps.vscode.enable` |
| Package | `pkgs.vscode` via `home.packages` |
| Config managed by Nix? | No — intentional |

Install-only. VS Code settings, keybindings, and extensions are managed entirely by **VS Code Settings Sync** (GitHub Gist). Nothing is written to `~/.config/Code/`. This is the GUI-Owned Config doctrine applied to cloud-sync — see `DESIGN.md` L10.

---

### [`obs-studio.nix`](./obs-studio.nix)

| What | Value |
|---|---|
| Option | `myHome.apps.obsStudio.enable` |
| Mechanism | `programs.obs-studio.enable = true` |
| Plugins | None declared (`plugins = []`) — add here if needed |

Uses the home-manager `programs.obs-studio` module rather than bare `home.packages`, which wires up any HM-managed integration points. The `plugins` list is empty and ready to extend.

---

### [`home-pkgs.nix`](./home-pkgs.nix)

| What | Value |
|---|---|
| Option | `myHome.apps.homePkgs.enable` |
| Mechanism | `home.packages` list |
| Config managed by Nix? | No — install-only throughout |

General-purpose package bucket for GUI and CLI applications that need no Nix-managed config. Packages are grouped by category with inline comments:

| Category | Packages |
|---|---|
| Photo / graphics | `darktable`, `gradia` |
| GNOME utilities | `dconf-editor`, `gnome-boxes`, `gnome-extension-manager`, `gnome-tweaks`, `mission-center` |
| Notes | `obsidian` |
| Screen recording | `kooha` |
| Networking | `proton-vpn` |
| Communication | `vesktop` |
| CLI / dev tools | `claude-code`, `dconf2nix`, `nodejs`, `openconnect`, `python3` |
| Theming | `adw-gtk3` |

Several of these were migrated from `flatpak-home.nix` on 2026-06-19 (`obsidian`, `mission-center`, `kooha`, `gnome-extension-manager`, `gradia`) once their nixpkgs packages were confirmed clean.

---

### [`flatpak-home.nix`](./flatpak-home.nix)

| What | Value |
|---|---|
| Option | `myHome.apps.flatpak.enable` |
| Mechanism | `services.flatpak.packages` (nix-flatpak HM module) |
| nix-flatpak injected by | `lib/default.nix` (`mkHome`) |
| System prerequisite | `mySystem.flatpak.enable = true` in `modules/system/flatpak.nix` |

Declarative Flatpak user packages. After the 2026-06-19 migration, exactly four apps remain:

| App ID | Reason to stay on Flatpak |
|---|---|
| `app.zen_browser.zen` | Not packaged in nixpkgs; browser sandbox desirable |
| `com.bitwarden.desktop` | nixpkgs `bitwarden-desktop` requires insecure `electron-39.8.10`; sandbox preferred for a secrets app |
| `com.github.tchx84.Flatseal` | Not packaged in nixpkgs; manages Flatpak permissions |
| `io.github.zarestia_dev.rclone-manager` | Not packaged in nixpkgs |

---

## Conventions

- **Feature-toggle template** — every module follows the same pattern:
  ```nix
  { config, lib, pkgs, ... }:
  let cfg = config.myHome.apps.<name>;
  in {
    options.myHome.apps.<name>.enable = lib.mkEnableOption "<description>";
    config = lib.mkIf cfg.enable { … };
  }
  ```
- **Never `with pkgs;`** — always write `pkgs.foo`. Statix enforces this.
- **Install-only by default** — do not declare config files for apps that own their own settings. Nix would symlink them read-only into the store, breaking any in-app save. Declare only packages and non-user-editable enablement artefacts (autostart entries, systemd user units).
- **Flatpak minimize-policy** (`DESIGN.md` "Flatpak — Minimize Policy") — Flatpak is a bridge, not a destination. When an app becomes available in nixpkgs and works cleanly without special runtime isolation, migrate it to `home-pkgs.nix` and remove it from `flatpak-home.nix`. Never list the same app in both files.
- **No cross-module imports** — modules do not import each other. Composition is the host's job.

---

## Dependencies & Relationships

| Direction | Target | Why |
|---|---|---|
| Imported by | `hosts/aierNixOS/home.nix` | Host is the only consumer; it flips the enable toggles |
| Reads from | `modules/options.nix` | `myHome.*` / `myConfig.*` option namespace |
| Paired with | `modules/system/flatpak.nix` | System module enables the Flatpak service; this module declares user packages |
| nix-flatpak injected by | `lib/default.nix` (`mkHome`) | The `services.flatpak` HM option is not available otherwise |

---

## Notes

- **`gnome-extension-manager`** is installed as a nixpkgs package but GNOME extensions themselves remain **imperative** — install and enable them through the Extensions app. Declarative extension enables caused crashes on bare metal due to version mismatches (DESIGN.md L8).
- **`obsidian`** requires `nixpkgs.config.allowUnfree = true`, which is already set in `modules/system/nix.nix`.
- **`kooha`** records via the PipeWire screencast portal; PipeWire must be enabled (`mySystem.desktop.pipewire`) for it to work.
- **`obs-studio.nix`** uses `programs.obs-studio` rather than bare `home.packages` so the plugin list is managed in one place and HM integration hooks can be added without restructuring the file.
- If you migrate a Flatpak app to nixpkgs, remember to: (1) add it to `home-pkgs.nix`, (2) remove its entry from `flatpak-home.nix`, and (3) run `nh home switch` — nix-flatpak will uninstall the Flatpak on the next activation.
