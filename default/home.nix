{ config, pkgs, inputs, ... }:

{

  imports = [
    ./home/homeApps.nix
    ./home/homeConfigs.nix
    ./home/homeDconf.nix
    ./home/homeModules.nix
  ];

}
