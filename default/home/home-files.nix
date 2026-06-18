{ config, pkgs, ... }:

{
  home.file = {
    # fonts
    ".local/share/fonts/IbmPlex".source = "${pkgs.ibm-plex}/share/fonts/opentype";
    ".local/share/fonts/NotoCjkSerif".source = "${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk";
    ".local/share/fonts/NotoCjkSans".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk";
    # MyBash
    "MyBash/homesw.sh"= {
      text = 
        "
          cd ~/.dotfiles/aierNix
          home-manager switch --flake .#default
          echo \"
          ----------------------------------------
          ---------- homesw.sh Finished ----------
          ----- You can close this window now ----
          ----------------------------------------
          \"
        ";
      executable = true;
    };
    "MyBash/sysw.sh" = {
      text =
        "
          cd ~/.dotfiles/aierNix
          sudo nixos-rebuild switch --flake .#default
          echo \"
          ----------------------------------------
          ----------- sysw.sh Finished -----------
          ----- You can close this window now ----
          ----------------------------------------
          \"
        ";
      executable = true;
    };

    # ghostty
    ".config/ghostty/config.ghostty".text = ''
      theme = Everforest Dark Hard

      # transparency: lower is more transparent (blur needs Blur my Shell on GNOME)
      background-opacity = 0.8
      background-blur = true

      # initial window grid size in columns and rows
      window-width = 120
      window-height = 40

      # restore window size across launches: default | never | always
      window-save-state = never
    '';

    # yazi
    ".config/yazi/keymap.toml".text = ''
      # Custom g-prefix navigation. prepend_keymap = sits ahead of defaults.
      # Kept defaults: g h (home), g c (~/.config), g d (Downloads), g t (/tmp), g g (top)

      [[mgr.prepend_keymap]]
      on   = [ "g", "e" ]
      run  = "cd ~/Desktop"
      desc = "Go to Desktop"

      [[mgr.prepend_keymap]]
      on   = [ "g", "D" ]
      run  = "cd ~/Documents"
      desc = "Go to Documents"

      [[mgr.prepend_keymap]]
      on   = [ "g", "p" ]
      run  = "cd ~/Pictures"
      desc = "Go to Pictures"

      [[mgr.prepend_keymap]]
      on   = [ "g", "v" ]
      run  = "cd ~/Videos"
      desc = "Go to Videos"

      [[mgr.prepend_keymap]]
      on   = [ "g", "m" ]
      run  = "cd ~/Music"
      desc = "Go to Music"

      [[mgr.prepend_keymap]]
      on   = [ "g", "P" ]
      run  = "cd ~/Public"
      desc = "Go to Public"

      [[mgr.prepend_keymap]]
      on   = [ "g", "C" ]
      run  = "cd ~/.config/yazi"
      desc = "Go to yazi config"

      [[mgr.prepend_keymap]]
      on   = [ "g", "i" ]
      run  = "cd ~/Installations"
      desc = "Go to Installations"

      [[mgr.prepend_keymap]]
      on   = [ "g", "w" ]
      run  = "cd ~/Projects"
      desc = "Go to Projects"
    '';

    ".config/yazi/theme.toml".text = ''
      [which]
      cols = 3
      mask            = { bg = "#2e383c" }
      cand            = { fg = "#dbbc7f", bold = true }
      rest            = { fg = "#a6b0a0" }
      desc            = { fg = "#d3c6aa" }
      separator       = "  "
      separator_style = { fg = "#7a8478" }
    '';

    ".config/yazi/yazi.toml".text = ''
      [mgr]
      ratio = [1, 2, 5]

      [preview]
      max_width = 1200
      max_height = 1600
    '';

    # ibus-rime: select active schemas for this user
    # Rime reads ~/.config/ibus/rime/default.custom.yaml on deploy/restart.
    # The system agent installs the schema data (rime-cantonese for jyut6ping3,
    # rime-luna-pinyin for luna_pinyin); this file tells Rime which ones to surface.
    ".config/ibus/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: luna_pinyin
          - schema: jyut6ping3
    '';

    # Kando radial menu — autostart at GNOME login
    # Kando runs as a background daemon and is triggered via a global hotkey.
    # The package is added system-wide by the companion system agent.
    ".config/autostart/kando.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Kando
      Exec=kando
      X-GNOME-Autostart-enabled=true
      Comment=Kando radial menu daemon
    '';

  };
}