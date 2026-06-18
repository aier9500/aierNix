{ config, pkgs, ... }: 

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      leonardssh.vscord
      piousdeer.adwaita-theme
      vscjava.vscode-java-pack
    ];
    userSettings = {
      "editor.minimap.enabled" = false ;
      "files.autoSave" = "onFocusChange";
      "window.autoDetectColorScheme" = true;
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Adwaita Light & default syntax highlighting & colorful status bar";
      "workbench.preferredDarkColorTheme" = "Adwaita Dark & default syntax highlighting & colorful status bar";
      "workbench.preferredLightColorTheme" = "Adwaita Light & default syntax highlighting & colorful status bar";
    };
  };

}