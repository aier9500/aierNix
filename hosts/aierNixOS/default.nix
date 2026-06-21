# hosts/aierNixOS/default.nix — system configuration for this machine.
# Imports the system modules, sets myConfig.* values, and flips feature toggles on.
_:

{
  imports = [
    ./hardware-configuration.nix

    # Core always-on modules
    ../../modules/system/core/networking.nix
    ../../modules/system/core/locale.nix
    ./locale.nix # host-specific LC_TIME/LC_MONETARY deviations from the en_GB baseline
    ../../modules/system/core/users.nix
    ../../modules/system/core/boot.nix
    ../../modules/system/nix.nix
    ../../modules/system/system-pkgs.nix

    # Feature-toggle modules
    ../../modules/system/desktop/gnome.nix
    ../../modules/system/desktop/pipewire.nix
    ../../modules/system/keyd.nix
    ../../modules/system/libinput-config.nix
    ../../modules/system/snapper.nix
    ../../modules/system/virtualisation.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/power.nix
    ../../modules/system/printing.nix
    ../../modules/system/solaar.nix
    ../../modules/system/ibus.nix
    ../../modules/system/openwhispr.nix
  ];

  # Cross-cutting values (consumed by modules via myConfig.*)
  myConfig = {
    user = "aier";
    hostname = "aierNixOS";
    locale = "en_GB.UTF-8";
    themeName = "";
  };

  # Feature toggles — enable everything currently active in the system
  mySystem = {
    desktop.gnome.enable = true;
    desktop.pipewire.enable = true;
    keyd.enable = true;
    libinputConfig.enable = true; # GNOME/Wayland scroll runs too fast otherwise
    libinputConfig.scrollFactor = "0.2"; # slower than the module's 0.3 default
    snapper.enable = true;
    virtualisation.enable = true;
    flatpak.enable = true;
    power.enable = true;
    printing.enable = true;
    solaar.enable = true;
    ibus.enable = true; # ibus + Rime engine; schemas in myHome.ibusRime
    openwhispr.enable = true; # voice dictation; auto-paste UNTESTED (see README)
  };
}
