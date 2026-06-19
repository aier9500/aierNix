# modules/home/apps/obs-studio.nix — OBS Studio screen recording/streaming
{ config, lib, ... }:
let
  cfg = config.myHome.apps.obsStudio;
in
{
  options.myHome.apps.obsStudio.enable = lib.mkEnableOption "OBS Studio screen recording";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [ ];
    };
  };
}
