{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Game launchers
    legendary-gl
    heroic
    nile
  ];

  programs = {
    steam = {
      enable = true;
      extraPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamescope.enable = true;
  };
}