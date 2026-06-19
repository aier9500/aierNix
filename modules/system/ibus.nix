# modules/system/ibus.nix — ibus input-method framework + Rime engine (system half)
#
# Registers the Rime engine system-wide via i18n.inputMethod so GNOME's ibus-daemon
# finds it (the component lands in /run/current-system/sw/share/ibus/component). The
# engine's bundled rime-data already includes the luna_pinyin + jyut6ping3 schemas,
# so no rimeDataPkgs override is needed. The user schema selection and the GNOME
# input source live in the home half (modules/home/misc/ibus-rime.nix +
# gnome-input-sources dconf). GNOME integrates ibus via the input-source mechanism
# (text-input-v3), not GTK_IM_MODULE. See DESIGN.md L6.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.ibus;
in
{
  options.mySystem.ibus.enable = lib.mkEnableOption "ibus input method with the Rime engine";

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = [ pkgs.ibus-engines.rime ];
    };
  };
}
