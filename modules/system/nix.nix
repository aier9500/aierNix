# modules/system/nix.nix — nix daemon settings, nh, allowUnfree, stateVersion
_:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";

  programs.nh = {
    enable = true;
    flake = "/home/aier/.dotfiles/aierNix";
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
