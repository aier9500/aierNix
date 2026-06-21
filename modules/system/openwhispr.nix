# modules/system/openwhispr.nix — OpenWhispr voice dictation + Wayland auto-paste
#
# Thin wrapper over OpenWhispr's upstream NixOS module (flake input `openwhispr`),
# which installs the app and sets up the Wayland auto-paste plumbing: the ydotoold
# daemon, the uinput kernel module, and the ydotool/uinput groups. We add the `input`
# group too (the paste path needs it; the upstream module doesn't grant it). All three
# groups need a re-login to take effect.
#
# Browser sign-in (openwhispr:// links): the Electron app checks for a desktop entry
# matching its internal name "open-whispr" before allowing social login. We register
# open-whispr.desktop as the openwhispr:// handler and make it the default for that
# scheme. It's hidden (NoDisplay) — the visible launcher is upstream's openwhispr.desktop.
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
    noDisplay = true; # handler only; upstream's desktop entry is the visible launcher
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

    # input group for the paste path (adds to the module's ydotool+uinput groups).
    users.users.${config.myConfig.user}.extraGroups = [ "input" ];

    # Register the handler and make it the openwhispr:// default.
    environment.systemPackages = [ protocolHandler ];
    xdg.mime.defaultApplications."x-scheme-handler/openwhispr" = "open-whispr.desktop";
  };
}
