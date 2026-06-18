{ config, pkgs, ... }:

{
  programs = {
    # Ghostty terminal
    ghostty = {
      enable = true;
      settings = {
        theme = "Everforest Dark Hard";

        # transparency: lower is more transparent (blur needs Blur my Shell on GNOME)
        background-opacity = 0.8;
        background-blur = true;

        # initial window grid size in columns and rows
        window-width = 120;
        window-height = 40;

        # restore window size across launches: default | never | always
        window-save-state = "never";
      };
    };

    # Yazi file manager
    yazi = {
      enable = true;

      settings = {
        # yazi.toml
        mgr = {
          ratio = [ 1 2 5 ];
        };
        preview = {
          max_width  = 1200;
          max_height = 1600;
        };
      };

      # keymap.toml — custom g-prefix navigation.
      # prepend_keymap sits ahead of defaults.
      # Kept defaults: g h (home), g c (~/.config), g d (Downloads), g t (/tmp), g g (top)
      keymap = {
        mgr.prepend_keymap = [
          { on = [ "g" "e" ]; run = "cd ~/Desktop";        desc = "Go to Desktop";      }
          { on = [ "g" "D" ]; run = "cd ~/Documents";      desc = "Go to Documents";    }
          { on = [ "g" "p" ]; run = "cd ~/Pictures";       desc = "Go to Pictures";     }
          { on = [ "g" "v" ]; run = "cd ~/Videos";         desc = "Go to Videos";       }
          { on = [ "g" "m" ]; run = "cd ~/Music";          desc = "Go to Music";        }
          { on = [ "g" "P" ]; run = "cd ~/Public";         desc = "Go to Public";       }
          { on = [ "g" "C" ]; run = "cd ~/.config/yazi";   desc = "Go to yazi config";  }
          { on = [ "g" "i" ]; run = "cd ~/Installations";  desc = "Go to Installations";}
          { on = [ "g" "w" ]; run = "cd ~/Projects";       desc = "Go to Projects";     }
        ];
      };

      theme = {
        # theme.toml
        which = {
          cols            = 3;
          mask            = { bg = "#2e383c"; };
          cand            = { fg = "#dbbc7f"; bold = true; };
          rest            = { fg = "#a6b0a0"; };
          desc            = { fg = "#d3c6aa"; };
          separator       = "  ";
          separator_style = { fg = "#7a8478"; };
        };
      };
    };

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
