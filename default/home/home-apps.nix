{ pkgs, ... }:

{

  home.packages = (with pkgs; [    # User Apps

    adw-gtk3
    bibata-cursors
    darktable
    dconf2nix
    fluent-icon-theme
    ghostty
    gnome-boxes
    ibm-plex
    libreoffice
    vesktop
    yazi

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    blur-my-shell
    caffeine
    copyous
    fuzzy-app-search
    just-perfection
    kando-integration
    night-theme-switcher
    shotzy
  ]);

  services = {

    blanket.enable = true;

    flatpak.packages = [
      "app.zen_browser.zen"
      "be.alexandervanhee.gradia"
      "com.bitwarden.desktop"
      "com.github.tchx84.Flatseal"
      "io.github.dgsasha.Remembrance"
      "io.github.realmazharhussain.GdmSettings"
      "io.github.seadve.Kooha"
      "io.github.zarestia_dev.rclone-manager"
      "io.missioncenter.MissionCenter"
      "md.obsidian.Obsidian"
    ];
  };

  programs = {

  };
}
