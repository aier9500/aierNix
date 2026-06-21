# modules/system/power.nix — power-profiles-daemon (TLP disabled)
{ config, lib, ... }:
let
  cfg = config.mySystem.power;
in
{
  options.mySystem.power.enable = lib.mkEnableOption "power-profiles-daemon";

  config = lib.mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = true;
      tlp.enable = false;

      # GNOME "Battery Charge Limit" fix for ASUS Zenbook S 16 (UM5606WA).
      # asus_wmi exposes only charge_control_end_threshold (no start threshold).
      # upower's bundled rule requires a start threshold, so it never sets
      # ChargeThresholdSupported. This rule backfills it; _,80 tells upower to
      # skip the absent start threshold and cap charging at 80%.
      udev = {
        extraRules = ''
          ACTION=="remove", GOTO="upower_asus_end"
          SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}!="", IMPORT{builtin}="hwdb 'battery:$kernel:$attr{model_name}:$attr{[dmi/id]modalias}'"
          LABEL="upower_asus_end"
        '';
        extraHwdb = ''
          battery:BAT0:ASUS Battery:dmi:*svnASUSTeK*pnASUSZenbookS16*
           CHARGE_LIMIT=_,80
        '';
      };
    };
  };
}
