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


      ##################################
      ########## Dependencies ##########
      ##################################

      # Clipboard tools — Claude Code needs these to allow pasting pictures
      wl-clipboard
      xclip
      # Automation tool — OpenWhispr needs this to autopaste in Wayland
      ydotool
      # Extension — Shotzy OCR
      tesseract
      zbar
      # Theming
      adw-gtk3


      ###################################
      ########## User Programs ##########
      ###################################
      
      # GNOME utilities
      dconf-editor
      gnome-boxes
      gnome-extension-manager
      gnome-tweaks
      
      # Utils
      mission-center # system monitor
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
