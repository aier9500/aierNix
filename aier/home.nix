{ config, pkgs, inputs, ... }:

{

  imports = [
    ./home/homeApps.nix
    ./home/homeConfigs.nix
    ./home/homeDconf.nix
  ];

}
