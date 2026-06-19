# pkgs

Scaffold for custom local package derivations. Currently empty — reserved for future use.

## Overview

`pkgs/default.nix` is a placeholder that returns an empty attrset (`{ }`). It exists so the custom-packages wiring point is established in the repo structure before any local derivations are needed.

## File

| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Custom package derivations (currently none) |

## Current State

The file is intentionally empty:

```nix
# pkgs/default.nix — custom packages scaffold
{ }
```

No custom derivations are wired into `flake.nix` yet.

## Adding a Custom Package

When a local derivation is needed, add it to `default.nix` and expose it via `flake.nix` so it can be referenced in modules.

```nix
# pkgs/default.nix
{ pkgs }:
{
  myTool = pkgs.stdenv.mkDerivation {
    pname = "my-tool";
    version = "1.0.0";
    src = ./my-tool-src;
    # ...
  };
}
```

Then expose it in `flake.nix`:

```nix
let
  customPkgs = import ./pkgs { inherit pkgs; };
in
{
  packages.${system} = customPkgs;
  # modules can then receive customPkgs via specialArgs or overlays
}
```

## Notes

- Before writing a local derivation, check whether the package exists in nixpkgs (`nix search nixpkgs <name>`) or is available as a flatpak. Local derivations require ongoing maintenance to track upstream.
- Per the [Flatpak minimize policy](../DESIGN.md#flatpak--minimize-policy), prefer nixpkgs packages over local derivations, and flatpak only for packages unavailable or broken in nixpkgs.
- If the custom package is a fork or patch of an existing nixpkgs package, an overlay in [`../overlays/`](../overlays/) may be more appropriate than a standalone derivation here.
