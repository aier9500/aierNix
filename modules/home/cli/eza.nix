# modules/home/cli/eza.nix
{ config, lib, ... }:
let
  cfg = config.myHome.cli.eza;
in
{
  options.myHome.cli.eza.enable = lib.mkEnableOption "eza directory listing tool";

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
