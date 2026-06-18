{ config, pkgs, ... }:

{
  programs = {
    # Bash
    bash = {
      # bashrc — zoxide init is handled at system level (programs.zoxide.enableBashIntegration = true
      # in system-apps.nix), so no manual eval here to avoid double-init.
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
      # Bash aliases
      shellAliases = {
        cls    = "clear";
        cmd    = "compgen -c | fzf";           # Search through all available commands
        zh     = "history | fzf";              # Search through Bash history
        homesw = "cd ~/MyBash && ./homesw.sh";
        sysw   = "cd ~/MyBash && ./sysw.sh";
        nixse  = "nix search nixpkgs";
        # eza — directory-only tree
        lsd    = "eza -TD";
        lsd1   = "eza -TD --level 1";
        lsd2   = "eza -TD --level 2";
        lsd3   = "eza -TD --level 3";
        # eza — files+dirs tree
        lst    = "eza -T";
        lst1   = "eza -T --level 1";
        lst2   = "eza -T --level 2";
        lst3   = "eza -T --level 3";
        # eza — directory-only tree (show hidden)
        lsda   = "eza -TDa";
        lsda1  = "eza -TDa --level 1";
        lsda2  = "eza -TDa --level 2";
        lsda3  = "eza -TDa --level 3";
        # eza — files+dirs tree (show hidden)
        lsta   = "eza -Ta";
        lsta1  = "eza -Ta --level 1";
        lsta2  = "eza -Ta --level 2";
        lsta3  = "eza -Ta --level 3";
      };
    };

  };
}
