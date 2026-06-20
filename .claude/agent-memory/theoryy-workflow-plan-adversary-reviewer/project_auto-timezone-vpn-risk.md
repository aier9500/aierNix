---
name: auto-timezone-vpn-risk
description: services.automatic-timezoned is a fragile default on this host — ProtonVPN + degraded geoclue WiFi geolocation make the clock wander (UTC or VPN-country); fixed time.timeZone is safer
metadata:
  type: project
---

The user runs **ProtonVPN** on aierNixOS. A 2026-06-20 plan proposed replacing fixed `time.timeZone` with `services.automatic-timezoned.enable` (auto-enables geoclue2).

**Why this is fragile here:**
- Mozilla Location Service shut down 2024. nixpkgs migrated `services.geoclue2.geoProviderUrl` default to `https://api.beacondb.net/v1/geolocate` (a sparse volunteer successor) — verified in nixpkgs geoclue2.nix. WiFi-AP lookups frequently miss.
- On miss, geoclue falls back to IP geolocation → resolves to the **VPN exit country** while ProtonVPN is up.
- If no location at all, automatic-timezoned sets nothing and (with time.timeZone unset) the system defaults to **UTC**.
- Net: non-deterministic clock (UTC or VPN-country) on a VPN host. Worse for a community template — anyone behind a VPN/corporate-NAT inherits the wandering clock.

**How to apply:** On this repo/host, prefer a **fixed `time.timeZone`** for reproducibility and template cleanliness; treat auto-timezone as opt-in (toggle defaulting false, documented VPN caveat, requires network-online.target). The repo already declares `myConfig.timezone` (modules/options.nix) — wiring `time.timeZone = config.myConfig.timezone` is the clean fix. Note: as of the proposal both host files still had the stale dead value `myConfig.timezone = "America/Caracas"` (Venezuela) with zero consumers — a landmine if someone naively re-wires it. Related: [[standalone-hm-gui-env-propagation]].
