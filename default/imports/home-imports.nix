{ config, ... }: 

{
  imports = [
    ../home/home-apps.nix
    ../home/home-configs.nix
    ../home/home-dconf.nix
    ../home/home-files.nix
    ../home/home-modules.nix
  ];
}