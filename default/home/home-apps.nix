{ pkgs, ... }:

{
  ########## User Apps ##########
  home.packages = (with pkgs; [    
    darktable
    vesktop

  ########## Gnome Extensions ##########
  ]) ++ (with pkgs.gnomeExtensions; [

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
    flatpak.packages = [
      "app.zen_browser.zen"
      "be.alexandervanhee.gradia"
      "com.bitwarden.desktop"
      "com.github.tchx84.Flatseal"
      "io.github.seadve.Kooha"
      "io.github.zarestia_dev.rclone-manager"
      "io.missioncenter.MissionCenter"
      "md.obsidian.Obsidian"
    ];
  };

  programs = {

  };
}
