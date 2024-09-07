# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "" = {
      activate-window-menu = [];
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
      move-to-workspace-1 = [];
      move-to-workspace-down = [];
      move-to-workspace-last = [];
      move-to-workspace-left = [ "<Shift><Control><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Control><Super>Right" ];
      move-to-workspace-up = [];
      panel-run-dialog = [ "<Super>r" ];
      show-desktop = [ "<Super>d" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-input-source = [ "<Super>space" ];
      switch-input-source-backward = [ "<Shift><Super>space" ];
      switch-to-workspace-1 = [];
      switch-to-workspace-down = [];
      switch-to-workspace-last = [];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      switch-to-workspace-up = [];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-maximized = [];
      toggle-on-all-workspaces = [ "<Super><Shift>u" ];
      unmaximize = [ "<Super>Down" ];
    };

  };
}
