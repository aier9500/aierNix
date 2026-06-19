# hosts/aierNixOS/home.nix — P2 modular home-manager configuration
#
# Sets home-manager identity values, myConfig.* cross-cutting values,
# and enables all active home feature toggles for this machine.
{ ... }:

{
  imports = [
    # Shell
    ../../modules/home/shell/bash.nix
    # CLI tools
    ../../modules/home/cli/eza.nix
    ../../modules/home/cli/fzf.nix
    ../../modules/home/cli/zoxide.nix
    ../../modules/home/cli/gh.nix
    ../../modules/home/cli/fastfetch.nix
    ../../modules/home/cli/yazi.nix
    # Terminal
    ../../modules/home/terminal/ghostty.nix
    # Apps
    ../../modules/home/apps/vscode.nix
    ../../modules/home/apps/obs-studio.nix
    ../../modules/home/apps/flatpak-home.nix
    ../../modules/home/apps/home-pkgs.nix
    # Theming
    ../../modules/home/theming/dconf.nix
    ../../modules/home/theming/cursors.nix
    # Misc
    ../../modules/home/misc/fonts-home.nix
    ../../modules/home/misc/kando.nix
  ];

  # Cross-cutting values (consumed by modules via myConfig.*)
  myConfig = {
    user = "aier";
    hostname = "aierNixOS";
    timezone = "America/Caracas";
    locale = "en_US.UTF-8";
    themeName = "";
  };

  # Identity — required by standalone home-manager
  home = {
    username = "aier";
    homeDirectory = "/home/aier";
    stateVersion = "24.05"; # Do not change — controls HM state compatibility
  };

  # Allow unfree packages (vscode, etc.)
  nixpkgs.config.allowUnfree = true;

  # home-manager manages itself
  programs.home-manager.enable = true;

  # Feature toggles — enable all currently-active home features
  myHome = {
    shell.bash.enable = true;
    cli = {
      eza.enable = true;
      fzf.enable = true;
      zoxide.enable = true;
      gh.enable = true;
      fastfetch.enable = true;
      yazi.enable = true;
    };
    terminal.ghostty.enable = true;
    apps = {
      vscode.enable = true;
      obsStudio.enable = true;
      flatpak.enable = true;
      homePkgs.enable = true;
    };
    theming = {
      gnome.enable = true;
      cursors.enable = true;
    };
    fonts.enable = true;
    kando.enable = true;
  };
}
