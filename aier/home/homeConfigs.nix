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
        PS1='\\[$(tput setaf 33)\\][\\[$(tput setaf 69)\\]\\u \\[$(tput setaf 69)\\]@ \\[$(tput setaf 105)\\]\\h\\[$(tput setaf 33)\\]] \\[$(tput setaf 105)\\]\\w\\[$(tput sgr0)\\]\n > '
        eval \"$(zoxide init bash)\"
      ";
      shellAliases = {
        cd = "z";
        cls = "clear"; 
        cmd = "compgen -c | fzf"; # Search through all available commands
        homesw = "home-manager switch --flake .#aier"; 
        homesw-b = "home-manager switch -b backup --flake .#aier";
        ls = "eza";
        lsd = "eza -TD";
        lsf = "eza -Tf";
        lst = "eza -T";
        nixse = "nix search nixpkgs"; 
        zh = "history | fzf";
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
