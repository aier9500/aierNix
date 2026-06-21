# Rime schema selection (home half). Writes default.custom.yaml — Rime only reads
# this file and deploys into build/, so a read-only Nix-store symlink is fine.
# System half: mySystem.ibus. GNOME input source: gnome-input-sources dconf.
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
