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
    ".themes/MarbleBlueLight".source = "${pkgs.marble-shell-theme}/share/themes/Marble-blue-light";
    ".themes/MarbleBlueDark".source = "${pkgs.marble-shell-theme}/share/themes/Marble-blue-dark";
    ".themes/MarblePinkLight".source = "${pkgs.marble-shell-theme}/share/themes/Marble-pink-light";
    ".themes/MarblePinkDark".source = "${pkgs.marble-shell-theme}/share/themes/Marble-pink-dark";
    ".themes/MarblePurpleLight".source = "${pkgs.marble-shell-theme}/share/themes/Marble-purple-light";
    ".themes/MarblePurpleDark".source = "${pkgs.marble-shell-theme}/share/themes/Marble-purple-dark";
    # ".local/share/themes/AdwGtk3".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3";
  };

  programs = {
    # Bash
    bash = {
      enable = true; 
      bashrcExtra = "
        fastfetch
        PS1='------------------\n\\[$(tput setaf 56)\\][\\[$(tput setaf 56)\\]\\u \\[$(tput setaf 92)\\]@ \\[$(tput setaf 128)\\]\\h\\[$(tput setaf 128)\\]] \\[$(tput setaf 200)\\]\\w\\[$(tput sgr0)\\]\n > '
        eval \"$(zoxide init bash)\"
      ";
      shellAliases = {
        cls = "clear"; 
        cmd = "compgen -c | fzf"; # Search through all available commands
        homesw = "home-manager switch --flake .#default"; 
        homesw-b = "home-manager switch -b backup --flake .#default";
        lsd = "eza -TD"; # Directory tree
        lsd1 = "eza -TD --level 1";
        lsd2 = "eza -TD --level 2";
        lsd3 = "eza -TD --level 3";
        lst = "eza -T"; # Directory and files tree
        lst1 = "eza -T --level 1";
        lst2 = "eza -T --level 2";
        lst3 = "eza -T --level 3";
        nixse = "nix search nixpkgs"; 
        zh = "history | fzf"; # Search through Bash history
      };
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
