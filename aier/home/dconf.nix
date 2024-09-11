{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./dconf/gnomeCustomKeybindings.nix
    ./dconf/gnomeDesktopWMKeybindings.nix
    ./dconf/gnomeDesktopWMPreferences.nix
    ./dconf/gnomeExtensionsClipboardManager.nix
    ./dconf/gnomeExtensionsDashToDock
    ./dconf/gnomeExtensionsHidetopbar.nix
    ./dconf/gnomeExtensionsUnite.nix
    ./dconf/gnomeMutter.nix
    ./dconf/gnomeShellKeybindings.nix
  ];
}