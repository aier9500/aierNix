{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./home-dconf/gnome-desktop-interface.nix
  ];
}