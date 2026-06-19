# modules/system/keyd.nix — keyd Colemak DH keyboard remapping
{ config, lib, ... }:
let
  cfg = config.mySystem.keyd;
in
{
  options.mySystem.keyd.enable = lib.mkEnableOption "keyd Colemak DH remap";

  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "backspace";
            "leftshift+rightshift" = "capslock";
            "leftshift+leftmeta+f23" = "layer(control)";
          };
        };
      };
    };
  };
}
