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

    # keyd exposes a virtual keyboard that libinput won't classify as
    # internal, which silently breaks libinput's disable-while-typing
    # (DWT) — the touchpad is no longer suppressed while typing. Mark
    # keyd's virtual keyboard as an internal keyboard so libinput pairs
    # it with the touchpad and DWT works again. (NixOS wiki: Keyd.)
    environment.etc."libinput/local-overrides.quirks".text = ''
      [keyd virtual keyboard]
      MatchUdevType=keyboard
      MatchName=keyd virtual keyboard
      AttrKeyboardIntegration=internal
    '';
  };
}
