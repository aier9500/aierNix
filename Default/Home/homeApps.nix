{ pkgs, ... }: 

{

  home.packages = (with pkgs; [    # User Apps

    audacity
    blender
    darktable
    davinci-resolve
    dconf2nix
    discord
    eyedropper
    ferdium
    gdm-settings
    gnome-boxes
    gnome-solanum
    gradience
    hieroglyphic
    krita
    libreoffice
    lyrebird
    osu-lazer
    steam
    texliveFull
    tetrio-desktop
    vesktop
    vial
    wordbook

  ]) ++ (with pkgs.gnomeExtensions; [    # Gnome Extensions

    appindicator
    arcmenu
    # auto-move-windows
    # blur-my-shell
    clipboard-indicator
    dash-to-dock
    disable-unredirect-fullscreen-windows # Not needed for PaperWM
    easyeffects-preset-selector
    hide-top-bar # Incompatible with PaperWM
    launch-new-instance
    # paperwm
    quick-settings-audio-panel
    # rounded-window-corners-reborn # Incompatible with PaperWM
    # unite
    user-themes-x
    windownavigator
    window-title-is-back
  ]);
  
  services = {

    blanket.enable = true;
    easyeffects.enable = true;
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
