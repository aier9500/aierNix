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
    home.packages = [
      # Photo / graphics
      pkgs.darktable
      pkgs.gradia # screenshot annotation (migrated from flatpak)
      # GNOME utilities
      pkgs.dconf-editor
      pkgs.gnome-boxes
      pkgs.gnome-extension-manager # migrated from flatpak; GNOME extensions stay imperative (L8)
      pkgs.gnome-tweaks
      pkgs.mission-center # system monitor (migrated from flatpak)
      # Notes
      pkgs.obsidian # migrated from flatpak; re-open vault after switch
      # Screen recording
      pkgs.kooha # migrated from flatpak; uses PipeWire screencast portal
      # Networking
      pkgs.proton-vpn
      # Communication
      pkgs.vesktop
      # CLI / dev tools
      pkgs.claude-code
      pkgs.dconf2nix
      pkgs.nodejs
      pkgs.openconnect
      pkgs.python3
      # Theming
      pkgs.adw-gtk3
    ];
  };
}
