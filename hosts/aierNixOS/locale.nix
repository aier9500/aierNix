# hosts/aierNixOS/locale.nix — host-specific locale deviations from the UK baseline
#
# The shared baseline (modules/system/core/locale.nix) is British English: metric, A4,
# £ GBP, DD/MM/YYYY dates. This host re-points two categories on top of that baseline,
# system-wide (so every session — shells AND GUI — picks them up via /etc/locale.conf):
#   • LC_TIME     → en_DK : ISO-8601 dates (2026-06-20) + 24-hour clock
#   • LC_MONETARY → en_US : currency in USD ($) instead of GBP (£)
# Both locales are generated in core/locale.nix (i18n.supportedLocales). mkForce is
# required because the baseline pins every LC_* to en_GB; this overrides those two keys.
#
# These are host-level (machine-wide) deviations, not a per-user override — replacing the
# former standalone home-manager module, which also sidesteps the HM GUI env-propagation
# quirk (system i18n writes /etc/locale.conf, which GDM/Wayland/GNOME read directly).
{ lib, ... }:

{
  i18n.extraLocaleSettings = {
    LC_TIME = lib.mkForce "en_DK.UTF-8"; # ISO-8601 dates, 24-hour clock
    LC_MONETARY = lib.mkForce "en_US.UTF-8"; # USD ($)
  };
}
