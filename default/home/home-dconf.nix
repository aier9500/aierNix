{ ... }:

{

  imports = [
    ./home-dconf/gnome-desktop-interface.nix
    ./home-dconf/gnome-clipboard.nix
    ./home-dconf/gnome-keybindings.nix
    ./home-dconf/gnome-tweaks.nix
    ./home-dconf/gnome-input-sources.nix
    # Extensions left imperative — declarative enable/settings crash on
    # extension version mismatch. Manage via GNOME Extensions app instead.
    # ./home-dconf/gnome-shell.nix       # enabled-extensions + just-perfection
    # ./home-dconf/gnome-night-theme.nix # nightthemeswitcher ext settings
  ];
}