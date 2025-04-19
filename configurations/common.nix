{ pkgs, modulesPath, ... }:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./common/env_vars.nix

    ./common/system.nix
    ./common/hardware.nix
    ./common/boot.nix
    ./common/networking.nix
    ./common/i18n.nix
    ./common/programs.nix
    ./common/users.nix
    ./common/theme.nix

    ./common/services/audio.nix
    ./common/services/greetd.nix
    ./common/services/ssh.nix
    ./common/services/security.nix
  ];

  nixpkgs.config.allowUnfree = true;

  virtualisation = {
    docker.enable = true;
  };

  services = {
    tailscale.enable = true;
    tumbler.enable = true; 
    auto-cpufreq.enable = false;

    # USB Automounting
    gvfs.enable = true;
    #udisks2.enable = true;
    #devmon.enable = true;
  };

  nix = {
    settings.auto-optimise-store = true;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  # Configure xdg portal for hyprland
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
    };
  };
  zramSwap.enable = true;
}
