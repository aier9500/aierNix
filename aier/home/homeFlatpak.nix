{ config, ... }: 

{
  services.flatpak.update.auto = {
  enable = true;
  onCalendar = "weekly"; # Default value
  };

  services.flatpak.overrides = {
    global = {
      # Force Wayland by default
      Context.sockets = ["wayland" "!x11" "!fallback-x11"];

      Context.filesystems = ["host"];
    };
  };

}