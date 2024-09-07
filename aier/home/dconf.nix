{ lib, ... }: 

with lib.hm.gvariant;

{
  
  dconf.settings.enable = true; 
  
  # Gnome Desktop WM
  dconf.settings = {
    "/org/gnome/desktop/wm/keybindings" = {
      always-on-top = [ "<Super>u" ];
      begin-move = [];
      begin-resize = [];
      close = [ "<Super>q" ];
      cycle-group = [];
      cycle-group-backward = [];
      cycle-panels = [];
      cycle-panels-backward = [];
      cycle-windows = [];
      cycle-windows-backward = [];
      maximize = [ "<Super>Up" ];
      move-to-workspace-1 = [];
      move-to-workspace-last = [];
      move-to-workspace-left = [ "<Shift><Control><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Control><Super>Right" ];
      panel-run-dialog = [ "<Super>r" ];
      show-desktop = [ "<Super>d" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-input-source = [ "<Super>space" ];
      switch-input-source-backward = [ "<Shift><Super>space" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-maximized = [];
      toggle-on-all-workspaces = [ "<Super><Shift>u" ];
      unmaximize = [ "<Super>Down" ];
    };
  };

  # Gnome Mutter
  dconf.settings = {
    "/org/gnome/mutter/keybindings/" = {
      toggle-tiled-left = [ "<Super>Left" ];
      toggle-tiled-right = [ "<Super>Right" ];
    };
  };

  #Gnome Shell
  dconf.settings = {
    "/org/gnome/shell/keybindings/" = {
      open-new-window-application-1 = [ "<Super><Shift>1" ];
      open-new-window-application-2 = [ "<Super><Shift>2" ];
      open-new-window-application-3 = [ "<Super><Shift>3" ];
      open-new-window-application-4 = [ "<Super><Shift>4" ];
      open-new-window-application-5 = [ "<Super><Shift>5" ];
      open-new-window-application-6 = [ "<Super><Shift>6" ];
      open-new-window-application-7 = [ "<Super><Shift>7" ];
      open-new-window-application-8 = [ "<Super><Shift>8" ];
      open-new-window-application-9 = [ "<Super><Shift>9" ];
      screenshot = [];
      screenshot-window = [];
      shift-overview-down = [ "<Super><Control>Down" ];
      shift-overview-up = [ "<Super><Control>Up" ];
      show-screen-recording-ui = [];
      toggle-message-tray = [ "<Super>m" ];
    };
  };

}