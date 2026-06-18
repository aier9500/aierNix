{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./HomeDconf/gnomeDesktopInterface.nix
    ./HomeDconf/gnomeDesktopWMKeybindings.nix
    ./HomeDconf/gnomeDesktopWMPreferences.nix
    ./HomeDconf/gnomeExtensionsBlurMyShell.nix
    ./HomeDconf/gnomeExtensionsClipboardManager.nix
    ./HomeDconf/gnomeExtensionsJustPerfection.nix
    ./HomeDconf/gnomeMediaKeys.nix
    ./HomeDconf/gnomeMutter.nix
    ./HomeDconf/gnomeShellKeybindings.nix
    ./HomeDconf/gnomeTouchpad.nix
  ];
}