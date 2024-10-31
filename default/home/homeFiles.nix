{ config, pkgs, input, ... }:

{
  home.file = {
    # fonts
    ".local/share/fonts/IbmPlex".source = "${pkgs.ibm-plex}/share/fonts/opentype";
    ".local/share/fonts/NotoCjkSerif".source = "${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk";
    ".local/share/fonts/NotoCjkSans".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk";
    # .icons
    ".local/share/icons/LatteLightCursors".source = "${pkgs.catppuccin-cursors.latteLight}/share/icons/catppuccin-latte-light-cursors";
    # .themes
    ".themes/MarbleBlueLight".source = "${pkgs.marble-shell-theme}/share/themes/Marble-blue-light";
    ".themes/MarbleBlueDark".source = "${pkgs.marble-shell-theme}/share/themes/Marble-blue-dark";
    ".themes/MarblePinkLight".source = "${pkgs.marble-shell-theme}/share/themes/Marble-pink-light";
    ".themes/MarblePinkDark".source = "${pkgs.marble-shell-theme}/share/themes/Marble-pink-dark";
    ".themes/MarblePurpleLight".source = "${pkgs.marble-shell-theme}/share/themes/Marble-purple-light";
    ".themes/MarblePurpleDark".source = "${pkgs.marble-shell-theme}/share/themes/Marble-purple-dark";
    ".local/share/themes/AdwGtk3".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3";
  };
}