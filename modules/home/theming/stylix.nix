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
    # STUB — everforest (commented out; shows the full extension pattern)
    # Uncomment and fill in base16Scheme to activate.
    # ------------------------------------------------------------------
    # everforest = {
    #   polarity     = "dark";
    #   base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    #   fonts        = vanillaFonts;
    #   cursor       = vanillaCursor;
    #   targets = {
    #     fontconfig    = true;
    #     font-packages = true;
    #     gtk           = true;
    #     gnome         = true;
    #     ghostty       = true;
    #     yazi          = true;
    #   };
    #   gtkFlatpakSupport = false;
    # };
  };

  # ---------------------------------------------------------------------------
  # Theme selection — fail loudly for unknown names
  # ---------------------------------------------------------------------------

  themeName = config.myConfig.themeName;

  selected =
    themes.${themeName}
      or (throw "stylix.nix: unknown theme '${themeName}'. Known themes: ${lib.concatStringsSep ", " (builtins.attrNames themes)}");

in
{
  # Consolidate all stylix.* assignments into one attrset — required by statix
  # (repeated-key warning W:20 fires if the same top-level key appears twice).
  stylix = {
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
    inherit (selected) polarity base16Scheme cursor;

    # Fonts
    fonts = {
      inherit (selected.fonts)
        serif
        sansSerif
        monospace
        emoji
        ;
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
}
