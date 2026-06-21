# modules/system/openwhispr.nix — OpenWhispr voice dictation + Wayland auto-paste
#
# Single source of truth for OpenWhispr on this host (system-side). Thin wrapper over
# OpenWhispr's upstream NixOS module (flake input `openwhispr`, nixosModules.default),
# which is purpose-built to solve the Nix Wayland auto-paste pain point (upstream issue
# #728): it installs the app (an FHS-wrapped AppImage bundling
# ydotool/wtype/xdotool/wl-clipboard/…) and configures the system side auto-paste needs:
#   - programs.ydotool.enable  → ydotoold daemon + `ydotool` group + socket
#   - hardware.uinput.enable   → uinput kernel module + udev rule (already on via
#                                mySystem.solaar; setting it again is idempotent)
#   - adds `users` to the `ydotool` + `uinput` groups
#
# OpenWhispr's native `linux-fast-paste --uinput` backend writes /dev/uinput directly
# (uinput group), so no `systemctl --user` ydotoold service is needed. We additionally
# add the `input` group — OpenWhispr's diagnostic + paste path expect it, and the
# upstream module does not grant it. (All three groups require a re-login to take effect.)
#
# Browser sign-in (openwhispr:// protocol): OpenWhispr (Electron) gates social login on
# isDefaultProtocolClient, which checks `${app.name}.desktop`. The app name is
# "open-whispr" (hyphenated), and Electron OVERWRITES $CHROME_DESKTOP to that at startup
# — so launch-time env tricks don't stick. The fix is to register a desktop entry with
# that exact id ("open-whispr.desktop") as the openwhispr:// handler and make it the
# scheme default. It is NoDisplay (the visible launcher is the upstream openwhispr.desktop).
#
# Exposes a `mySystem.openwhispr.enable` toggle for consistency with the other system
# modules; the listed user comes from myConfig.user.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.mySystem.openwhispr;

  # openwhispr:// handler, named to match Electron's app.name ("open-whispr").
  protocolHandler = pkgs.makeDesktopItem {
    name = "open-whispr"; # → open-whispr.desktop (the id Electron checks)
    desktopName = "OpenWhispr (protocol handler)";
    exec = "openwhispr --no-sandbox %U";
    noDisplay = true; # handler only; upstream openwhispr.desktop is the visible launcher
    mimeTypes = [ "x-scheme-handler/openwhispr" ];
    startupWMClass = "OpenWhispr";
  };
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

    # input group for the diagnostic + paste path (merges with the upstream module's
    # ydotool+uinput additions). Requires re-login.
    users.users.${config.myConfig.user}.extraGroups = [ "input" ];

    # Register the open-whispr.desktop handler and make it the openwhispr:// default.
    environment.systemPackages = [ protocolHandler ];
    xdg.mime.defaultApplications."x-scheme-handler/openwhispr" = "open-whispr.desktop";
  };
}
