# modules/home/theming/stylix.nix — Stylix theme-selector framework
#
# `myConfig.themeName` (set in hosts/aierNixOS/home.nix) picks a profile from the
# `themes` attrset below; that profile drives `stylix.*`. Unknown name → throws at
# eval time. Default is "vanilla" (no visual change).
#
# To add a colorful theme:
#   1. Add an entry to `themes` (copy an existing one; set base16Scheme or image,
#      fonts, cursor, and which targets to enable).
#   2. Set myConfig.themeName to its name in hosts/aierNixOS/home.nix.
#   3. nh home switch.
#
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Shared building blocks reused across themes
  vanillaFonts = {
    serif = {
      package = pkgs.ibm-plex;
      name = "IBM Plex Serif";
    };
    sansSerif = {
      package = pkgs.ibm-plex;
      name = "IBM Plex Sans";
    };
    monospace = {
      package = pkgs.ibm-plex;
      name = "IBM Plex Mono";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };

  vanillaCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Ice";
    size = 24;
  };

  # Theme registry — add new entries here
  themes = {
    # vanilla — current look, no visual change. autoEnable=false means no color
    # targets fire; the grayscale base16Scheme is just a required placeholder.
    vanilla = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/grayscale-dark.yaml";
      fonts = vanillaFonts;
      cursor = vanillaCursor;
      targets = {
        fontconfig = true;
        font-packages = true;
        # gtk/gnome/ghostty/yazi off → GNOME stays Adwaita; ghostty/yazi keep own config
        gtk = false;
        gnome = false;
        ghostty = false;
        yazi = false;
      };
      gtkFlatpakSupport = false; # nix-flatpak owns Flatpak theming
    };

    # catppuccin — colorful dark (Catppuccin Mocha). Recolors GTK/cursor/fonts/
    # ghostty/yazi. gnome stays false (User-Themes shell path crashed baremetal).
    catppuccin = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      fonts = vanillaFonts;
      # Pin GTK app font to 11 to match the dconf doc/mono sizes (Stylix default is 12).
      fontSizeApplications = 11;
      cursor = vanillaCursor;
      targets = {
        fontconfig = true;
        font-packages = true;
        gtk = true;
        gnome = false; # never true — User Themes ext crashed baremetal
        ghostty = true;
        yazi = true;
      };
      gtkFlatpakSupport = false;
    };

    # everforest — colorful dark (Everforest Dark Hard; soft/medium variants exist).
    # Same constraints as catppuccin (gnome=false, app font 11).
    everforest = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
      fonts = vanillaFonts;
      fontSizeApplications = 11;
      cursor = vanillaCursor;
      targets = {
        fontconfig = true;
        font-packages = true;
        gtk = true;
        gnome = false; # never true — User Themes ext crashed baremetal
        ghostty = true;
        yazi = true;
      };
      gtkFlatpakSupport = false;
    };

    # wallpaper-based — palette derived from an image via stylix.image (Stylix builds
    # the base16 palette from it at build time). Swap `image` to any path to retheme.
    # NOTE: stylix.image only seeds colors; it does NOT set the desktop wallpaper.
    wallpaper-based = {
      polarity = "dark";
      image = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray.png";
      fonts = vanillaFonts;
      fontSizeApplications = 11;
      cursor = vanillaCursor;
      targets = {
        fontconfig = true;
        font-packages = true;
        gtk = true;
        gnome = false; # never true — User Themes ext crashed baremetal
        ghostty = true;
        yazi = true;
      };
      gtkFlatpakSupport = false;
    };
  };

  # Theme selection — throw on unknown name
  themeName = config.myConfig.themeName;

  selected =
    themes.${themeName}
      or (throw "stylix.nix: unknown theme '${themeName}'. Known themes: ${lib.concatStringsSep ", " (builtins.attrNames themes)}");

  # Base stylix config; base16Scheme and image are mutually exclusive (Stylix errors
  # if both set), so exactly one is merged in below via optionalAttrs.
  stylixBase = {
    # Stylix targets 26.11; this flake tracks unstable (HM 26.05). Mismatch is cosmetic.
    enableReleaseChecks = false;

    enable = true;
    autoEnable = false; # only touch targets we opt into below

    # cursor: installs the package + sets XCURSOR_THEME/GTK cursor, but NOT the dconf
    # cursor-theme key — GNOME reads that from gnome-desktop-interface.nix (no conflict).
    inherit (selected) polarity cursor;

    # Fonts
    fonts = {
      inherit (selected.fonts)
        serif
        sansSerif
        monospace
        emoji
        ;
      # Optional per-theme GTK app font size (Stylix default 12). Omit to keep default.
    }
    // lib.optionalAttrs (selected ? fontSizeApplications) {
      sizes.applications = selected.fontSizeApplications;
    };

    # Target enables (stylix.targets.<name>.enable)
    targets = {
      fontconfig.enable = selected.targets.fontconfig;
      font-packages.enable = selected.targets.font-packages;
      gtk = {
        enable = selected.targets.gtk;
        # Don't let Stylix write Flatpak overrides — nix-flatpak owns that. Keep false.
        flatpakSupport.enable = selected.gtkFlatpakSupport;
      };
      gnome.enable = selected.targets.gnome;
      ghostty.enable = selected.targets.ghostty;
      yazi.enable = selected.targets.yazi;
    };
  };

in
{
  # All stylix.* in one attrset (statix flags duplicate top-level keys). Scheme source
  # (base16Scheme or image) merged via optionalAttrs so exactly one is present.
  stylix =
    stylixBase
    // lib.optionalAttrs (selected ? base16Scheme) { inherit (selected) base16Scheme; }
    // lib.optionalAttrs (selected ? image) { inherit (selected) image; };

  # Legacy-GTK fix: enable the HM gtk module so GTK2/3 apps get a real theme name in
  # their config files (not just the dconf key they ignore). Under vanilla this writes
  # adw-gtk3; a colorful theme's Stylix gtk target overrides the mkDefault. Not setting
  # gtk.font/cursorTheme/iconTheme, so those dconf keys stay owned by
  # gnome-desktop-interface.nix.
  gtk = {
    enable = true;
    theme = {
      name = lib.mkDefault "adw-gtk3";
      package = lib.mkDefault pkgs.adw-gtk3;
    };
    # null = GTK4/libadwaita apps theme natively (silences HM stateVersion warning).
    # mkDefault so an active Stylix gtk target can override.
    gtk4.theme = lib.mkDefault null;
  };
}
