{ config, pkgs, inputs, ... }:

{
  imports = [
    ./home/homeApps.nix
    ./home/homeConfigs.nix
    ./home/homeDconf.nix
    ./home/homeFiles.nix
    ./home/homeModules.nix
  ];

  home = {
    username = "aier";
    homeDirectory = "/home/aier";
    stateVersion = "24.05"; # Please read the comment before changing.
  };
  
  nixpkgs.config.allowUnfree = true; 

  programs.home-manager.enable = true; 
}
