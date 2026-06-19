# CLAUDE.md — aierNix repo rules

Doctrine lives in `DESIGN.md`; open work + changelog in `ROADMAP.md`. The rules below
are **hard constraints** for any agent working in this repo, on top of the TheoryY
workflow definition.

## System config requires explicit user approval

**Any change that touches system (NixOS) configuration requires explicit user approval
BEFORE proceeding — even in auto mode, and even when the user's request implies or
directly asks for it.** This repo is meant to be a universal template the open-source
community downloads and modifies minimally; unreviewed system changes risk clobbering a
known-good base.

"System configuration" means:

- `modules/system/**`
- `hosts/*/default.nix` and `hosts/*/hardware-configuration.nix`
- any NixOS-level option anywhere: `boot.*`, `services.*`, `hardware.*`,
  `environment.*`, `networking.*`, `users.*`, `i18n.*`, `nix.*`, `security.*`, etc.

Home-manager configuration does **not** require this gate: `modules/home/**`,
`hosts/*/home.nix`, dconf, user packages, dotfiles.

When a request needs a system change: **stop, describe the change, and ask for an
explicit go-ahead.** Only proceed once the user approves. (Keeping the system layer lean
and stable is also why GNOME extensions, Kando/Solaar configs, etc. are imperative — see
`DESIGN.md`.)

## Mirror changes to Tuxie's Wiki (prompt first)

When a change in this repo is also covered by Theory-Y's wiki (cloned at
`~/Projects/tuxies-wiki` — e.g. fastfetch, yazi, ghostty, bash, GNOME guides),
**prompt the user**, asking whether to dispatch an `opus-manager` to mirror the change in
the wiki. The wiki has its own rules — follow `~/Projects/tuxies-wiki/CLAUDE.md` →
`docs/notes/about/contributions/guidelines.md`. Do not edit the wiki silently or assume
consent; ask, then delegate if approved.
