# modules/home/theming/fonts.nix — user font symlinks into ~/.local/share/fonts
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
      # IbmPlex removed — Stylix now installs IBM Plex via the font-packages target.
      # Keeping this would duplicate the font in ~/.local/share/fonts.
      ".local/share/fonts/JetBrainsMonoNerd".source =
        "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";
      ".local/share/fonts/NotoCjkSerif".source =
        "${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk";
      ".local/share/fonts/NotoCjkSans".source =
        "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk";
    };
  };
}
