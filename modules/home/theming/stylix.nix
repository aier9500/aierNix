# modules/home/theming/stylix.nix — Stylix theme-selector framework
#
# HOW IT WORKS
# ============
# 1. `myConfig.themeName` (set in hosts/aierNixOS/home.nix) selects which
#    theme profile is active.  Default is "vanilla".
# 2. The `themes` attrset below maps each name to a set of Stylix settings.
# 3. `selected` is the active theme attrset; its fields drive `stylix.*`.
# 4. An unknown theme name → `throw` at eval time (loud failure, not silent).
#
# HOW TO ADD A FUTURE COLORFUL THEME (e.g. "everforest")
# =======================================================
# Step 1 — Add an entry to the `themes` attrset:
#
#   everforest = {
#     polarity   = "dark";
#     # Base16 scheme file from pkgs.base16-schemes or a local path:
#     base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
#     fonts      = vanillaFonts;   # reuse the same font record, or override
#     cursor     = vanillaCursor;  # reuse cursor, or switch to a new one
#     targets = {
#       fontconfig    = true;
#       font-packages = true;
#       gtk           = true;    # enables GTK theming (Adwaita replaced)
#       gnome         = true;    # sets GNOME shell colors
#       ghostty       = true;    # recolors terminal
#       yazi          = true;    # recolors file manager
#     };
#     # NOTE: if gtk target is on, keep gtkFlatpakSupport = false unless
#     # you've disabled nix-flatpak's declarative flatpak theming — both
#     # writing flatpak overrides creates a conflict.
#     gtkFlatpakSupport = false;
#   };
#
# Step 2 — Switch by changing myConfig.themeName = "everforest" in
#           hosts/aierNixOS/home.nix.
# Step 3 — Run: nh home switch
# That's the entire change surface.
#
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # ---------------------------------------------------------------------------
  # Shared building blocks (reused across theme definitions)
  # ---------------------------------------------------------------------------

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

  # ---------------------------------------------------------------------------
  # Theme registry — add new entries here
  # ---------------------------------------------------------------------------

  themes = {
    # ------------------------------------------------------------------
    # vanilla — reproduces the current look exactly; no visual change.
    #
    # INERT color scheme: autoEnable = false means no color targets fire.
    # The base16Scheme below is a neutral grayscale placeholder; it has
    # no visible effect because no color target (gtk/gnome/ghostty/yazi)
    # is enabled.  It exists only because stylix.enable = true requires a
    # scheme to be set.
    # ------------------------------------------------------------------
    vanilla = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/grayscale-dark.yaml";
      fonts = vanillaFonts;
      cursor = vanillaCursor;
      # Which stylix targets to enable (all others stay off via autoEnable=false)
      targets = {
        fontconfig = true;
        font-packages = true;
        # gtk / gnome / ghostty / yazi / etc. → all FALSE
        # GNOME stays Adwaita; ghostty/yazi keep their own config.
        gtk = false;
        gnome = false;
        ghostty = false;
        yazi = false;
      };
      # flatpakSupport: keep false; nix-flatpak owns Flatpak theming
      gtkFlatpakSupport = false;
    };

    # ------------------------------------------------------------------
    # catppuccin — colorful dark profile (Catppuccin Mocha).
    #
    # Recolors GTK / cursor / fonts / ghostty / yazi.  Deliberately keeps
    # targets.gnome = FALSE: the GNOME Shell User-Themes path crashed
    # baremetal previously, so GNOME shell + night-theme-switcher stay in
    # dconf (see gnome-dconf/).  Activate by flipping
    # myConfig.themeName = "catppuccin" in hosts/aierNixOS/home.nix.
    # ------------------------------------------------------------------
    catppuccin = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      fonts = vanillaFonts;
      # Pin the GTK "applications" font size to 11 to match the dconf
      # document/monospace font sizes.  Stylix's default is 12, which the
      # gtk target would write into org/gnome/desktop/interface.font-name,
      # making the shell UI font a point larger than doc/mono (11) — a
      # visible inconsistency.  Keep all three at 11.
      fontSizeApplications = 11;
      cursor = vanillaCursor;
      targets = {
        fontconfig = true;
        font-packages = true;
        gtk = true; # replaces Adwaita with the base16 GTK theme
        gnome = false; # NEVER true — User Themes ext crashed baremetal
        ghostty = true; # recolors terminal (was using ghostty default)
        yazi = true; # recolors file manager (was using yazi default)
      };
      # Keep false: nix-flatpak owns Flatpak theming (see target comment below).
      gtkFlatpakSupport = false;
    };

    # ------------------------------------------------------------------
    # everforest — colorful dark profile (Everforest Dark Hard).
    #
    # Uses the dark-hard variant from base16-schemes (darkest background,
    # highest contrast — preferred; soft/medium available at
    # everforest-dark-soft.yaml / everforest-dark-medium.yaml).
    # Same constraints as catppuccin: gnome = false (User Themes ext
    # crashed baremetal previously), fontSizeApplications = 11 (keep all
    # three font sizes consistent at 11pt; Stylix default is 12).
    # Activate by setting myConfig.themeName = "everforest" in
    # hosts/aierNixOS/home.nix.
    # ------------------------------------------------------------------
    everforest = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
      fonts = vanillaFonts;
      fontSizeApplications = 11;
      cursor = vanillaCursor;
      targets = {
        fontconfig = true;
        font-packages = true;
        gtk = true; # replaces Adwaita with the base16 GTK theme
        gnome = false; # NEVER true — User Themes ext crashed baremetal
        ghostty = true; # recolors terminal
        yazi = true; # recolors file manager
      };
      gtkFlatpakSupport = false;
    };

    # ------------------------------------------------------------------
    # wallpaper-based — palette derived from the user's current wallpaper.
    #
    # Uses stylix.image instead of base16Scheme: Stylix generates the
    # base16 palette from the image at build time.  The image below is
    # the user's current dark wallpaper (NixOS simple-dark-gray), resolved
    # as a nix-store package reference so it is reproducible and GC-safe.
    #
    # To swap the wallpaper: change `image` to any absolute image path or
    # ${pkgs.<something>}/path/to/file.png.  The palette auto-regenerates
    # on the next build.
    #
    # NOTE: stylix.image does NOT set the GNOME desktop background — it
    # only seeds the color palette.  Set the desktop wallpaper separately
    # (e.g. via dconf or GNOME Settings) if desired.
    #
    # Activate by setting myConfig.themeName = "wallpaper-based" in
    # hosts/aierNixOS/home.nix.
    # ------------------------------------------------------------------
    wallpaper-based = {
      polarity = "dark";
      image = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray.png";
      fonts = vanillaFonts;
      fontSizeApplications = 11;
      cursor = vanillaCursor;
      targets = {
        fontconfig = true;
        font-packages = true;
        gtk = true; # replaces Adwaita with the wallpaper-derived GTK theme
        gnome = false; # NEVER true — User Themes ext crashed baremetal
        ghostty = true; # recolors terminal
        yazi = true; # recolors file manager
      };
      gtkFlatpakSupport = false;
    };
  };

  # ---------------------------------------------------------------------------
  # Theme selection — fail loudly for unknown names
  # ---------------------------------------------------------------------------

  themeName = config.myConfig.themeName;

  selected =
    themes.${themeName}
      or (throw "stylix.nix: unknown theme '${themeName}'. Known themes: ${lib.concatStringsSep ", " (builtins.attrNames themes)}");

  # ---------------------------------------------------------------------------
  # Base stylix config attrset — merged with the scheme-source below.
  # Split out because `base16Scheme` and `image` are mutually exclusive in
  # Stylix (it errors if both are set), so we inject exactly one of them via
  # optionalAttrs at the top module output level.
  # ---------------------------------------------------------------------------
  stylixBase = {
    # -------------------------------------------------------------------------
    # Suppress Stylix/HM version-mismatch warning.
    # Stylix targets 26.11; this flake tracks nixos-unstable (HM release 26.05).
    # The mismatch is cosmetic — options and targets we use are stable.
    # -------------------------------------------------------------------------
    enableReleaseChecks = false;

    # -------------------------------------------------------------------------
    # Core settings — driven by the selected theme
    # -------------------------------------------------------------------------
    enable = true;
    autoEnable = false; # never touch targets unless we opt in below

    # cursor: drives home.pointerCursor → installs the package, sets
    # XCURSOR_THEME env var, ~/.icons symlink, and GTK/X cursor theme.
    # It does NOT write org/gnome/desktop/interface/cursor-theme (dconf).
    # GNOME Shell reads that dconf key, which is set in gnome-desktop-interface.nix.
    # The two sources do not conflict — see gnome-desktop-interface.nix comment.
    inherit (selected) polarity cursor;

    # Fonts
    fonts = {
      inherit (selected.fonts)
        serif
        sansSerif
        monospace
        emoji
        ;
      # Optional per-theme override of the GTK "applications" font size.
      # Stylix defaults this to 12; a theme may pin it (e.g. catppuccin = 11)
      # so the gtk-target-written font-name matches the dconf doc/mono sizes.
      # Themes that omit fontSizeApplications keep the Stylix default.
    }
    // lib.optionalAttrs (selected ? fontSizeApplications) {
      sizes.applications = selected.fontSizeApplications;
    };

    # -------------------------------------------------------------------------
    # Target enables — each key is stylix.targets.<name>.enable
    # -------------------------------------------------------------------------
    targets = {
      fontconfig.enable = selected.targets.fontconfig;
      font-packages.enable = selected.targets.font-packages;
      gtk = {
        enable = selected.targets.gtk;
        # Prevent Stylix gtk target from writing Flatpak theme overrides.
        # nix-flatpak manages Flatpak apps declaratively; letting Stylix also
        # write flatpak overrides creates a conflict.  Keep false even for
        # color themes unless nix-flatpak's flatpak theming is disabled.
        flatpakSupport.enable = selected.gtkFlatpakSupport;
      };
      gnome.enable = selected.targets.gnome;
      ghostty.enable = selected.targets.ghostty;
      yazi.enable = selected.targets.yazi;
    };
  };

