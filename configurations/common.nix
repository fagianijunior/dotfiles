{ pkgs, modulesPath, lib, ... }:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./common/system.nix
    ./common/hardware.nix
    ./common/security.nix
    ./common/boot.nix
    ./common/networking.nix
    ./common/i18n.nix
    ./common/audio.nix
    ./common/programs.nix
    ./common/users.nix
    ./common/theme.nix
  ];

  virtualisation = {
    docker.enable = true;
  };

  # Configure keymap in X11
  services = {
    tailscale.enable = true;
    tumbler.enable = true; 
    auto-cpufreq.enable = true;

    # USB Automounting
    gvfs.enable = true;
    #udisks2.enable = true;
    #devmon.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          user = "greeter";
          icon = "${pkgs.greetd.tuigreet}/share/icons/hyprland.png";
        };
      };
    };

    ollama = {
      enable = true;
      package = pkgs.ollama;
    };
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
