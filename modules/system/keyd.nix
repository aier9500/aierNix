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

    # keyd's virtual keyboard isn't classified as internal by libinput,
    # which silently breaks disable-while-typing (DWT). This quirk marks
    # it internal so libinput re-enables DWT. (NixOS wiki: Keyd.)
    environment.etc."libinput/local-overrides.quirks".text = ''
      [keyd virtual keyboard]
      MatchUdevType=keyboard
      MatchName=keyd virtual keyboard
      AttrKeyboardIntegration=internal
    '';
  };
}