in
{
  # Consolidate all stylix.* assignments into one attrset — required by statix
  # (repeated-key warning W:20 fires if the same top-level key appears twice).
  # The scheme source (base16Scheme or image) is merged in via optionalAttrs so
  # that exactly one is present — Stylix errors if both are set simultaneously.
  stylix =
    stylixBase
    // lib.optionalAttrs (selected ? base16Scheme) { inherit (selected) base16Scheme; }
    // lib.optionalAttrs (selected ? image) { inherit (selected) image; };

  # ---------------------------------------------------------------------------
  # Legacy-GTK fix: enable the HM gtk module unconditionally so GTK3 (and GTK2)
  # legacy apps see a proper theme name in ~/.config/gtk-3.0/settings.ini and
  # ~/.gtkrc-2.0, not just the dconf gtk-theme key that GTK3 legacy apps ignore.
  #
  # Under vanilla: gtk module fires → settings.ini/gtkrc-2.0 get gtk-theme=adw-gtk3.
  # Under colorful themes: Stylix gtk target ALSO writes gtk.theme (at normal
  # priority), overriding the mkDefault here → the palette GTK theme wins.
  # adw-gtk3 already in home.packages (home-pkgs.nix); listed here as package
  # reference so the module can add it to GTK's theme search path as well.
  #
  # NOT setting gtk.font / gtk.cursorTheme / gtk.iconTheme — leaving those unset
  # means the gtk module does NOT write dconf font-name / cursor-theme, so those
  # keys stay governed by their lib.mkDefault values in gnome-desktop-interface.nix.
  # ---------------------------------------------------------------------------
  gtk = {
    enable = true;
    theme = {
      name = lib.mkDefault "adw-gtk3";
      package = lib.mkDefault pkgs.adw-gtk3;
    };
    # Silence HM stateVersion < 26.05 migration warning: adopt the new default
    # (null = GTK4/libadwaita apps theme natively). Use mkDefault so Stylix's
    # gtk target can override this when active (Stylix writes at normal priority).
    gtk4.theme = lib.mkDefault null;
  };
}
