{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    #./dconf/gnomeKeybindings
  ];
}