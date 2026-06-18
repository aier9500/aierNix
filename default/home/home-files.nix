{ config, pkgs, input, ... }:

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
    
  };
}