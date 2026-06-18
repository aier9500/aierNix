{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./HomeDconf/gnomeDesktopInterface.nix
  ];
}