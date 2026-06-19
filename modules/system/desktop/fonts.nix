# modules/system/desktop/fonts.nix — system-level font packages
# Not active in P1 (no fonts.packages in current system config).
# Enabled in a future phase when system fonts are declared here.
{ config, lib, ... }:
let
  cfg = config.mySystem.desktop.fonts;
in
{
  options.mySystem.desktop.fonts.enable = lib.mkEnableOption "system font packages";

  config = lib.mkIf cfg.enable { };
}
