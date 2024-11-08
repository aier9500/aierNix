{ pkgs, ... }: 

{

  home.packages = (with pkgs; [    # User Apps

    audacity
    # blender # temporarily disabled
    darktable
    dconf2nix
    discord
    eyedropper
    ferdium
    gdm-settings
    gnome-boxes
    gnome-solanum
    gradience
    hieroglyphic
    libreoffice
    osu-lazer
    steam
    texliveFull
    tetrio-desktop
    vesktop
    vial
    wordbook

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    # arcmenu                                     # Installed locally
    # auto-move-windows
    blur-my-shell
    clipboard-indicator
    dash-to-dock
    disable-unredirect-fullscreen-windows         # Not needed for PaperWM
    hide-top-bar                                  # Incompatible with PaperWM
    launch-new-instance
    # paperwm
    quick-settings-audio-panel
    # rounded-window-corners-reborn               # Incompatible with PaperWM
    # unite
    user-themes
    windownavigator
    window-title-is-back                          # Not needed when using unite
  ]);
  
  services = {

    blanket.enable = true;
  };

  programs = {

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        james-yu.latex-workshop
        leonardssh.vscord
        piousdeer.adwaita-theme
        vscjava.vscode-java-pack
      ];
      userSettings = {
        "window.menuBarVisibility" = "toggle";
        "files.autoSave" = "onFocusChange";
        "workbench.colorTheme" = "Adwaita Light & default syntax highlighting & colorful status bar";
        "workbench.preferredDarkColorTheme" = "Adwaita Dark & default syntax highlighting & colorful status bar";
        "workbench.preferredLightColorTheme" = "Adwaita Light & default syntax highlighting & colorful status bar";
        "window.autoDetectColorScheme" = true;
      };
    };
  };
}
