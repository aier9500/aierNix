# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/blur-my-shell" = {
      hacks-level = 1; # Default performance
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 1.0;
      sigma = 30;
      style-dialogs = 0; 
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      blur = false; 
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      pipeline = "pipeline_default";
      style-components = 0; 
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false; 
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      blur = false;
    };

  };
}
