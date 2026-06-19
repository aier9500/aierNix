{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell/extensions/nightthemeswitcher/commands" = {
      enabled = true;
      sunrise = "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-light'\"";
      sunset = "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\"";
    };
  };
}
