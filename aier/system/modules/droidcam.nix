{ config, ... }: 

{
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = [“v4l2loopback”];
  programs.adb.enable = true; # enable android proper data tethering
  environment.packages = with pkgs; [ droidcam obs-studio-plugins.droidcam-obs ];
  ]
}