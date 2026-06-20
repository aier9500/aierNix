# pkgs/libinput-config/default.nix — warningnonpotablewater's libinput-config (lz42 mirror)
#
# A libinput wrapper that lets you set input options — notably the touchpad
# scroll-factor — that GNOME/mutter on Wayland does not expose. It works by
# symbol interposition: the .so is force-loaded ahead of libinput (system-wide
# ld.so.preload, wired in modules/system/libinput-config.nix) and reads
# /etc/libinput.conf at device init.
#
# Upstream's `ninja install` appends to /etc/ld.so.preload via scripts/preload.sh.
# That is the module's job here (declarative + GC-safe), so we skip the install
# step and copy only the built .so into $out/lib.
{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libinput,
  udev,
}:

stdenv.mkDerivation {
  pname = "libinput-config";
  version = "0-unstable-986afe8";

  src = fetchFromGitHub {
    owner = "lz42";
    repo = "libinput-config";
    rev = "986afe8436cffe1f927cbcdcc40475f56e273345";
    hash = "sha256-N6UZPkP334ubjoEm31gLe/0filClVxo1zIWp23Ed2Ow=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # libinput + libudev are pulled in for HEADERS ONLY: meson uses
  # partial_dependency(includes: true) and links with
  # --unresolved-symbols=ignore-all, so the .so has no hard libinput dependency
  # and resolves the real symbols at runtime via RTLD_NEXT against whatever
  # libinput the host process (e.g. mutter) already loaded.
  buildInputs = [
    libinput
    udev
  ];

  # Skip `ninja install`: its meson install script (scripts/preload.sh) edits
  # /etc/ld.so.preload, which fails in the build sandbox and is handled
  # declaratively by modules/system/libinput-config.nix instead.
  installPhase = ''
    runHook preInstall
    install -Dm755 \
      "$(find . -name 'libinput-config.so' -print -quit)" \
      "$out/lib/libinput-config.so"
    runHook postInstall
  '';

  meta = {
    description = "Configure libinput options (e.g. touchpad scroll-factor) a compositor does not expose";
    homepage = "https://gitlab.com/warningnonpotablewater/libinput-config";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
  };
}
