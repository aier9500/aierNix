{ config, ... }: 

{
  imports = [
    ../system/system-modules.nix
    ../system/system-apps.nix
    ../system/system-configs.nix
  ];
}