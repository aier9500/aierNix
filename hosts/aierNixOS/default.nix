# hosts/aierNixOS/default.nix — P1 system configuration
#
# Imports all system modules directly; no legacy passthrough.
# Sets myConfig.* values and enables feature toggles for this machine.
_:

{
  imports = [
    ./hardware-configuration.nix

    # Core always-on modules
    ../../modules/system/core/networking.nix
    ../../modules/system/core/locale.nix
    ../../modules/system/core/users.nix
    ../../modules/system/core/boot.nix
    ../../modules/system/nix.nix
    ../../modules/system/system-pkgs.nix

    # Feature-toggle modules
    ../../modules/system/desktop/gnome.nix
    ../../modules/system/desktop/pipewire.nix
    ../../modules/system/desktop/fonts.nix
    ../../modules/system/keyd.nix
    ../../modules/system/snapper.nix
    ../../modules/system/virtualisation.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/power.nix
    ../../modules/system/printing.nix
    ../../modules/system/solaar.nix
    ../../modules/system/ibus.nix
  ];

  # Cross-cutting values (consumed by modules via myConfig.*)
  myConfig = {
    user = "aier";
    hostname = "aierNixOS";
    timezone = "America/Caracas";
    locale = "en_US.UTF-8";
    themeName = "";
  };

  # Feature toggles — enable everything currently active in the system
  mySystem = {
    desktop.gnome.enable = true;
    desktop.pipewire.enable = true;
    keyd.enable = true;
    snapper.enable = true;
    virtualisation.enable = true;
    flatpak.enable = true;
    power.enable = true;
    printing.enable = true;
    solaar.enable = true;
    ibus.enable = true; # ibus + Rime engine (luna_pinyin + jyut6ping3); schemas in myHome.ibusRime
  };
}
