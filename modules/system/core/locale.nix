_:

{
  # Timezone is detected automatically at runtime via geoclue2 (pulled in by
  # automatic-timezoned). `time.timeZone` must stay unset for this to work. Being
  # system-wide, the detected zone applies to every user session too.
  services.automatic-timezoned.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";

  # en_DK and en_US are generated (not defaults) to back the host LC_TIME/LC_MONETARY
  # overrides in hosts/aierNixOS/locale.nix — ISO-8601 dates via en_DK, USD currency via en_US.
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "en_DK.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
}
