# modules/home/apps/home-pkgs.nix — general user-space application packages
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myHome.apps.homePkgs;
in
{
  options.myHome.apps.homePkgs.enable = lib.mkEnableOption "general home application packages";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [

      # Clipboard (Claude Code picture-paste requires both)
      wl-clipboard
      xclip
      # Shotzy OCR extension deps
      tesseract
      zbar
      # Theming
      adw-gtk3

      # GNOME utilities
      dconf-editor
      gnome-boxes
      gnome-extension-manager
      gnome-tweaks

      # Utils
      mission-center
      gradia # screenshot editor
      kooha # screen recorder util
      proton-vpn

      # Dev tools
      claude-code
      dconf2nix
      nodejs
      openconnect
      python3

      # Personal apps
      chromium
      rawtherapee
      obsidian
      vesktop

    ];
  };
}
