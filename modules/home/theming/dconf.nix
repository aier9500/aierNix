# modules/home/theming/dconf.nix — GNOME dconf settings aggregator
# Imports the active GNOME dconf fragments. Extension settings/enablement are NOT
# managed here — GNOME extensions are fully imperative (see DESIGN.md L8).
{ config, lib, ... }:
let
  cfg = config.myHome.theming.gnome;
in
{
  options.myHome.theming.gnome.enable = lib.mkEnableOption "GNOME dconf theming";

  imports = [
    ./gnome-dconf/gnome-desktop-interface.nix
    ./gnome-dconf/gnome-clipboard.nix
    ./gnome-dconf/gnome-keybindings.nix
    ./gnome-dconf/gnome-tweaks.nix
    ./gnome-dconf/gnome-input-sources.nix
  ];

  config = lib.mkIf cfg.enable { };
}
