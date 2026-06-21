# pkgs/libinput-config/default.nix — libinput-config (lz42 mirror)
#
# A libinput wrapper that exposes input options GNOME/Wayland doesn't — notably the
# touchpad scroll-factor. It loads ahead of libinput (preload, wired in
# modules/system/libinput-config.nix) and reads /etc/libinput.conf.
#
# We skip upstream's `ninja install` (it edits /etc/ld.so.preload — the module does
# that declaratively instead) and copy only the built .so into $out/lib.
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

  # libinput + libudev are here for HEADERS ONLY — the build links with unresolved
  # symbols, so the .so has no hard libinput dependency and binds to whatever libinput
  # the host process (e.g. mutter) already loaded at runtime.
  buildInputs = [
    libinput
    udev
  ];

  # Skip `ninja install` (its preload script edits /etc/ld.so.preload, which fails in
  # the sandbox and is handled by the module); install just the built .so.
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
