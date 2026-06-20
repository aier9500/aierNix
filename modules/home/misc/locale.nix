# modules/home/misc/locale.nix — user-session locale overrides
#
# The system baseline is British English (modules/system/core/locale.nix: en_GB — metric,
# A4, £ GBP, DD/MM/YYYY dates). This module re-points two categories for *this user's*
# session on top of that baseline:
#   • LC_TIME     → en_DK : ISO-8601 dates (2026-06-20) + 24-hour clock (en_GB is DD/MM/YYYY)
#   • LC_MONETARY → en_US : currency in USD ($) instead of the system's GBP (£)
# Metric units and A4 paper are inherited from the en_GB baseline; LANG stays en_GB.
#
# Why two mechanisms (home-manager here is standalone): `home.language` only writes
# hm-session-vars.sh, which is sourced by login SHELLS. GUI apps under GDM/Wayland/GNOME
# read ~/.config/environment.d instead, so the overrides MUST be mirrored there via
# systemd.user.sessionVariables or they silently fail in graphical apps. Both referenced
# locales (en_DK, en_US) are generated system-side (i18n.supportedLocales). Re-login to apply.
{ config, lib, ... }:
let
  cfg = config.myHome.locale;
  isoTime = "en_DK.UTF-8"; # LC_TIME     — ISO-8601 dates, 24-hour clock
  usdMonetary = "en_US.UTF-8"; # LC_MONETARY — USD ($)
in
{
  options.myHome.locale.enable = lib.mkEnableOption "user-session locale overrides (ISO dates, USD currency)";

  config = lib.mkIf cfg.enable {
    # Login shells (TTY, ~/.profile) — via hm-session-vars.sh.
    home.language = {
      base = config.myConfig.locale; # LANG — British English baseline (en_GB.UTF-8)
      time = isoTime;
      monetary = usdMonetary;
    };

    # GUI session (GDM/Wayland/GNOME) — via ~/.config/environment.d. LANG=en_GB already
    # reaches the GUI from the system /etc/locale.conf, so only the overrides go here.
    systemd.user.sessionVariables = {
      LC_TIME = isoTime;
      LC_MONETARY = usdMonetary;
    };
  };
}
