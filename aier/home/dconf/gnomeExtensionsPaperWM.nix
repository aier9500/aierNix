# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/paperwm" = {
      gesture-horizontal-fingers = 4;
      gesture-workspace-fingers = 0;

      horizontal-margin = 8;
      open-window-position = 0;
      selection-border-radius-bottom = 12;
      selection-border-size = 3;
      use-default-background = true;
      vertical-margin = 8;
      vertical-margin-bottom = 8;
      window-gap = 8;
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
      move-down = [ "" ];
      move-down-workspace = [ "" ];
      move-left = [ "" ];
      move-monitor-above = [ "" ];
      move-monitor-below = [ "" ];
      move-monitor-left = [ "" ];
      move-monitor-right = [ "" ];
      move-previous-workspace = [ "" ];
      move-previous-workspace-backward = [ "" ];
      move-right = [ "" ];
      move-space-monitor-above = [ "" ];
      move-space-monitor-below = [ "" ];
      move-space-monitor-left = [ "" ];
      move-space-monitor-right = [ "" ];
      move-up = [ "" ];
      move-up-workspace = [ "" ];
      new-window = [ "" ];
      paper-toggle-fullscreen = [ "" ];
      previous-workspace = [ "" ];
      previous-workspace-backward = [ "" ];
      resize-h-dec = [ "" ];
      resize-h-inc = [ "" ];
      resize-w-dec = [ "" ];
      resize-w-inc = [ "" ];
      slurp-in = [ "" ];
      swap-monitor-above = [ "" ];
      swap-monitor-below = [ "" ];
      swap-monitor-left = [ "" ];
      swap-monitor-right = [ "" ];
      switch-down = [ "" ];
      switch-down-workspace = [ "" ];
      switch-first = [ "" ];
      switch-focus-mode = [ "" ];
      switch-last = [ "" ];
      switch-left = [ "" ];
      switch-monitor-above = [ "" ];
      switch-monitor-below = [ "" ];
      switch-monitor-left = [ "" ];
      switch-monitor-right = [ "" ];
      switch-next = [ "" ];
      switch-open-window-position = [ "" ];
      switch-previous = [ "" ];
      switch-right = [ "" ];
      switch-up = [ "" ];
      switch-up-workspace = [ "" ];
      take-window = [ "" ];
      toggle-maximize-width = [ "" ];
      toggle-scratch = [ "" ];
      toggle-scratch-layer = [ "" ];
      toggle-scratch-window = [ "" ];
      toggle-top-and-position-bar = [ "" ];
    };

  };
}
