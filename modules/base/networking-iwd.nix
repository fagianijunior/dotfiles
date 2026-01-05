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
  };

  services = {
    resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      dnsovertls = "opportunistic";
    };
  };
}
