{ config, lib, ... }: {
  services.openssh = {
    ports = [ 22 ];
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "terabytes" ];
      UseDns = false;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}
