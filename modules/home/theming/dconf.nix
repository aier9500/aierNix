# modules/home/theming/dconf.nix — GNOME dconf settings aggregator
# Imports active dconf fragments; extension-dependent fragments remain commented
# until declarative GNOME extensions are re-enabled (see DESIGN.md L8).
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
    # Extensions left imperative — declarative enable/settings crash on
    # extension version mismatch. Manage via GNOME Extensions app instead.
    # ./gnome-dconf/gnome-shell.nix       # enabled-extensions + just-perfection
    # ./gnome-dconf/gnome-night-theme.nix # nightthemeswitcher ext settings
  ];

  config = lib.mkIf cfg.enable { };
}
