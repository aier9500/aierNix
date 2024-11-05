{ pkgs, ... }: 

{

  environment.systemPackages = with pkgs; [
    annotator
    bottles
    chromium
    dconf-editor
    gnome-tweaks
    gparted
    # handbrake # temporarily disabled
    protonvpn-gui
    resources
    shutter
    vscode
    # Non graphical programs
    fastfetch
    ffmpeg-full
    gnome-themes-extra # Theming dependency
    gtk-engine-murrine # Theming dependency
    home-manager
    ntfs3g
    python3
    sassc # Theming dependency
    usbutils # lsusb etc.
    # Shell wizardry
    eza # Better ls
    fd # Better find
    ripgrep # Better grep
    zoxide # Better cd
  ];

  programs = {
    adb.enable = true; # Android USB Debugging
    droidcam.enable = true; 
    fzf.fuzzyCompletion = true;
    git.enable = true; 
    localsend = { # Nearby Share for all
      enable = true;
      openFirewall = true; 
    };
    java.enable = true; 
    obs-studio = {
      enable = true;
      enableVirtualCamera = true; 
      plugins = [
        pkgs.obs-studio-plugins.droidcam-obs
      ];
    };
    thunderbird.enable = true; 
  };

  services.kanata = {
    enable = true;
    keyboards.default.config = # exchanges caps lock and backspace
    "
      (defsrc
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt rmet rctl
      )

      (deflayer default
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
      grv  1    2    3    4    5    6    7    8    9    0    -    =    caps
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    
      bspc a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt rmet rctl
      )  
    ";
  };

  virtualisation = {
    libvirtd.enable = true; 
    waydroid.enable = true; 
  };
}