{ config, pkgs, ... }:

{
  imports = [
    ./hyprland
    ./neovim
    ./firefox
    ./quickshell
    ./wofi
    ./vscode
    ./git.nix
    ./wezterm.nix
    ./shell.nix

  ];

  ############################
  # Home basics
  ############################

  home.username = "terabytes";
  home.homeDirectory = "/home/terabytes";

  home.stateVersion = "25.11";

  ############################
  # Environment
  ############################

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  ############################
  # Shell
  ############################

  programs.fish = {
    enable = true;
  };

  programs.starship.enable = true;

  programs.bat.enable = true;

  ############################
  # Wayland tools
  ############################

  home.packages = with pkgs; [
    # Core
    fzf
    eza
    ripgrep
    fd
    jq
    tree

    # Wayland / Hyprland
    swaynotificationcenter
    grim
    slurp
    wl-clipboard

    # Utils
    brightnessctl
    playerctl

    # LSPs
    nil
    nixpkgs-fmt
    terraform-ls
    # python311Packages.python-lsp-server
    rubyPackages.solargraph

  ];

  gtk = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 10;
    };
    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Macchiato-Standard-Teal-Dark";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      # Add other image MIME types as needed
    };
  };

  ############################
  # Hyprland (user config)
  ############################

  programs = {
    hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = "";
          path = "${config.home.homeDirectory}/.background";
          blur_passes = 0;
          color = "rgb(1e1e2e)"; # base
        };
        label = [ ];
        image = {
          monitor = "";
          path = "${config.home.homeDirectory}/.face";
          size = 350;
          border_color = "rgb(94e2d5)"; # teal
          rounding = -1;
          position = "0, 75";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        };
      };
    };
  };

  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }

      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }

      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }

      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }

      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }

      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];
  };
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  ############################
  # Neovim (config vem depois)
  ############################

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  ############################
  # Services (user)
  ############################

  services = {
    dunst = {
      enable = true;
    };
    hyprpaper = {
      enable = true;
      settings = {
        general = {
          wallpaper_mode = "fill";
          preload = "${config.home.homeDirectory}/.background";
          wallpaper = ",${config.home.homeDirectory}/.background";
          ipc = "on";
          splash = true;
        };
      };
    };
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "brightnessctl -s set 15%";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  ############################
  # XDG
  ############################

  xdg.enable = true;
}
