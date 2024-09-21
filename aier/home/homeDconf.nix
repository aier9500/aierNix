{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./dconf/gnomeCustomKeybindings.nix
    ./dconf/gnomeDesktopInterface.nix
    ./dconf/gnomeDesktopWMKeybindings.nix
    ./dconf/gnomeDesktopWMPreferences.nix
    ./dconf/gnomeExtensionsClipboardManager.nix
    ./dconf/gnomeExtensionsDashToDock.nix
    ./dconf/gnomeExtensionsHidetopbar.nix
    ./dconf/gnomeExtensionsUnite.nix
    ./dconf/gnomeMutter.nix
    ./dconf/gnomeShellKeybindings.nix
  ];
}