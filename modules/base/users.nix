{ pkgs, ... }:

{
  users.users.terabytes = {
    isNormalUser = true;
    description = "Carlos Fagiani Junior";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "input"
      "video"
      "audio"
      "networkmanager"
      "docker"
      "gamemod"
      "libvirtd"
      "render"
      "waydroid"
    ];
  };
}
