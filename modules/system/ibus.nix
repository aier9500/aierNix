# modules/system/ibus.nix — ibus + Rime engine (system half)
#
# Registers the Rime engine via i18n.inputMethod so GNOME's ibus-daemon finds it.
# Bundled rime-data includes luna_pinyin + jyut6ping3 — no rimeDataPkgs override
# needed. Schema selection and GNOME input source live in the home half
# (modules/home/misc/ibus-rime.nix). GNOME uses ibus via text-input-v3, not
# GTK_IM_MODULE. See DESIGN.md L6.
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
