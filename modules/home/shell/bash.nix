# modules/home/shell/bash.nix — PS1, fastfetch on login, yazi cd-on-exit wrapper, and aliases.
{ config, lib, ... }:
let
  cfg = config.myHome.shell.bash;
in
{
  options.myHome.shell.bash.enable = lib.mkEnableOption "bash shell configuration";

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        fastfetch

        PS1='------------------\n\[$(tput setaf 26)\][\[$(tput setaf 32)\]\u \[$(tput setaf 38)\]@ \[$(tput setaf 44)\]\h\[$(tput setaf 26)\]] \[$(tput setaf 75)\]\w\[$(tput sgr0)\]\n > '

        # yazi cd-on-exit wrapper
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d $'\0' cwd < "$tmp"
          [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
          command rm -f -- "$tmp"
        }
      '';
      shellAliases = {
        cls = "clear";
        cmd = "compgen -c | fzf";
        zh = "history | fzf";
        homesw = "nh home switch";
        sysw = "nh os switch";
        nixse = "nix search nixpkgs";
        lsd = "eza -TD";
        lsd1 = "eza -TD --level 1";
        lsd2 = "eza -TD --level 2";
        lsd3 = "eza -TD --level 3";
        lst = "eza -T";
        lst1 = "eza -T --level 1";
        lst2 = "eza -T --level 2";
        lst3 = "eza -T --level 3";
        lsda = "eza -TDa";
        lsda1 = "eza -TDa --level 1";
        lsda2 = "eza -TDa --level 2";
        lsda3 = "eza -TDa --level 3";
        lsta = "eza -Ta";
        lsta1 = "eza -Ta --level 1";
        lsta2 = "eza -Ta --level 2";
        lsta3 = "eza -Ta --level 3";
      };
    };
  };
}
