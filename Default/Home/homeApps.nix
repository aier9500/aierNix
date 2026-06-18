{ pkgs, ... }:

{

  home.packages = (with pkgs; [    # User Apps

    darktable
    dconf2nix
    gnome-boxes
    libreoffice
    vesktop
    # Installed through Flatpak: Zen Browser, Flatseal, Remembrance, GDM-Settings

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    blur-my-shell
    clipboard-indicator
    just-perfection
  ]);

  services = {

    blanket.enable = true;
  };

  programs = {

  };
}
