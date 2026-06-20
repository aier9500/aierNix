# modules/system/openwhispr.nix — OpenWhispr voice dictation + Wayland auto-paste
#
# Thin wrapper over OpenWhispr's upstream NixOS module (flake input `openwhispr`,
# nixosModules.default). That module is purpose-built to solve the Nix Wayland
# auto-paste pain point (upstream issue #728): it installs the app (an FHS-wrapped
# AppImage bundling ydotool/wtype/xdotool/wl-clipboard/…) and configures the system
# side auto-paste needs:
#   - programs.ydotool.enable  → ydotoold daemon + `ydotool` group + socket
#   - hardware.uinput.enable   → uinput kernel module + udev rule (already on via
#                                mySystem.solaar; setting it again is idempotent)
#   - adds `users` to the `ydotool` + `uinput` groups
#
# The `uinput` group is what makes OpenWhispr's native `linux-fast-paste --uinput`
# backend work — it writes /dev/uinput directly, so no `systemctl --user` ydotoold
# service is required (the app's own daemon check is bypassed by the native path).
#
# Exposes a `mySystem.openwhispr.enable` toggle for consistency with the other
# system modules; the listed user comes from myConfig.user.
{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.mySystem.openwhispr;
in
{
  imports = [ inputs.openwhispr.nixosModules.default ];

  options.mySystem.openwhispr.enable =
    lib.mkEnableOption "OpenWhispr voice dictation with Wayland auto-paste";

  config = lib.mkIf cfg.enable {
    programs.openwhispr = {
      enable = true;
      users = [ config.myConfig.user ];
    };
  };
}
