{ config, pkgs, ... }:

let
  quickshellConfigPath = "${config.home.homeDirectory}/Workspace/fagianijunior/dotfiles/home/quickshell/config";
in
{
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink quickshellConfigPath;
}