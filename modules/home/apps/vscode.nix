# modules/home/apps/vscode.nix — VS Code (install-only; no Nix config)
# Settings managed via VS Code Settings Sync / GitHub Gist — no Nix config intentional.
# Moved from system-pkgs (environment.systemPackages) to home in P2.
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
