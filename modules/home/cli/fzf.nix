# modules/home/cli/fzf.nix
{ config, lib, ... }:
let
  cfg = config.myHome.cli.fzf;
in
{
  options.myHome.cli.fzf.enable = lib.mkEnableOption "fzf fuzzy finder";

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      # Tune to taste.
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
      ];
    };
  };
}
