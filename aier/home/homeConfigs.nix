{ config, pkgs, input, ... }: 

{

  programs.home-manager.enable = true;
  home.username = "aier";
  home.homeDirectory = "/home/aier";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  

  nixpkgs.config.allowUnfree = true; 


  home.file = {
    
    # fonts
    ".local/share/fonts/UbuntuSans".source = "${pkgs.ubuntu-sans}/share/fonts/truetype/ubuntu-sans";
    ".local/share/fonts/IbmPlex".source = "${pkgs.ibm-plex}/share/fonts/opentype";

    # .icons
    ".local/share/icons/LatteLightCursors".source = "${pkgs.catppuccin-cursors.latteLight}/share/icons/catppuccin-latte-light-cursors";

    # .themes
    ".local/share/themes/AdwGtk3".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3";
  };

  # Bash
  programs.bash = {
    enable = true; 
    bashrcExtra = "
      fastfetch
      alias cls='clear'
      alias homeswitch='home-manager switch --flake .#aier'
      alias homeswitch-b='home-manager switch -b backup --flake .#aier'
    ";
  };

}