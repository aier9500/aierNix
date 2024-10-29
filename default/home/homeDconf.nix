{ lib, ... }: 

with lib.hm.gvariant;

{
  
  imports = [
    ./homeDconf/gnomeDesktopInterface.nix
    ./homeDconf/gnomeDesktopWMKeybindings.nix
    ./homeDconf/gnomeDesktopWMPreferences.nix
    ./homeDconf/gnomeExtensionsBlurMyShell.nix
    ./homeDconf/gnomeExtensionsClipboardManager.nix
    ./homeDconf/gnomeExtensionsDashToDock.nix
    ./homeDconf/gnomeExtensionsHidetopbar.nix
    ./homeDconf/gnomeExtensionsPaperWM.nix
    ./homeDconf/gnomeExtensionsQuickSettingsAudioPanel.nix
    ./homeDconf/gnomeExtensionsRoundedWindowCornersReborn.nix
    ./homeDconf/gnomeExtensionsUnite.nix
    ./homeDconf/gnomeMediaKeys.nix
    ./homeDconf/gnomeMutter.nix
    ./homeDconf/gnomeShellKeybindings.nix
    ./homeDconf/gnomeTouchpad.nix
  ];
}