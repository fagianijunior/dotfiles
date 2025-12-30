{
  networking = {
    enableIPv6 = false;
    useNetworkd = true;
    wireless.iwd.enable = true;
  };

  services.resolved.enable = true;
}
