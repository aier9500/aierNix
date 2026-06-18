{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us+colemak_dh" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };
  };
}
