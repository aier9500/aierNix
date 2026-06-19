{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ "<Super>M" ];
    };

    # copyous extension settings removed — manage in-extension to avoid
    # version-mismatch crashes on rebuild.
    # "org/gnome/shell/extensions/copyous" = {
    #   open-clipboard-dialog-shortcut = [ "<Super>V" ];
    #   clipboard-history = "keep-all";
    #   clipboard-position-vertical = "bottom";
    # };
  };
}
