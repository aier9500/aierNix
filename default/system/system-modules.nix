{ config, ... }: 

{
  imports = [
    ./system-modules/system-keyd.nix
    ./system-modules/system-solaar.nix
  ];
}