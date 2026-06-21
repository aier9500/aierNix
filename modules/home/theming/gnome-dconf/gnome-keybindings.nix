_:

{
  dconf.settings = {
    # Window-manager keybindings
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-left = [
        "<Control><Super>Left"
        "<Super>Page_Up"
      ];
      switch-to-workspace-right = [
        "<Control><Super>Right"
        "<Super>Page_Down"
      ];
      move-to-workspace-left = [ "<Super>bracketleft" ];
      move-to-workspace-right = [ "<Super>bracketright" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Alt><Shift>Tab" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Super><Shift>Tab" ];
      panel-run-dialog = [ "<Super>R" ];
      move-to-center = [ "<Super><Shift>Return" ];
      toggle-fullscreen = [ "<Super>F" ];
      close = [
        "<Super>X"
        "<Alt>F4"
      ];
    };

    # Settings-daemon media keys
    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [
        "<Super>I"
        "<Super>semicolon"
      ];
      home = [ "<Super>E" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    # custom0 — terminal (Ghostty on <Super>Return)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Super>Return";
    };

    # custom1 — Mission Center. Bare `missioncenter` resolves because home.packages
    # bins land in ~/.nix-profile/bin, which is on the gsd-media-keys PATH.
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Launch Mission Center";
      command = "missioncenter";
      binding = "<Control><Shift>Escape";
    };
  };
}
