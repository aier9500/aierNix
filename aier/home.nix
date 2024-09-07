{ config, pkgs, inputs, ... }:

{

  imports = [
    # ./home/dconf.nix
    ./home/dconf.nix
    ./home/gtk.nix
    ./home/homeApps.nix
    ./home/homeConfigs.nix
  ];

}
