# modules/home/cli/fastfetch.nix
{ config, lib, ... }:
let
  cfg = config.myHome.cli.fastfetch;
in
{
  options.myHome.cli.fastfetch.enable = lib.mkEnableOption "fastfetch system info display";

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        # Custom ASCII logo
        logo = {
          type = "data";
          source = "[37m████████╗██╗  ██╗███████╗ ██████╗ ██████╗ [38;2;212;165;55m██╗   ██╗   [0m\n[37m╚══██╔══╝██║  ██║██╔════╝██╔═══██╗██╔══██╗[38;2;212;165;55m╚██╗ ██╔╝   [0m\n[37m   ██║   ███████║█████╗  ██║   ██║██████╔╝[38;2;212;165;55m ╚████╔╝    [0m\n[37m   ██║   ██╔══██║██╔══╝  ██║   ██║██╔══██╗[38;2;212;165;55m  ╚██╔╝     [0m\n[37m   ██║   ██║  ██║███████╗╚██████╔╝██║  ██║[38;2;212;165;55m   ██║   ██╗[0m\n[37m   ╚═╝   ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝[38;2;212;165;55m   ╚═╝   ╚═╝[0m\n\n                   [30m● [31m● [32m● [33m● [34m● [35m● [36m● [37m●[0m";
          padding = {
            top = 13;
            left = 2;
            right = 1;
          };
        };

        display = {
          separator = " ";
        };

        modules = [
          "break"
          {
            type = "custom";
            format = "[90m──────────────────────── [38;2;212;165;55mHardware[90m ────────────────────────[0m";
          }
          {
            type = "host";
            key = "  PC      ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "cpu";
            key = "  CPU     ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "gpu";
            key = "  GPU     ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "display";
            key = "  Display ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "memory";
            key = "  Memory  ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "swap";
            key = "  Swap    ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "disk";
            key = "  Disk    ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "battery";
            key = "  Battery ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "localip";
            key = "  Local IP";
            keyColor = "38;2;212;165;55";
          }
          "break"
          {
            type = "custom";
            format = "[90m──────────────────────── [38;2;212;165;55mSoftware[90m ────────────────────────[0m";
          }
          {
            type = "os";
            key = "  OS      ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "kernel";
            key = "  Kernel  ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "packages";
            key = "  Packages";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "shell";
            key = "  Shell   ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "de";
            key = "  DE      ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "wm";
            key = "  WM      ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "wmtheme";
            key = "  WM Theme";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "theme";
            key = "  Theme   ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "icons";
            key = "  Icons   ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "font";
            key = "  Font    ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "cursor";
            key = "  Cursor  ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "terminal";
            key = "  Term    ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "locale";
            key = "  Locale  ";
            keyColor = "38;2;212;165;55";
          }
          "break"
          {
            type = "custom";
            format = "[90m───────────────────────── [38;2;212;165;55mUptime[90m ─────────────────────────[0m";
          }
          {
            type = "command";
            key = "  OS Age  ";
            keyColor = "38;2;212;165;55";
            text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          }
          {
            type = "uptime";
            key = "  Uptime  ";
            keyColor = "38;2;212;165;55";
          }
          {
            type = "datetime";
            key = "  DateTime";
            keyColor = "38;2;212;165;55";
          }
        ];
      };
    };
  };
}
