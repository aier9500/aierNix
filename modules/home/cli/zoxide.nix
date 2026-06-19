# modules/home/cli/zoxide.nix — zoxide smart directory jumper
{ config, lib, ... }:
let
  cfg = config.myHome.cli.zoxide;
in
{
  options.myHome.cli.zoxide.enable = lib.mkEnableOption "zoxide smart directory jumper";

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
