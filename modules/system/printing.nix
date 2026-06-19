# modules/system/printing.nix — CUPS printing service
{ config, lib, ... }:
let
  cfg = config.mySystem.printing;
in
{
  options.mySystem.printing.enable = lib.mkEnableOption "CUPS printing";

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
