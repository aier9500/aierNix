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
        # lower opacity = more transparent; blur requires Blur my Shell on GNOME
        background-opacity = 0.8;
        background-blur = true;

        window-width = 120;
        window-height = 40;

        # options: default | never | always
        window-save-state = "never";
      };
    };
  };
}
