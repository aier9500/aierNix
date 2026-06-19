# modules/home/cli/fzf.nix — fzf fuzzy finder
{ config, lib, ... }:
let
  cfg = config.myHome.cli.fzf;
in
{
  options.myHome.cli.fzf.enable = lib.mkEnableOption "fzf fuzzy finder";

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      # No existing FZF_DEFAULT_OPTS found in shell config or tuxies-wiki.
      # These are sensible starting defaults — tune to taste.
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
      ];
    };
  };
}
