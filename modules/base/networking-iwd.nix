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
      settings.Resolve = {
        DNSSEC = "allow-downgrade";
        DNSOverTLS = "opportunistic";
      };
    };
  };
}
