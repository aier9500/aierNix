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
