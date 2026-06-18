{ ... }:

{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "backspace";
          # Chord keys contain '+' and must be quoted as Nix attrset keys;
          # lib.generators.toINI renders them verbatim, which is valid keyd syntax.
          "leftshift+rightshift" = "capslock";
          "leftshift+leftmeta+f23" = "layer(control)";
        };
      };
    };
  };
}
