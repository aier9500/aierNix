_:

{
  dconf.settings = {
    # Window-manager keybindings — workspace/window navigation (Windows-like)
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

    # Settings-daemon media keys — built-in app launchers (Windows-like)
    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [
        "<Super>I"
        "<Super>semicolon"
      ]; # Settings
      home = [ "<Super>E" ]; # Files / home folder
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    # custom0 — terminal. The Gnome guide uses Ptyxis here; we keep Ghostty,
    # this repo's terminal, on the same <Super>Return binding.
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Super>Return";
    };

    # custom1 — Mission Center (nixpkgs home.packages; migrated off flatpak 2026-06-19)
    # Bare `missioncenter` resolves: home.packages bins land in ~/.nix-profile/bin,
    # which is on the gsd-media-keys PATH that runs custom keybinding commands.
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Launch Mission Center";
      command = "missioncenter";
      binding = "<Control><Shift>Escape";
    };
  };
}
