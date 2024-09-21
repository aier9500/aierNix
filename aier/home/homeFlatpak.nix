{ config, ... }: 

{
  services.flatpak.update.auto = {
  enable = true;
  onCalendar = "weekly"; # Default value
  };

  services.flatpak.overrides = {
    global = {
      Context.sockets = ["wayland" "!x11"];
      Context.filesystems = ["home"];
    };
  };

}