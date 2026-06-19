# Action Plan — Declarative GNOME Extensions (PLANNING ONLY)

**Status:** DRAFT PLAN. No system or home files have been modified. This document is
investigation + planning only. **Execution requires explicit user approval** (see the gate
at the end — this is a system-adjacent change under this repo's CLAUDE.md rules).

**Date:** 2026-06-19
**Owner of this plan:** opus-manager (L2), reporting to Commander
**Supersedes intent of:** ROADMAP TODO "Re-attempt declarative GNOME extensions only when
nixpkgs version-matching for extensions is reliable."

---

## 0. TL;DR — Feasibility Verdict

**Feasible NOW for the 6 non-Kando extensions via the home-manager path, conditionally.** As of
the current flake pin (nixpkgs-unstable rev `567a49d1913c`, lastModified 2026-06-16, GNOME Shell
**50.1**), every extension currently in use is present in nixpkgs, none is `meta.broken`, and
every one declares `"50"` in its `shell-version` metadata. The ROADMAP gate ("version-matching
reliable") is **met for this specific set at this specific pin** — verified empirically against
the pinned rev, not the latest nixpkgs (see §1, §2).

**The home-manager path is viable and ungated — this corrects a recorded finding.** Empirical
check (§2) shows the standalone home-manager profile share dirs ARE on the search path that
gnome-shell actually reads (systemd `--user` `XDG_DATA_DIRS`), and that `home.packages` land in
them. This **contradicts the 2026-06-19 Kando changelog claim** that a `home.packages` copy is
"invisible to the shell." The home path works; a system module is NOT required to make
extensions discoverable. (Flagged for the Commander/user — see §2 and §7.)

**Conditions on the verdict — attempt, but phased and gated:**

- A static "declares shell-version 50" check is **necessary but not sufficient**: nixpkgs does
  NO build-time shell-version assertion (verified — it is pure maintainer convention), and an
  extension can still throw at JS-load time even with a compatible `shell-version`. **The first
  dconf-takeover switch is the real test, not a formality.**
- The **2026-06-18 crash root cause was never conclusively pinned** (§3). Today all 8 extensions
  are clean in nixpkgs, which *contradicts the simplest version of the original story* and means
  the cause was either transient nixpkgs lag (since caught up) or something else (JS-load crash,
  or `targets.gnome`/User-Themes — note the ROADMAP separately records "User Themes extension
  crashed baremetal"). Treat the takeover switch as genuine risk.
- **Kando Integration stays imperative** — a deliberate 2026-06-19 decision. Note (§7) that one
  of that decision's two justifications (the discovery-mechanism claim) is now factually
  undercut; the *leanness / GUI-owned* rationale is independent and untouched. This plan honors
  the decision and does not relitigate it.

**Recommendation: attempt, packages-first (zero enablement risk), then a single full dconf
takeover treated as real risk, with the home-manager rollback path rehearsed in advance.**

---

## 1. Current State (verified against the live system + pinned nixpkgs)

### GNOME version
| Source | Value |
|---|---|
| `gnome-shell --version` (live) | **50.1** |
| nixpkgs branch | `github:nixos/nixpkgs/nixos-unstable` |
| Locked rev / lastModified | `567a49d1913ce81ac6e9582e3553dd90a955875f` / 2026-06-16 |

### Extensions in use (live `dconf read /org/gnome/shell/enabled-extensions`)
7 enabled, 1 known disabled. **Management is currently fully imperative** (extensions live in
`~/.local/share/gnome-shell/extensions/`, installed via the GNOME Extensions / Extension Manager
app); the repo declares *nothing* for extension packages or enablement today.

The table below was **verified against the exact pinned rev** (not latest nixpkgs) by evaluating
`gnomeExtensions.<attr>` from that flake and reading each package's `metadata.json`
`shell-version`:

| # | UUID | nixpkgs attr | ver | `shell-version` (pinned rev) | ⊇ 50? | broken? | Plan disposition |
|---|---|---|---|---|---|---|---|
| 1 | `appindicatorsupport@rgcjonas.gmail.com` | `gnomeExtensions.appindicator` | 64 | 45–50 | yes | no | **Declare** |
| 2 | `blur-my-shell@aunetx` | `gnomeExtensions.blur-my-shell` | 72 | 46–50 | yes | no | **Declare** |
| 3 | `caffeine@patapon.info` | `gnomeExtensions.caffeine` | 60 | 45–50 | yes | no | **Declare** |
| 4 | `copyous@boerdereinar.dev` | `gnomeExtensions.copyous` | 9 | 48–50 | yes | no | **Declare** |
| 5 | `focus-changer@heartmire` | `gnomeExtensions.focus-changer` | 25 | 45–50 | yes | no | **Declare** |
| 6 | `dash-to-dock@micxgx.gmail.com` | `gnomeExtensions.dash-to-dock` | 105 | 45–50 | yes | no | **Declare** |
| 7 | `kando-integration@kando-menu.github.io` | `gnomeExtensions.kando-integration` | 12 | 45–50 | yes | no | **KEEP IMPERATIVE** (deliberate, 2026-06-19) |
| 8 | `preserve-battery-health@marcosdalvarez.org` (disabled) | `gnomeExtensions.preserve-battery-health` | 6 | 48–50 | yes | no | Out of scope (stays disabled/imperative) |

**No problem cases against this pin.** All 8 exist, none broken, all include "50".

Live safety flags (verified): `disable-user-extensions` = unset (default `false`, OK);
`disable-extension-version-validation` = unset (default `false`, OK — validation is ON). The repo
already sets `disable-user-extensions = false` declaratively in
`modules/home/theming/gnome-dconf/gnome-shell.nix`.

> **Stale comment confirmed.** The commented-out `enabled-extensions` block in `gnome-shell.nix`
> is stale — it lists extensions no longer enabled (just-perfection, gnome-fuzzy-app-search,
> shotzy, nightthemeswitcher) and omits ones now in use (focus-changer, dash-to-dock). Do NOT
> reuse it verbatim; rebuild the list from the live `dconf read` value.

---

## 2. The declarative mechanism (and why the home path works — verified)

Enabling an extension declaratively is **two independent acts**:

1. **Provide the files** — install `pkgs.gnomeExtensions.<attr>` so the extension lands at
   `<profile>/share/gnome-shell/extensions/<uuid>/` on a directory gnome-shell searches.
2. **Enable it** — list the UUID in dconf `org/gnome/shell/enabled-extensions`.

Package without dconf entry = installed-but-off. dconf entry without package = enabled-but-missing
(no-op/error). Both halves required.

### Why the Home-Manager path is viable (primary-source verification)
This was the load-bearing open question, because the repo's own 2026-06-19 Kando changelog asserts
the standalone HM profile is "invisible to the shell." **That claim is empirically refuted here:**

- gnome-shell on Wayland runs under the **systemd user manager**, so the path that matters is
  `systemctl --user show-environment | grep XDG_DATA_DIRS` — NOT a bash shell's. Verified: that
  systemd `--user` `XDG_DATA_DIRS` **includes** both `/home/aier/.nix-profile/share` and
  `/home/aier/.local/state/nix/profile/share` (and also `/run/current-system/sw/share`).
- `~/.nix-profile` resolves to the **standalone home-manager profile**
  (`~/.local/state/nix/profile` → a `user-environment` store path).
- `home.packages` demonstrably land on that on-path dir: existing home packages' desktop files
  (`gradia`, `dconf-editor`, `kooha`, `mission-center`, `obsidian`, `darktable`) are all present
  in `~/.nix-profile/share/applications/`, and `~/.nix-profile/share/gnome-shell` already exists.

**Therefore:** a `gnomeExtensions.*` package added to `home.packages` will place its
`share/gnome-shell/extensions/<uuid>/` on a directory gnome-shell scans → it WILL be discovered.
The home path is the correct, **ungated (home-side, per CLAUDE.md)** path; a system module is NOT
required for discoverability.

> **Recorded-finding correction (for the Commander/user to action):** the 2026-06-19 Kando
> changelog entry says a system module is "required because gnome-shell scans
> `/run/current-system/sw/share` but **not** the standalone home-manager profile." The "not the
> HM profile" half is contradicted by the systemd `--user` environment above. The most likely
> explanation for the original observation is that nothing had yet installed a
> `share/gnome-shell/extensions` subdir into the HM profile (so there was nothing to scan), which
> is not the same as the dir being un-scanned — but I do not assert the prior author's exact
> error; I only report the current empirical truth. **This does not by itself reopen the Kando
> *decision*** (its leanness/GUI-owned justification is independent — see §7).

### `useUserPackages` — corrected framing
The earlier draft listed `home-manager.useUserPackages = true` as a Phase-1 pre-req. That option
is a **NixOS-module** option and does not apply to this repo's **standalone** home-manager
(`homeConfigurations.aier`, activated via `nh home switch`). It is not set anywhere in the repo,
and it does not need to be: standalone HM installs into `~/.nix-profile/share`, which (verified
above) is already on gnome-shell's search path. **Drop the `useUserPackages` pre-req** — it is a
non-issue for this setup. (Mentioned only to retract it; do not add it.)

### Version-matching, honestly
nixpkgs `buildGnomeExtension` performs **no build-time shell-version assertion** (verified by
reading the builder at `pkgs/desktops/gnome/extensions/buildGnomeExtension.nix` in the pinned
rev). The packaged `metadata.json` `shell-version` is a base64 snapshot the maintainer pinned at
packaging time. For *popular, well-maintained* extensions (all 6 here qualify) this is a reliable
heuristic on unstable; the fragility is the obscure long tail — none of which is in this set.
**Conclusion: reliable for this set at this pin, but it is convention, not enforcement** — hence
the takeover switch is the real test.

---

## 3. Risk assessment & root-cause of the 2026-06-18 crash

### Root cause (reconstructed — NOT proven)
The crash was attributed to "GNOME extension version mismatch with nixpkgs." Today's evidence
**contradicts the simplest version of that story** (all 8 are now clean in nixpkgs), so the true
cause is one of:
- **(a) Transient nixpkgs lag** — at the 2026-06-18 pin an extension wasn't yet bumped for GNOME
  50; nixpkgs has since caught up. (Most consistent with the ROADMAP gate wording.)
- **(b) JS-load crash despite a compatible `shell-version`** — an extension importing a removed
  GNOME 50 API still declares "50" and crashes the shell on load. (Why a static check can't fully
  de-risk this.)
- **(c) A different declarative GNOME change** — note the ROADMAP separately records the **User
  Themes extension / `targets.gnome`** crashing baremetal; if the 2026-06-18 attempt also touched
  Stylix `targets.gnome` or User Themes, that — not the 6 extensions here — may have been the
  culprit. This plan declares ONLY the 6 listed extensions and touches NOTHING related to
  `targets.gnome`/User Themes.

### Why declarative is *more* dangerous than imperative on failure
Under imperative control a bad extension can be toggled off from a recovery session. Under
**declarative dconf**, the UUID is re-asserted into `enabled-extensions` on every shell restart,
so a crash-on-load extension yields a **hard login loop** you cannot fix by toggling — you must
change the *config* and re-switch.

### The dconf array-overwrite footgun (shapes the phasing)
`dconf.settings."org/gnome/shell".enabled-extensions` is written **authoritatively** —
home-manager sets the key to *exactly* the list given; it does **not** merge with the live value.
So declaring a partial list (e.g. "just one to test") would **disable the other extensions** on
switch. The naive "add one extension at a time to dconf" advice is actively wrong here. *(This is
the standard home-manager dconf semantic and the repo already uses authoritative dconf writes
elsewhere; still, confirm on the generated dconf before the takeover switch — see the gate.)* The
phasing is built around it: packages first with NO dconf change, then a single full-list takeover.

### Mitigations (carry into every phase)
- **Never** set `disable-extension-version-validation = true`. Keep validation ON so an
  incompatible extension is *disabled*, not force-loaded into a crash.
- Keep `disable-user-extensions = false` (already declared).
- Build-only before any switch; inspect the closure diff.
- Have a TTY + home-manager rollback rehearsed (§5) *before* the takeover switch.
- One full-set takeover, then verify; do not also fold in Kando's package or the disabled
  extension.
- Do NOT touch `targets.gnome` / User Themes in this work (separate known-crash item).

---

## 4. Phased action plan (exact locations; for a future approved execution)

> Ordering separates "are the files available" (zero-risk) from "who owns enablement" (the risky,
> loop-capable step). All edits are **home-side** files (ungated). Build/verify in-harness; the
> USER runs every live `switch` (repo working pattern).

### Phase 0 — Packages only (zero enablement risk)
- **Edit:** `modules/home/apps/home-pkgs.nix` → add to `home.packages`:
  `pkgs.gnomeExtensions.appindicator`, `.blur-my-shell`, `.caffeine`, `.copyous`,
  `.focus-changer`, `.dash-to-dock`. (Do **not** add `kando-integration` — stays imperative.)
- **Do NOT touch dconf in this phase.** Extensions stay imperatively enabled via the existing live
  dconf value; you are only making the Nix-built copies discoverable on the profile share path.
- **Verify (build-only, no switch):**
  - `nix flake check`
  - `nh home build` (home-only change; no NixOS rebuild needed) — must build clean.
  - `nix store diff-closures` against the prior home generation — confirm only the expected
    extension packages are added.
- **Then the USER switches** (`nh home switch`), logs out/in, and confirms the desktop is
  **unchanged** and all 7 extensions still load (`gnome-extensions list --enabled`). Optionally
  confirm the Nix copy is now discoverable:
  `ls ~/.nix-profile/share/gnome-shell/extensions/`. Risk here is ~nil: no enablement changed.

### Phase 1 — dconf takeover (the real-risk step)
- **Edit:** `modules/home/theming/gnome-dconf/gnome-shell.nix` → replace the **stale** commented
  block with the **full current live list** (rebuild from `dconf read`, do NOT reuse the comment):
  ```nix
  "org/gnome/shell" = {
    disable-user-extensions = false;
    enabled-extensions = [
      "appindicatorsupport@rgcjonas.gmail.com"
      "blur-my-shell@aunetx"
      "caffeine@patapon.info"
      "copyous@boerdereinar.dev"
      "focus-changer@heartmire"
      "dash-to-dock@micxgx.gmail.com"
      "kando-integration@kando-menu.github.io"  # see Kando decision below
    ];
  };
  ```
  **Kando decision for the list (present BOTH options to the user at approval):** because the
  dconf write is authoritative, *omitting* the Kando UUID would DISABLE the imperatively-installed
  Kando extension on switch.
    - **Option A (recommended):** include the Kando UUID in dconf `enabled-extensions`
      (enablement-only) but keep its **package** imperative — do NOT add
      `gnomeExtensions.kando-integration` to `home.packages`. Preserves "Kando install stays
      imperative" while not clobbering its enabled state, and keeps the Haptic-button → pie-menu
      chain intact.
    - **Option B (most conservative):** keep dconf enablement fully imperative (do not declare
      `enabled-extensions` at all); declare only the *packages* (Phase 0). Kando and all
      enablement stay imperative — but extension *enablement* never becomes declarative, only
      partially achieving the goal.
  > This Kando/array-ownership interaction is the single subtlest decision in the plan and needs
  > an explicit user choice. Default to Option A unless the user prefers B.
- **Verify (build-only first):** `nix flake check`; `nh home build`; inspect the generated dconf
  keyfile to **confirm the authoritative write** matches the intended list. **Do not switch** until
  the rollback path (§5) is staged.
- **USER switches, then immediately:** log out/in. Watch `journalctl -f _COMM=gnome-shell` for
  load errors. Confirm `gnome-extensions list --enabled` matches the declared list and the desktop
  is stable. If the session loops → execute rollback (§5).

### Phase 2 — settle & document
- Update README "Manual setup (imperative)" to reflect what is now declarative vs. what remains
  manual (Kando install; the disabled `preserve-battery-health`).
- Update ROADMAP: close the TODO with the outcome and the pin it was validated against.
- **Note the recorded-finding correction** (§2/§7) in the changelog so the inaccurate Kando
  "invisible to the shell" claim is fixed in the record.
- Tuxie's-wiki mirror: if GNOME extension management is wiki-covered, **prompt the user** to
  dispatch a mirror (per CLAUDE.md) — do not edit the wiki silently.

---

## 5. Rollback strategy (rehearse BEFORE the Phase 1 switch)

**The dangerous failure is a login loop, and the rollback is home-manager-specific:**

- **A NixOS generation rollback does NOT undo a home-manager dconf change** (separate generation
  streams). Booting the previous *system* generation will not fix a bad `enabled-extensions`.
- **If the desktop loops but a TTY is reachable (Ctrl+Alt+F2):**
  - `home-manager generations` → activate the prior home generation
    (`/nix/.../home-manager-<N>-link/activate`), **or**
  - edit `gnome-shell.nix` to remove the offending UUID (or revert the dconf change) and
    `nh home switch`, then log out/in.
- **If GDM itself hard-crashes:** boot the previous *system* generation from the bootloader to get
  a working session, then apply the home-manager fix above.
- Because validation stays ON, the most likely real-world outcome of a bad extension is that GNOME
  simply *disables* it (not a loop) — but the plan assumes the worse case.

**Recovery rehearsal checklist (before switching):** confirm you can reach a TTY; confirm
`home-manager generations` lists a known-good prior generation; keep the working `gnome-shell.nix`
diff handy to revert.

---

## 6. Confirmation of no mutation

No system files, no home files, and no NixOS options were edited in producing this plan. No
`nh os switch` / `nh home switch` / activation was run. The only commands executed were read-only
inventory (`dconf read`, `gnome-shell --version`, `systemctl --user show-environment`, `ls`) and
read-only nixpkgs evaluation (`nix eval` / fetch of single packages into the store — no build of a
profile, no activation), plus reads of repo files. The imperative status quo is fully intact.

---

## 7. Notes flagged for the Commander / user (do not action without approval)

1. **A previously "verified" recorded finding is contradicted by primary-source evidence.** The
   2026-06-19 Kando changelog claims the standalone HM profile is invisible to gnome-shell; the
   systemd `--user` `XDG_DATA_DIRS` shows it is on the search path and that `home.packages` land
   there (§2). The home-side declarative path is therefore viable and ungated. Recommend
   correcting the record (changelog/DESIGN) — but that is the user's call.
2. **The Kando *decision* (keep imperative) is not auto-reopened.** It rested on two legs: a
   mechanism claim (now undercut) and a leanness/GUI-owned rationale (independent, untouched).
   This plan honors the decision and uses Option A so Kando's *enabled state* is not clobbered. If
   the user wants to revisit declaring Kando's package home-side now that discovery is confirmed,
   that is a separate, explicit decision.
3. **Phasing rests on dconf authoritative-write semantics**; confirm on the generated keyfile
   before the takeover switch (standard HM behavior, but verify rather than assume).

---

## ⛔ REQUIRES USER APPROVAL TO EXECUTE

This plan touches GNOME-extension management. The chosen path is **home-side (ungated)** under
CLAUDE.md, but the subject matter is system-adjacent and was explicitly scoped as **planning
only**. Before any execution:

1. **Get explicit user go-ahead** for the phased rollout.
2. **Decide the Kando question** (Option A vs B in Phase 1).
3. **Confirm the dconf authoritative-write semantics** on the generated keyfile before the
   takeover switch — the assumption the phasing rests on.
4. Execute Phase 0 → verify → Phase 1 (build-only → rehearse rollback → USER switch) → verify →
   Phase 2, one phase at a time, stopping on any anomaly. The USER runs every live switch.

**Do not implement any phase without the user's explicit approval.**
