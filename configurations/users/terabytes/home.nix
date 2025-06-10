{ pkgs, ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  font = "JetBrains Mono Regular";
  red = "rgb(ed8796)";
  yellow = "rgb(eed49f)";
  tealAlpha = "8bd5ca";
  sky = "rgb(91d7e3)";
  text = "rgb(cad3f5)";
  surface0 = "rgb(363a4f)";
in
  {
    home = {
      username      = "terabytes";
      homeDirectory = "/home/terabytes";
      stateVersion  = "25.05";
      shellAliases  = {
        "cl"       = "clear";
        "cat"      = "bat --style=numbers,changes --color=always";
        "lgit"     = "lazygit";
        "ldocker"  = "lazydocker";
        "nswitch"  = "sudo nixos-rebuild switch --flake ~/dotfiles/#$(hostname)";
        "nswitchu" = "sudo nix flake update --flake /etc/nixos; and sudo nixos-rebuild switch --flake /etc/nixos#doraemon --upgrade";
        "nau"      = "sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos";
        "nsgc"     = "sudo nix-store --gc";
        "ngc"      = "sudo nix-collect-garbage -d";
        "ngc7"     = "sudo nix-collect-garbage --delete-older-than 7d";
        "ngc14"    = "sudo nix-collect-garbage --delete-older-than 14d";
      };
      sessionVariables = {
        "HYPRCURSOR_THEME"    = "Catppuccin-Macchiato-Teal";
        "HYPRCURSOR_SIZE"     = "24";
        "XCURSOR_THEME"       = "Catppuccin-Macchiato-Teal";
        "XCURSOR_SIZE"        = "24";
        "XDG_SESSION_TYPE"    = "wayland";
        "XDG_CURRENT_DESKTOP" = "Hyprland";
        "XDG_SESSION_DESKTOP" = "Hyprland";
      };
      #      packages = [
      # Open tmux for current project.
      #(pkgs.writeShellApplication {
      #  name = "pux";
      #  runtimeInputs = [ pkgs.tmux ];
      #  text = ''
      #    PRJ="''$(zoxide query -i)"
      #  echo "Launching tmux for ''$PRJ"
      #    set -x
      #    cd "''$PRJ" && \
      #      exec tmux -S "''$PRJ".tmux attach
      #  '';
    #  })
    #  ];
    };

    imports = [
      ./services.nix
      ./xdg.nix
      ./neovim/neovim.nix
      ./tmux.nix
    ];

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    eww = {
      enable = true;
    };

    helix.enable = true;
      vim = {
        enable = true;
      };
      vscode = {
        enable = true;
        package = pkgs.vscodium.fhs;
      };
      wlogout = {
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

        style = ''
        * {
          background-image: none;
        }
        window {
          background-color: rgba(36, 39, 58, 0.9);
        }
        button {
          margin: 8px;
          color: #cad3f5;
          background-color: #363a4f;
          border-style: solid;
          border-width: 2px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        button:active,
        button:focus,
        button:hover {
          color: #8bd5ca;
          background-color: #24273a;
          outline-style: none;
        }

        #lock {
          background-image: image(url("icons/lock.png"));
        }

        #logout {
          background-image: image(url("icons/logout.png"));
        }

        #suspend {
          background-image: image(url("icons/suspend.png"));
        }

        #hibernate {
          background-image: image(url("icons/hibernate.png"));
        }

        #shutdown {
          background-image: image(url("icons/shutdown.png"));
        }

        #reboot {
          background-image: image(url("icons/reboot.png"));
        }
        '';
      };
      home-manager.enable = true;
      rofi = {
        enable = true;
        extraConfig = {
          modi = "drun";
          icon-theme = "Numix-Circle";
          font = font + " 13";
          show-icons = true;
          terminal = "wezterm";
          drun-display-format = "{icon} {name}";
          location = 0;
          disable-history = false;
          hide-scrollbar = true;
          display-drun = " 🚀 Apps ";
          sidebar-mode = true;
          border-radius = 10;
        };
        theme = "~/.config/rofi/themes/catppuccin-macchiato.rasi";
      };
      bat = {
        enable = true;
        config = {
          theme = "Catppuccin-macchiato";
        };
      };
      fish = {
        enable = true;
      };
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = false;
            hide_cursor = true;
          };
          background = {
            monitor = "";
            path = "$HOME/.background";
            blur_passes = 0;
            color = "$base";
          };
          label = [
            {
              monitor = "";
              text = "cmd[update:30000] echo \"$(date +'%I:%M %p')\"";
              color = text;
              font_size = 90;
              font_family = font;
              position = "-130, -100";
              halign = "right";
              valign = "top";
              shadow_passes = 2;
            }
            {
              monitor = "";
              text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
              color = text;
              font_size = 25;
              font_family = font;
              position = "-130, -250";
              halign = "right";
              valign = "top";
              shadow_passes = 2;
            }
            {
              monitor       = "";
              text          = "$LAYOUT";
              color         = text;
              font_size     = 20;
              font_family   = font;
              rotate        = 0; # degrees, counter-clockwise
              position      = "-130, -310";
              halign        = "right";
              valign        = "top";
              shadow_passes = 2;
            }
          ];
          image = {
            monitor = "";
            path = "$HOME/.face";
            size = 350;
            border_color = tealAlpha;
            rounding = -1;
            position = "0, 75";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          };
          input-field = {
            monitor = "";
            size = "400, 70";
            outline_thickness = 4;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = tealAlpha;
            inner_color = surface0;
            font_color = text;
            fade_on_empty = "false";
            placeholder_text = "🔐 Logged in as $USER";
            hide_input = false;
            check_color = sky;
            fail_color = red;
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            capslock_color = yellow;
            position = "0, -185";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          };
        };
      };
      firefox = {
        enable = true;
        package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {});

        /* ---- PROFILES ---- */
      # Switch profiles via about:profiles page.
      # For options that are available in Home-Manager see
      # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
      profiles = {
        fagiani = {           # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
        id = 0;               # 0 is the default profile; see also option "isDefault"
        name = "Fagiani";      # name as listed in about:profiles
        isDefault = true;     # can be omitted; true if profile ID is 0
        settings = {          # specify profile-specific preferences here; check about:config for options
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.pinned" = [{
          title = "Suporte Veezor";
          url = "https://suporte.veezor.com";
        }
        {
          title = "Veezor ClickUp";
          url = "https://veezor.clickup.com";
        }];
      };
    };
    veezor = {
      id = 1;
      name = "Veezor";
      isDefault = false;
      settings = {
        "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
        "browser.startup.homepage" = "https://ecosia.org";
            # add preferences for profile_1 here...
          };
        };
        whatsapp = {
          id = 2;
          name = "whatsapp";
          isDefault = false;
        };
      };
      languagePacks = [ "pt-BR" "en-US" ];
      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "allowed"; # blocks all addons except the ones specified below
          # Bitwarden:
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4410896/bitwarden_password_manager-2024.12.4.xpi";
            installation_mode = "force_installed";
          };
          # AWS Extend Switch Role:
          "aws-extend-switch-roles@toshi.tilfin.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4424241/aws_extend_switch_roles3-6.0.0.xpi";
            installation_mode = "force_installed";
          };
          # Theme: Catppuccin-macchiato
          "{030fcc87-b84d-4004-a7de-a6166cdf7333}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/3958203/catppuccin_macchiato-1.0.xpi";
            installation_mode = "force_installed";
          };
          # Corretor Português:
          "pt-BR@dictionaries.addons.mozilla.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4223181/corretor-123.2024.16.151.xpi";
            installation_mode = "force_installed";
          };
        };

        /* ---- PREFERENCES ---- */
        # Check about:config for options.
        Preferences = { 
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.pocket.enabled" = lock-false;
          # "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-true;
          "browser.search.suggest.enabled.private" = lock-true;
          "browser.startup.page" = "3";

          "browser.sessionstore.resume_session_once" = lock-true;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-true;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
      };
    };
  };
}
