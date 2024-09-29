{ config, pkgs, inputs, ... }:

{

  imports = [
    # ./home/dconf.nix
    ./home/homeApps.nix
    ./home/homeConfigs.nix
    ./home/homeDconf.nix
    ./home/homeGtk.nix
  ];

}
