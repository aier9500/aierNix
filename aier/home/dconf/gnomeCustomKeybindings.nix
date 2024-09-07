# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "custom0" = {
      binding = "<Control><Super>Delete";
      command = "gnome-session-quit";
      name = "gnome-session-quit";
    };

    "custom1" = {
      binding = "<Shift><Super>r";
      command = "gnome-terminal";
      name = "gnome-terminal";
    };

    "custom2" = {
      binding = "<Super>t";
      command = "gnome-text-editor";
      name = "gnome-text-editor";
    };

    "custom3" = {
      binding = "<Shift><Control>Escape";
      command = "resources";
      name = "resources";
    };

    "custom4" = {
      binding = "<Shift><Control><Alt>r";
      command = "obs";
      name = "obs";
    };

  };
}
