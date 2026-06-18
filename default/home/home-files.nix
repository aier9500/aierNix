{ config, pkgs, ... }:

{
  home.file = {
    # fonts
    ".local/share/fonts/IbmPlex".source = "${pkgs.ibm-plex}/share/fonts/opentype";
    # JetBrainsMono Nerd Font: full braille/box/symbol + icon coverage so the
    # VS Code terminal (Claude Code TUI spinner ⠋, ▶, etc.) renders without tofu boxes.
    ".local/share/fonts/JetBrainsMonoNerd".source = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";
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
    # Kando general settings — app-level preferences (theme, behaviour, etc.)
    # ".config/kando/config.json".source = ../../tuxies-wiki/resources/logitech-linux-setup/kando/general-settings-backup.json;
    # Kando menu definitions — radial menu layout and actions
    # ".config/kando/menus.json".source = ../../tuxies-wiki/resources/logitech-linux-setup/kando/menu-settings-backup.json;

    # Solaar rules — Logitech button remaps and device rules
    # ".config/solaar/rules.yaml".source = ../../tuxies-wiki/resources/logitech-linux-setup/solaar/rules.yaml;

  };
}
