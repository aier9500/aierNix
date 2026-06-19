# modules/home/misc/fonts-home.nix — user font symlinks into ~/.local/share/fonts
# Uses home.file to expose font packages in the standard user font path.
# JetBrainsMono Nerd Font: full braille/box/symbol + icon coverage so the
# VS Code terminal (Claude Code TUI spinner, etc.) renders without tofu boxes.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myHome.fonts;
in
{
  options.myHome.fonts.enable = lib.mkEnableOption "user font symlinks";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/fonts/IbmPlex".source = "${pkgs.ibm-plex}/share/fonts/opentype";
      ".local/share/fonts/JetBrainsMonoNerd".source =
        "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";
      ".local/share/fonts/NotoCjkSerif".source =
        "${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk";
      ".local/share/fonts/NotoCjkSans".source =
        "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk";
    };
  };
}
