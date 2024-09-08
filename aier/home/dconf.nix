{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./dconf/gnomeCustomKeybindings.nix
    ./dconf/gnomeDesktopWMKeybindings.nix
    ./dconf/gnomeDesktopWMPreferences.nix
    # ./gnomeExtensionsClipboardManager.nix
    ./dconf/gnomeShellKeybindings.nix
  ];
}