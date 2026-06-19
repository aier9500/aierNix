# modules/system/flatpak.nix — system-level Flatpak enablement
{ config, lib, ... }:
let
  cfg = config.mySystem.flatpak;
in
{
  options.mySystem.flatpak.enable = lib.mkEnableOption "Flatpak system service";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
