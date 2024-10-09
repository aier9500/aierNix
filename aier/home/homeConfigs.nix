{ config, pkgs, input, ... }: 

{
  home = {
    username = "aier";
    homeDirectory = "/home/aier";
    stateVersion = "24.05"; # Please read the comment before changing.
  };
  
  nixpkgs.config.allowUnfree = true; 

  home.file = {
    # fonts
    ".local/share/fonts/IbmPlex".source = "${pkgs.ibm-plex}/share/fonts/opentype";
    ".local/share/fonts/NotoCjkSerif".source = "${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk";
    ".local/share/fonts/NotoCjkSans".source = "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk";
    # .icons
    ".local/share/icons/LatteLightCursors".source = "${pkgs.catppuccin-cursors.latteLight}/share/icons/catppuccin-latte-light-cursors";
    # .themes
    # ".local/share/themes/AdwGtk3".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3";
  };

  programs = {
    # Bash
    bash = {
      enable = true; 
      bashrcExtra = "
        fastfetch
        alias cls='clear'
        alias homeswitch='home-manager switch --flake .#aier'
        alias homeswitch-b='home-manager switch -b backup --flake .#aier'
      ";
    };

    home-manager.enable = true; 

  };

  qt = {
    enable = true; 
    platformTheme.name = "adwaita";
    style.name = "adwaita";
    style.package = pkgs.adwaita-qt;
  };

  services = {
  };
}
