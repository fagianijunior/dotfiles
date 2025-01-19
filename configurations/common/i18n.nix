{ ... }:
{
  # Set your time zone.
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Fortaleza";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
    supportedLocales = [ "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
  };

  console.keyMap = "br-abnt2";

  # Configure location provider
  location = {
    provider = "geoclue2";
  };

  services = {
    geoclue2 = {
      enable = true;
      appConfig = {
        "gammastep" = {
          isAllowed = true;
          isSystem = false;
          users = [ "1000" "1001" ];
        };
      };
    };
    
    xserver.xkb = {
      layout = "br";
      variant = "nodeadkeys";
    };
  };
}