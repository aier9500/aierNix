{ config, lib, ... }:
let
  cfg = config.mySystem.snapper;
in
{
  options.mySystem.snapper.enable = lib.mkEnableOption "BTRFS snapper timeline snapshots";

  config = lib.mkIf cfg.enable {
    services.snapper = {
      configs.root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "aier" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 2;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
