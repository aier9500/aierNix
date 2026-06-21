# modules/home/cli/gh.nix
{ config, lib, ... }:
let
  cfg = config.myHome.cli.gh;
in
{
  options.myHome.cli.gh.enable = lib.mkEnableOption "GitHub CLI";

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true; # let gh handle GitHub auth for git
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
