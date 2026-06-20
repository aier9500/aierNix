# modules/system/libinput-config.nix — touchpad scroll-factor on Wayland
#
# GNOME/mutter on Wayland exposes no scroll-speed slider. libinput-config wraps
# libinput by being force-loaded ahead of it (a system-wide preload file) and
# reading /etc/libinput.conf. Both files are declared here, so the wrapper .so is
# part of the system closure (GC-safe) and reverting = rolling back a generation.
#
# NIXOS GOTCHA: upstream and every FHS distro use /etc/ld.so.preload, but nixpkgs
# patches glibc's loader to read **/etc/ld-nix.so.preload** instead (verified: the
# string is baked into ld-linux-x86-64.so.2; /etc/ld.so.preload is silently
# ignored). Writing the wrong name = the wrapper never loads and scroll-factor
# does nothing. So we MUST target ld-nix.so.preload.
#
# WARNING: this preload injects the .so into EVERY process on the system. The .so
# is inert unless a process calls libinput (only the compositor does), and it is
# verified to load cleanly — but if it ever failed to load, processes including
# the login session could fail to start. Recovery: pick the previous generation
# from the boot menu. The effect only applies to newly-started processes, so it
# takes hold after a relogin/reboot.
#
# Only scroll-factor is written (it always applies, even without
# override-compositor), so GNOME keeps owning tap-to-click, natural-scroll, etc.
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
    # Force-load the wrapper ahead of libinput for every process. NixOS's loader
    # reads /etc/ld-nix.so.preload (NOT /etc/ld.so.preload — see header). The
    # absolute store path keeps the package in the system closure (GC-safe).
    environment.etc."ld-nix.so.preload".text = "${libinput-config}/lib/libinput-config.so\n";

    # libinput-config reads this at device init.
    environment.etc."libinput.conf".text = ''
      scroll-factor=${cfg.scrollFactor}
    '';
  };
}
