# hosts/aierNixOS/locale.nix — host-specific locale tweaks on the UK baseline.
#
# The baseline (modules/system/core/locale.nix) is British English. This host re-points
# two categories system-wide (every session reads them from /etc/locale.conf):
#   • LC_TIME     → en_DK : ISO-8601 dates + 24-hour clock
#   • LC_MONETARY → en_US : currency in USD ($)
# Both locales are generated in core/locale.nix. mkForce is needed because the baseline
# pins every LC_* to en_GB.
{ lib, ... }:

{
  i18n.extraLocaleSettings = {
    LC_TIME = lib.mkForce "en_DK.UTF-8"; # ISO-8601 dates, 24-hour clock
    LC_MONETARY = lib.mkForce "en_US.UTF-8"; # USD ($)
  };
}
