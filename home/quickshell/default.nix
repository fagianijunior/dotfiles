{ config, pkgs, ... }:

let
  quickshellConfigPath = "${config.home.homeDirectory}/Workspace/fagianijunior/dotfiles/home/quickshell/config";
  
  # Python with Google Calendar API dependencies
  pythonWithGoogleAPI = pkgs.python3.withPackages (ps: with ps; [
    google-api-python-client
    google-auth-httplib2
    google-auth-oauthlib
    requests
  ]);
in
{
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  # Create a symlink to python with google API packages (don't add to home.packages to avoid conflicts)
  home.file.".local/bin/python3-google".source = "${pythonWithGoogleAPI}/bin/python3";

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink quickshellConfigPath;
}