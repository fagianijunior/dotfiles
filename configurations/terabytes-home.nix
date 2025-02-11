{ config, pkgs, ... }:
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
  rosewater = "rgb(f4dbd6)";
  rosewaterAlpha = "f4dbd6";
  flamingo = "rgb(f0c6c6)";
  flamingoAlpha = "f0c6c6";
  pink = "rgb(f5bde6)";
  pinkAlpha = "f5bde6";
  mauve = "rgb(c6a0f6)";
  mauveAlpha = "c6a0f6";
  red = "rgb(ed8796)";
  redAlpha = "ed8796";
  maroon = "rgb(ee99a0)";
  maroonAlpha = "ee99a0";
  peach = "rgb(f5a97f)";
  peachAlpha = "f5a97f";
  yellow = "rgb(eed49f)";
  yellowAlpha = "eed49f";
  green = "rgb(a6da95)";
  greenAlpha = "a6da95";
  teal = "rgb(8bd5ca)";
  tealAlpha = "8bd5ca";
  sky = "rgb(91d7e3)";
  skyAlpha = "91d7e3";
  sapphire = "rgb(7dc4e4)";
  sapphireAlpha = "7dc4e4";
  blue = "rgb(8aadf4)";
  blueAlpha = "8aadf4";
  lavender = "rgb(b7bdf8)";
  lavenderAlpha = "b7bdf8";
  text = "rgb(cad3f5)";
  textAlpha = "cad3f5";
  subtext1 = "rgb(b8c0e0)";
  subtext1Alpha = "b8c0e0";
  subtext0 = "rgb(a5adcb)";
  subtext0Alpha = "a5adcb";
  overlay2 = "rgb(939ab7)";
  overlay2Alpha = "939ab7";
  overlay1 = "rgb(8087a2)";
  overlay1Alpha = "8087a2";
  overlay0 = "rgb(6e738d)";
  overlay0Alpha = "6e738d";
  surface2 = "rgb(5b6078)";
  surface2Alpha = "5b6078";
  surface1 = "rgb(494d64)";
  surface1Alpha = "494d64";
  surface0 = "rgb(363a4f)";
  surface0Alpha = "363a4f";
  base = "rgb(24273a)";
  baseAlpha = "24273a";
  mantle = "rgb(1e2030)";
  mantleAlpha = "1e2030";
  crust = "rgb(181926)";
  crustAlpha = "181926";
