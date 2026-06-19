# modules/home/misc/ibus-rime.nix — Rime user schema selection (home half)
#
# Writes ~/.config/ibus/rime/default.custom.yaml to enable the luna_pinyin (Pinyin)
# and jyut6ping3 (Cantonese Jyutping) schemas. Rime only READS this file and builds
# its deployment into ~/.config/ibus/rime/build/, so a read-only Nix-store symlink is
# fine here (unlike GUI-written configs — contrast the Kando/Solaar imperative case).
# The ibus framework + Rime engine are installed system-side (mySystem.ibus); the
# GNOME input source is set in gnome-input-sources dconf. See DESIGN.md L6.
{
  config,
  lib,
  ...
}:
let
  cfg = config.myHome.ibusRime;
in
{
  options.myHome.ibusRime.enable = lib.mkEnableOption "Rime schema selection (luna_pinyin + jyut6ping3)";

  config = lib.mkIf cfg.enable {
    xdg.configFile."ibus/rime/default.custom.yaml".text = ''
      # Managed by Nix (modules/home/misc/ibus-rime.nix). Rime reads this and deploys
      # into ~/.config/ibus/rime/build/. Switch schema with F4 or Ctrl+`.
      patch:
        schema_list:
          - schema: luna_pinyin
          - schema: jyut6ping3
    '';
  };
}
