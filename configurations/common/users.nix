{ config, lib, pkgs, ... }:
{
  # Configure users
  users.users.terabytes = {
    isNormalUser = true;
    description = "Carlos Fagiani Junior";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "input" "video" "audio" "docker" ];
  };
}