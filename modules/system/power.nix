# modules/system/power.nix — power-profiles-daemon (TLP disabled)
{ config, lib, ... }:
let
  cfg = config.mySystem.power;
in
{
  options.mySystem.power.enable = lib.mkEnableOption "power-profiles-daemon";

  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;
    services.tlp.enable = false;
  };
}
