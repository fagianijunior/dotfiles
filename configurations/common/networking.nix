{ lib, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;
    enableIPv6  = false;
    wireless.iwd = {
      enable = true;
      settings = { 
        General = {
          EnableNetworkConfiguration = true;
        };
        Network = {
          EnableIpv6 = false;
        };
        Settings = { 
          AutoConnect = true; 
        }; 
        Scan = {
          DisablePeriodicScan = false;
        };
      };
    };
  };
}