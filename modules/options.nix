# modules/options.nix — cross-cutting myConfig.* values
#
# Declares shared values consumed by both system and home modules.
# Does NOT declare feature toggles — those live in each feature module.
{ lib, ... }:

{
  options.myConfig = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user account name.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Machine hostname.";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      description = "Primary locale (e.g. en_GB.UTF-8).";
    };

    themeName = lib.mkOption {
      type = lib.types.str;
      default = "vanilla";
      description = ''
        Active Stylix theme name. Must match a key in the themes attrset
        defined in modules/home/theming/stylix.nix.
        Current options: "vanilla".
        Future options: "everforest", "catppuccin", etc.
      '';
    };
  };
}
