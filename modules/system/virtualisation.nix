{ config, lib, ... }:
let
  cfg = config.mySystem.virtualisation;
in
{
  options.mySystem.virtualisation.enable = lib.mkEnableOption "libvirtd virtualisation";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
  };
}
