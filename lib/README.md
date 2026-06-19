# lib

Helper functions that wrap nixpkgs and home-manager's configuration builders, reducing boilerplate in `flake.nix`.

## Overview

`lib/default.nix` exports two functions — `mkHost` and `mkHome` — that are imported by `flake.nix` and used to build the repo's two top-level outputs:

- `nixosConfigurations.aierNixOS` via `mkHost`
- `homeConfigurations.aier` via `mkHome`

Both helpers automatically inject `modules/options.nix` (which declares the `myConfig.*` cross-cutting options) so every module in the call chain has access to `myConfig.user`, `myConfig.hostname`, etc. without the host file having to list it explicitly. Both also forward all flake `inputs` as `specialArgs` / `extraSpecialArgs`.

## File

| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Exports `mkHost` and `mkHome` |

## Functions

### `mkHost { system, modules }`

Wraps `nixpkgs.lib.nixosSystem`. Prepends `../modules/options.nix` to the caller-supplied module list and passes `inputs` as `specialArgs`.

```nix
# flake.nix usage
nixosConfigurations.aierNixOS = lib.mkHost {
  inherit system;
  modules = [ ./hosts/aierNixOS/default.nix ];
};
```

The host module (`hosts/aierNixOS/default.nix`) then sets `myConfig.*` values and imports the system feature modules it wants enabled.

### `mkHome { pkgs, modules }`

Wraps `home-manager.lib.homeManagerConfiguration`. Prepends two modules to the caller-supplied list:

1. `../modules/options.nix` — same cross-cutting options as the system side
2. `inputs.nix-flatpak.homeManagerModules.nix-flatpak` — makes `services.flatpak` available in any home module without the caller having to reference the nix-flatpak input directly

```nix
# flake.nix usage
homeConfigurations.aier = lib.mkHome {
  inherit pkgs;
  modules = [ ./hosts/aierNixOS/home.nix ];
};
```

## Dependencies & Relationships

| Direction | Target | Notes |
|---|---|---|
| Depends on | `inputs.nixpkgs` | Borrows `lib.nixosSystem` from nixpkgs |
| Depends on | `inputs.home-manager` | Borrows `lib.homeManagerConfiguration` |
| Depends on | `inputs.nix-flatpak` | Injects `homeManagerModules.nix-flatpak` into every `mkHome` call |
| Depends on | `../modules/options.nix` | Auto-injected into both helpers |
| Used by | `flake.nix` | The only caller; imports this file and calls both helpers |

## Notes

- `lib` here is a local variable name in `flake.nix` (`lib = import ./lib/default.nix { inherit inputs; }`), not to be confused with `nixpkgs.lib` or the built-in `lib` argument that NixOS modules receive.
- Adding a second host is purely additive: call `mkHost` again in `flake.nix` with a different host module path. The lib functions themselves need no changes.
