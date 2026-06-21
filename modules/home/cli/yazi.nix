# modules/home/cli/yazi.nix
# shellWrapperName set to "y" explicitly to silence a 26.05 deprecation warning.
{ config, lib, ... }:
let
  cfg = config.myHome.cli.yazi;
in
{
  options.myHome.cli.yazi.enable = lib.mkEnableOption "yazi file manager";

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      shellWrapperName = "y";

      settings = {
        # yazi.toml
        mgr = {
          ratio = [
            1
            2
            5
          ];
        };
        preview = {
          max_width = 1200;
          max_height = 1600;
        };
      };

      # keymap.toml — custom g-prefix navigation (prepend_keymap sits ahead of defaults)
      keymap = {
        mgr.prepend_keymap = [
          {
            on = [
              "g"
              "e"
            ];
            run = "cd ~/Desktop";
            desc = "Go to Desktop";
          }
          {
            on = [
              "g"
              "D"
            ];
            run = "cd ~/Documents";
            desc = "Go to Documents";
          }
          {
            on = [
              "g"
              "p"
            ];
            run = "cd ~/Pictures";
            desc = "Go to Pictures";
          }
          {
            on = [
              "g"
              "v"
            ];
            run = "cd ~/Videos";
            desc = "Go to Videos";
          }
          {
            on = [
              "g"
              "m"
            ];
            run = "cd ~/Music";
            desc = "Go to Music";
          }
          {
            on = [
              "g"
              "P"
            ];
            run = "cd ~/Public";
            desc = "Go to Public";
          }
          {
            on = [
              "g"
              "C"
            ];
            run = "cd ~/.config/yazi";
            desc = "Go to yazi config";
          }
          {
            on = [
              "g"
              "i"
            ];
            run = "cd ~/Installations";
            desc = "Go to Installations";
          }
          {
            on = [
              "g"
              "w"
            ];
            run = "cd ~/Projects";
            desc = "Go to Projects";
          }
          {
            on = [
              "g"
              "."
            ];
            run = "cd ~/.dotfiles";
            desc = "Go to .dotfiles";
          }
        ];
      };
    };
  };
}
