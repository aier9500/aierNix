# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/paperwm" = {
      gesture-horizontal-fingers = 4;
      gesture-workspace-fingers = 0;
      open-window-position = 0;
      show-workspace-indicator = false; 

      selection-border-radius-bottom = 12;
      selection-border-radius-top = 12;
      selection-border-size = 4;
      horizontal-margin = 6;
      vertical-margin = 6;
      vertical-margin-bottom = 6;
      window-gap = 6;
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      barf-out = [ "" ];
      barf-out-active = [ "" ];
      center-horizontally = [ "" ];
      close-window = [ "" ];
      cycle-height = [ "" ];
      cycle-height-backwards = [ "" ];
      cycle-width = [ "" ];
      cycle-width-backwards = [ "" ];
      live-alt-tab = [ "" ];
      live-alt-tab-backward = [ "" ];
      live-alt-tab-scratch = [ "" ];
      live-alt-tab-scratch-backward = [ "" ];
      move-down = [ "<Super><Alt>down" ];
      move-down-workspace = [ "" ];
      move-left = [ "<Super><Alt>left" "<Super><Alt>comma" ];
      move-monitor-above = [ "" ];
      move-monitor-below = [ "" ];
      move-monitor-left = [ "" ];
      move-monitor-right = [ "" ];
      move-previous-workspace = [ "" ];
      move-previous-workspace-backward = [ "" ];
      move-right = [ "<Super><Alt>right" "<Super><Alt>period" ];
      move-space-monitor-above = [ "" ];
      move-space-monitor-below = [ "" ];
      move-space-monitor-left = [ "" ];
      move-space-monitor-right = [ "" ];
      move-up = [ "<Super><Alt>up" ];
      move-up-workspace = [ "" ];
      new-window = [ "" ];
      paper-toggle-fullscreen = [ "" ];
      previous-workspace = [ "" ];
      previous-workspace-backward = [ "" ];
      resize-h-dec = [ "<Control><Super>bracketleft" ];
      resize-h-inc = [ "<Control><Super>bracketright" ];
      resize-w-dec = [ "<Super>bracketleft" ];
      resize-w-inc = [ "<Super>bracketright" ];
      slurp-in = [ "" ];
      swap-monitor-above = [ "" ];
      swap-monitor-below = [ "" ];
      swap-monitor-left = [ "" ];
      swap-monitor-right = [ "" ];
      switch-down = [ "<Super>Down" ];
      switch-down-workspace = [ "" ];
      switch-first = [ "" ];
      switch-focus-mode = [ "<Shift><Super>c" ];
      switch-last = [ "" ];
      switch-left = [ "<Super>Left" "<Super>comma" ];
      switch-monitor-above = [ "" ];
      switch-monitor-below = [ "" ];
      switch-monitor-left = [ "" ];
      switch-monitor-right = [ "" ];
      switch-next = [ "" ];
      switch-open-window-position = [ "" ];
      switch-previous = [ "" ];
      switch-right = [ "<Super>Right" "<Super>period" ];
      switch-up = [ "<Super>Up" ];
      switch-up-workspace = [ "" ];
      take-window = [ "" ];
      toggle-maximize-width = [ "" ];
      toggle-scratch = [ "" ];
      toggle-scratch-layer = [ "" ];
      toggle-scratch-window = [ "" ];
      toggle-top-and-position-bar = [ "<Super>q" ];
    };

  };
}
