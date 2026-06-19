# modules/home/cli/yazi.nix — yazi file manager with custom config
# Note: a cosmetic warning exists about programs.yazi.shellWrapperName default
# changing in 26.05 — setting explicitly to "y" to adopt new default and silence it.
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

      # keymap.toml — custom g-prefix navigation.
      # prepend_keymap sits ahead of defaults.
      # Kept defaults: g h (home), g c (~/.config), g d (Downloads), g t (/tmp), g g (top)
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
        ];
      };

      theme = {
        # theme.toml
        which = {
          cols = 3;
          mask = {
            bg = "#2e383c";
          };
          cand = {
            fg = "#dbbc7f";
            bold = true;
          };
          rest = {
            fg = "#a6b0a0";
          };
          desc = {
            fg = "#d3c6aa";
          };
          separator = "  ";
          separator_style = {
            fg = "#7a8478";
          };
        };
      };
    };
  };
}
