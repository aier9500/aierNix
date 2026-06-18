{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      # enabled-extensions = [
      #   "appindicatorsupport@rgcjonas.gmail.com"
      #   "blur-my-shell@aunetx"
      #   "just-perfection-desktop@just-perfection"
      #   "copyous@boerdereinar.dev"
      #   "caffeine@patapon.info"
      #   "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
      #   "shotzy@SamkitJain660.github.io"
      #   "nightthemeswitcher@romainvigier.fr"
      #   "kando-integration@kando-menu.github.io"
      # ];
    };

    # "org/gnome/shell/extensions/just-perfection" = {
    #   ripple-box = false;
    #   search = false;
    #   window-preview-caption = false;
    #   workspace-switcher-should-show = true;
    #   workspace-switcher-size = mkUint32 13;
    # };
  };
}
