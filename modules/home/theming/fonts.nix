# JetBrainsMono Nerd Font: full symbol/icon coverage prevents tofu in VS Code / TUI terminals.
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
