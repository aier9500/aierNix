{ pkgs, ... }:

{
  ########## User Apps ##########
  home.packages = (with pkgs; [
    claude-code
    darktable
    vesktop
    openconnect
  ]);

  ########## Gnome Extensions ##########
  # Installed IMPERATIVELY (GNOME Extensions app / extensions.gnome.org).
  # Declarative install + dconf enable crashed on baremetal from extension
  # version mismatch. Reinstall by hand:
  #   appindicator, blur-my-shell, caffeine, copyous, fuzzy-app-search,
  #   just-perfection, kando-integration, night-theme-switcher, shotzy

  services = {
    flatpak.enable = true; 
    flatpak.packages = [
      "app.zen_browser.zen"
      "be.alexandervanhee.gradia"
      "com.bitwarden.desktop"
      "com.github.tchx84.Flatseal"
      "com.mattjakeman.ExtensionManager"
      "io.github.seadve.Kooha"
      "io.github.zarestia_dev.rclone-manager"
      "io.missioncenter.MissionCenter"
      "md.obsidian.Obsidian"
    ];
  };

  programs = {

  };
}
