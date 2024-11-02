{ config, ... }: 

{
  imports = [
    ../system/systemModules.nix
    ../system/systemApps.nix
    ../system/systemConfigs.nix
  ];
}