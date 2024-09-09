{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./dconf/gnomeCustomKeybindings.nix
    ./dconf/gnomeDesktopWMKeybindings.nix
    ./dconf/gnomeDesktopWMPreferences.nix
    ./dconf/gnomeExtensionsClipboardManager.nix
    ./dconf/gnomeShellKeybindings.nix
  ];
}