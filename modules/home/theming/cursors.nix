# modules/home/theming/cursors.nix — bibata cursor theme
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myHome.theming.cursors;
in
{
  options.myHome.theming.cursors.enable = lib.mkEnableOption "bibata cursor theme";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.bibata-cursors ];
  };
}
