# modules/home/terminal/ghostty.nix — ghostty terminal emulator
{ config, lib, ... }:
let
  cfg = config.myHome.terminal.ghostty;
in
{
  options.myHome.terminal.ghostty.enable = lib.mkEnableOption "ghostty terminal emulator";

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        # transparency: lower is more transparent (blur needs Blur my Shell on GNOME)
        background-opacity = 0.8;
        background-blur = true;

        # initial window grid size in columns and rows
        window-width = 120;
        window-height = 40;

        # restore window size across launches: default | never | always
        window-save-state = "never";
      };
    };
  };
}
