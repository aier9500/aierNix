# overlays

Scaffold for nixpkgs overlays. Currently empty — reserved for future package overrides and patches.

## Overview

`overlays/default.nix` is a placeholder that returns an empty attrset (`{ }`). It exists so the overlays wiring point is established in the repo structure before any overlays are needed.

## File

| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Overlay definitions (currently none) |

## Current State

The file is intentionally empty:

```nix
# overlays/default.nix — overlay scaffold
{ }
```

No overlays are wired into `flake.nix` yet. The `nixosConfigurations` and `homeConfigurations` outputs use the upstream nixpkgs package set directly.

## Adding an Overlay

When a package override or patch is needed, add a function to `default.nix` and pass it to nixpkgs in `flake.nix` via `nixpkgs.overlays`. Example:

```nix
# overlays/default.nix
{
  somePackagePatch = final: prev: {
    somePackage = prev.somePackage.override { enableFeature = true; };
  };
}
```

Then in `flake.nix`, pass it through:

```nix
pkgs = import inputs.nixpkgs {
  inherit system;
  overlays = [ (import ./overlays).somePackagePatch ];
};
```

## Notes

- Overlays apply globally to the nixpkgs instance they are attached to. Prefer per-package `override` or `overrideAttrs` in a module when the change is local to one feature.
- The [Flatpak minimize policy](../DESIGN.md#flatpak--minimize-policy) in `DESIGN.md` is the preferred path for packages not in nixpkgs — migrate to nixpkgs proper rather than maintaining a local derivation, where possible.
