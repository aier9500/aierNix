{ config, pkgs, input, ... }: 

{

  programs.home-manager.enable = true;
  home.username = "aier";
  home.homeDirectory = "/home/aier";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  

  nixpkgs.config.allowUnfree = true; 


  home.file = {
    
    # fonts
    ".fonts/ubuntuSans".source = "${pkgs.ubuntu-sans}/share/fonts/truetype/ubuntu-sans";

    # .icons
    ".icons/latteLightCursors".source = "${pkgs.catppuccin-cursors.latteLight}/share/icons/catppuccin-latte-light-cursors";

    # .themes
    ".themes/adwGtk3".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3";
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