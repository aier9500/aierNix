# modules/system/core/networking.nix — always-on networking config
_:

{
  networking = {
    hostName = "aierNixOS";
    hostId = "76a9986d";
    networkmanager.enable = true;
  };
}
