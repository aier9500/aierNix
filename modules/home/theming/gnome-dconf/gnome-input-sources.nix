{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    # Default layout is Colemak-DH via xkb (us+colemak_dh) — this is the actual
    # letter layout. keyd only remaps modifiers (capslock→backspace, shift+shift→
    # capslock), NOT letters, so the Colemak letters come from here.
    # ('ibus','rime') adds the Rime engine — system half mySystem.ibus, schema list
    # myHome.ibusRime. Switch sources with Super+Space; switch Rime schema with F4 /
    # Ctrl+`. NOTE: declaring `sources` here overrides GUI-added/reordered input
    # sources on the next `nh home switch`.
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
