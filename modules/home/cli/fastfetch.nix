# modules/home/cli/fastfetch.nix — fastfetch system info display
{ config, lib, ... }:
let
  cfg = config.myHome.cli.fastfetch;
in
{
  options.myHome.cli.fastfetch.enable = lib.mkEnableOption "fastfetch system info display";

  config = lib.mkIf cfg.enable {
    programs.fastfetch.enable = true;
  };
}
