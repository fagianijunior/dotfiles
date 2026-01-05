{
  networking = {
    enableIPv6 = false;
    useNetworkd = true;
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
      };
    };
    resolvconf.enable = true;
  };

  services = {
    resolved = {
      enable = true;
      dnssec = "false";
      dnsovertls = "opportunistic";
    };
  };
}
