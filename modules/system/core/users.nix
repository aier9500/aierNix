# modules/system/core/users.nix — always-on user account definition
_:

{
  users.users.aier = {
    isNormalUser = true;
    description = "Eugenio J. Wu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "uinput" # Solaar uinput access for KeyPress rules (Wayland)
    ];
  };
}
