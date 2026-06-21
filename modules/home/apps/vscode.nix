# modules/home/apps/vscode.nix — install-only; settings managed via VS Code Settings Sync.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myHome.apps.vscode;
in
{
  options.myHome.apps.vscode.enable = lib.mkEnableOption "VS Code editor";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.vscode ];
  };
}
