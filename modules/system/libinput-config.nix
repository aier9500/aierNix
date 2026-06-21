# modules/system/libinput-config.nix — touchpad scroll-factor on Wayland
#
# GNOME/Wayland has no scroll-speed setting. libinput-config is a small wrapper that
# loads ahead of libinput (via a system-wide preload file) and reads /etc/libinput.conf.
# Both files are declared here, so the wrapper stays in the system closure (GC-safe) and
# reverting is just a generation rollback.
#
# NIXOS GOTCHA: other distros use /etc/ld.so.preload, but nixpkgs patches glibc's loader
# to read /etc/ld-nix.so.preload instead. Target the wrong name and the wrapper never
# loads (silently). So we MUST write ld-nix.so.preload.
#
# WARNING: the preload affects every newly-started process. The wrapper is inert unless
# a process uses libinput (only the compositor does), but a broken preload could stop the
# login session from starting — recover by booting the previous generation.
#
# Only scroll-factor is set, so GNOME keeps owning tap-to-click, natural-scroll, etc.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.libinputConfig;
  libinput-config = pkgs.callPackage ../../pkgs/libinput-config { };
in
{
  options.mySystem.libinputConfig = {
    enable = lib.mkEnableOption "libinput-config (touchpad scroll-factor on Wayland)";

    scrollFactor = lib.mkOption {
      type = lib.types.str;
      default = "0.3";
      example = "0.2";
      description = ''
        Touchpad scroll-speed multiplier written to /etc/libinput.conf. 1.0 is the
        libinput default; lower is slower/less sensitive. 0.3 is a calm default —
        try "0.2" (slower) or "0.5" (faster). Takes effect after a relogin.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Force-load the wrapper ahead of libinput. NixOS reads ld-nix.so.preload, not
    # ld.so.preload (see header). The store path keeps it in the system closure.
    environment.etc."ld-nix.so.preload".text = "${libinput-config}/lib/libinput-config.so\n";

    # Read by libinput-config at device init.
    environment.etc."libinput.conf".text = ''
      scroll-factor=${cfg.scrollFactor}
    '';
  };
}
