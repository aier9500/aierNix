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
      pkgs.gnome-extension-manager # migrated from flatpak; extension *enablement* stays imperative (L8)
      pkgs.gnome-tweaks
      # GNOME Shell extensions — Phase 0: packages declarative (home.packages → HM profile share,
      # which gnome-shell's XDG_DATA_DIRS already includes); enablement still imperative via live dconf.
      # kando-integration deliberately excluded (stays fully imperative — leanness / GUI-owned rationale).
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.blur-my-shell
      pkgs.gnomeExtensions.caffeine
      pkgs.gnomeExtensions.copyous
      pkgs.gnomeExtensions.focus-changer
      pkgs.gnomeExtensions.dash-to-dock
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
      # Clipboard tools — Claude Code reads pasted images via `xclip … || wl-paste …`;
      # without these, image paste fails with "no image found in clipboard" (wl-clipboard
      # for the Wayland session, xclip for XWayland-sourced images).
      pkgs.wl-clipboard
      pkgs.xclip
      pkgs.dconf2nix
      pkgs.nodejs
      pkgs.openconnect
      pkgs.python3
      # Theming
      pkgs.adw-gtk3
    ];
  };
}
