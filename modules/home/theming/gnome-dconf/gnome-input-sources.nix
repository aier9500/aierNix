{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    # Letter layout: Colemak-DH via xkb. keyd only remaps modifiers, NOT letters.
    # ('ibus','rime'): Rime engine — system half mySystem.ibus, schemas myHome.ibusRime.
    # Switch sources: Super+Space. Switch Rime schema: F4 / Ctrl+`.
    # Warning: declaring `sources` here overrides any GUI-added/reordered sources on
    # the next `nh home switch`.
    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "us+colemak_dh"
        ])
        (mkTuple [
          "ibus"
          "rime"
        ])
      ];
    };
  };
}