in
{
  home = {
    username      = "terabytes";
    homeDirectory = "/home/terabytes";
    stateVersion  = "24.11";
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
  };

  # Exemplo de configuração do Hyprland

  xdg.configFile."hypr/pyprland.toml".source = ../dotfiles/hypr/pyprland.toml;
  xdg.configFile."solaar/config.yaml".source = ../dotfiles/solaar/config.yaml;

  xdg.configFile."rofi/themes/catppuccin-macchiato.rasi".source = ../dotfiles/rofi/themes/catppuccin-macchiato.rasi;
  xdg.configFile."bat/themes/Catppuccin-macchiato.tmTheme".source = ../dotfiles/bat/themes/Catppuccin-macchiato.tmTheme;

  xdg.configFile."wlogout/icons/hibernate.png".source = ../dotfiles/wlogout/icons/hibernate.png;
  xdg.configFile."wlogout/icons/lock.png".source = ../dotfiles/wlogout/icons/lock.png;
  xdg.configFile."wlogout/icons/logout.png".source = ../dotfiles/wlogout/icons/logout.png;
  xdg.configFile."wlogout/icons/reboot.png".source = ../dotfiles/wlogout/icons/reboot.png;
  xdg.configFile."wlogout/icons/shutdown.png".source = ../dotfiles/wlogout/icons/shutdown.png;
  xdg.configFile."wlogout/icons/suspend.png".source = ../dotfiles/wlogout/icons/suspend.png;
 

   xdg.desktopEntries.firefox = {
    categories = [ "Network" "WebBrowser" ];
    exec = "firefox --profileManager %U";
    genericName = "Web Browser";
    icon ="firefox";
    mimeType = ["text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
    name = "Firefox";
    terminal = false;
    type = "Application";
  };

  services = {
    avizo = {
      enable = true;
      settings = {
        default = {
          background = "rgba(128, 135, 162, 1)";
          time = 2;
        };
      };
    };
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
        };
   
        listener = [
          {
            timeout = 300;                                # 5min.
            on-timeout = "brightnessctl -s set 15%";        # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r";                 # monitor backlight restore.
          }
     
        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          {
            timeout = 300;                                                # 5min.
            on-timeout = "brightnessctl -sd platform::kbd_backlight set 0"; # turn off keyboard backlight.
            on-resume = "brightnessctl -rd platform::kbd_backlight";        # turn on keyboard backlight.
          }
     
          {
            timeout = 300;                                 # 5min
            on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
          }
     
          {
            timeout = 600;                                 # 10min
            on-timeout = "hyprctl dispatch dpms off";        # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on";          # screen on when activity is detected after timeout has fired.
          }
     
          {
            timeout = 780;                                 # 13min
            on-timeout = "systemctl suspend";                # suspend pc
          }
        ];
      };
    };
    hyprpaper = {
      enable = true;
      settings = {
        general = {
          wallpaper_mode = "fill";
          preload = "~/Pictures/Wallpapers/constelacao.jpg";
          wallpaper = ",~/Pictures/Wallpapers/constelacao.jpg";
          ipc = "on";
          splash = true;
        };
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$terminal"         = "wezterm";
      "$browser"          = "firefox --ProfileManager";
      "$fileManager"      = "$terminal -e yazi";
      "$menu"             = "rofi -show drun";
      "$mainMod"          = "SUPER";
      "$volume_sidemenu"  = "class:^(org.pulseaudio.pavucontrol)$";

      exec-once = [
        "pypr"
        "hyprpaper"
        "hypridle"
        "poweralertd"
        "avizo-service"
        "systemctl --user start psi-notify"
        "fish -c autostart"
        "[workspace 1] $browser"
        "[workspace 3] telegram-desktop"
        "[workspace 3] firefox -P whatsapp -kiosk https://web.whatsapp.com"
        "systemctl --user start hyprpolkitagent"
      ];

      monitor =  [
        "eDP-1, 1920x1080@60, 0x0, 1.00"
        "HDMI-A-1, 2560x1080@60, 2560x0, 1.00"
      ];

      general = {
        gaps_in     = 3;
        gaps_out    = 3;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border"   = teal;
        "col.inactive_border" = surface1;

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      misc = {
        force_default_wallpaper   = -1;
        disable_splash_rendering  = true;
        disable_hyprland_logo     = true;
        background_color          = "0x24273a";
      };

      input = {
        kb_layout     = "br";
        kb_variant    = "";
        kb_model      = "";
        kb_options    = "";
        kb_rules      = "";
        left_handed   = false;
        follow_mouse  = 1;
        sensitivity   = 0;
        scroll_points = -1 -1;
        scroll_factor = 0.5;

        touchpad = {
          natural_scroll        = true;
          disable_while_typing  = true;
          clickfinger_behavior  = true;
          scroll_factor         = 0.5;
        };
      };

      binds = {
        workspace_back_and_forth = true;
      };

      dwindle = {
        pseudotile      = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split  = true; # You probably want this
        smart_split     = true;
      };

      gestures = {
        workspace_swipe         = true;
        workspace_swipe_fingers = 3;
      };

      windowrule = [
        "float, imv"
        "opaque, imv"
        "float, title:(Media viewer)"
        "opaque, title:(Media viewer)"
        "opaque, telegram"
        "opaque, swappy"
        "center 1, swappy"
        "stayfocused, swappy"

        "center, title:^(Open File)(.*)$"
        "center, title:^(Select a File)(.*)$"
        "center, title:^(Choose wallpaper)(.*)$"
        "center, title:^(Open Folder)(.*)$"
        "center, title:^(Save As)(.*)$"
        "center, title:^(Library)(.*)$"
        "center, title:^(File Upload)(.*)$"

        "noblur,.*"
      ];

      windowrulev2 = [
        "float, $volume_sidemenu"
        "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "opaque, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "opaque, title:^(Netflix)(.*)$"
        "opaque, title:^(.*)(YouTube)(.*)$"
        "suppressevent maximize, class:.* # You'll probably like this."
        "pin, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$ "
      ];
      
      bind = [
        "$mainMod CTRL, V, exec, pypr toggle volume"
        "$mainMod, Z, exec, pypr zoom"
        "$mainMod, ESCAPE, exec, pkill -x wlogout || wlogout"

        "$mainMod SHIFT, P, exec, fish -c screenshot_to_clipboard"
        "$mainMod CTRL, P, exec, fish -c screenshot_edit"
        "$mainMod SHIFT, R, exec, fish -c record_screen_gif"
        "$mainMod CTRL, R, exec, fish -c record_screen_mp4"

        "$mainMod, V, exec, fish -c clipboard_to_type"
        "$mainMod SHIFT, V, exec, fish -c clipboard_to_wlcopy"
        "$mainMod, X, exec, fish -c clipboard_delete_item"
        "$mainMod SHIFT, X, exec, fish -c clipboard_clear"

        "$mainMod, U, exec, fish -c bookmark_to_type"
        "$mainMod SHIFT, U, exec, fish -c bookmark_add"
        "$mainMod CTRL, U, exec, fish -c bookmark_delete"

        "$mainMod, D, fullscreen, 1"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, togglefloating,"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, L, exec, hyprlock"
        "$mainMod ALT, M, exit,"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, Q, killactive"
        "$mainMod, R, exec, $menu"
        "$mainMod, SPACE, exec, $terminal"
        "$mainMod, O, exec, hyprctl setprop active opaque toggle "

        "$mainMod SHIFT, N, exec, fish -c notification_mode_toggle"

        "Alt, E, exec, $fileManager"
        "Alt, G, exec, gimp"
        "Alt, T, exec, telegram-desktop"
        "Alt, W, exec, firefox -P whatsapp -kiosk https://web.whatsapp.com"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, G, togglespecialworkspace, game"
        "$mainMod SHIFT, G, movetoworkspace, speci"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # "$mainMod ALT,M,submap,move"
        # "$mainMod ALT,R,submap,resize"
        "$mainMod CTRL, V, exec, pypr toggle volume"
      ] ++ (
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mainMod, code:1${toString i}, workspace, ${toString ws}"
            "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9)
      );

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86MonBrightnessUp, exec, lightctl up"
        ",XF86MonBrightnessDown, exec, lightctl down"

        ",XF86AudioRaiseVolume, exec, volumectl -u up"
        ",XF86AudioLowerVolume, exec, volumectl -u down"
        ",XF86AudioMute, exec, volumectl toggle-mute"
        "$mainMod, XF86AudioMute, exec, volumectl -m toggle-mute"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];

      decoration = {
        rounding = 10;

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size    = 8;
          passes  = 2;
        };

        # Change transparency of focused and unfocused windows
        active_opacity      = 0.9;
        inactive_opacity    = 0.9;
        fullscreen_opacity  = 0.9;
      };

      animations = {
        enabled = true;
        bezier  = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      master = {
        new_status = "master";
      };

      device = [
        {
          name        = "keyboard-k380-keyboard";
          kb_layout   = "us";
          kb_variant  = "intl";
        }
      ];
    };
  };

  programs = {
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
          path = "$HOME/background";
          blur_passes = 2;
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
          placeholder_text = ''<span foreground='' + textAlpha + ''><i>🔐 Logged in as </i><span foreground='' + tealAlpha + ''>$USER</span></span>'';
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
            "browser.startup.homepage" = [
              "https://suporte.veezor.com"
              "https://veezor.clickup.com"
            ];
            "browser.newtabpage.pinned" = [{
              title = "NixOS";
              url = "https://suporte.veezor.com";
            }
            {
              title = "ClickUp";
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
          Value= true;
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
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
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
          # Simple Tab Groups:
          "simple-tab-groups@drive4ik" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4103800/simple_tab_groups-5.2.xpi";
            installation_mode = "force_installed";
          };
          # Theme: Catppuccin-macchiato
          "{030fcc87-b84d-4004-a7de-a6166cdf7333}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/3958203/catppuccin_macchiato-1.0.xpi";
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
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.startup.page" = "3";
          
          "browser.sessionstore.resume_session_once" = lock-true;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
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