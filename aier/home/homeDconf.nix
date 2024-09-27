{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./dconf/gnomeCustomKeybindings.nix
    ./dconf/gnomeDesktopInterface.nix
    ./dconf/gnomeDesktopWMKeybindings.nix
    ./dconf/gnomeDesktopWMPreferences.nix
    ./dconf/gnomeExtensionsBlurMyShell.nix
    ./dconf/gnomeExtensionsClipboardManager.nix
    ./dconf/gnomeExtensionsDashToDock.nix
    # ./dconf/gnomeExtensionsHidetopbar.nix
    ./dconf/gnomeExtensionsPaperWM.nix
    ./dconf/gnomeExtensionsUnite.nix
    ./dconf/gnomeMutter.nix
    ./dconf/gnomeShellKeybindings.nix
    ./dconf/gnomeTouchpad.nix
  ];
}