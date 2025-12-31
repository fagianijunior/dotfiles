{ pkgs, ... }:

{
  users.users.terabytes = {
    isNormalUser = true;

    shell = pkgs.fish;
    
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "docker"
    ];
  };
}
