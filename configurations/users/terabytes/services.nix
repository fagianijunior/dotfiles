{ pkgs, ... }:
let
  teal = "rgb(8bd5ca)";
  surface1 = "rgb(494d64)";
in
{
  
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
	      timeout = 600;                                 # 10min
	      on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
	    }

	    {
	      timeout = 1200;                                 # 20min
	      on-timeout = "hyprctl dispatch dpms off";        # screen off when timeout has passed
	      on-resume = "hyprctl dispatch dpms on";          # screen on when activity is detected after timeout has fired.
	    }

          # {
          #   timeout = 600;                                 # 10min
          #   on-timeout = "systemctl suspend";                # suspend pc
          # }
        ];
      };
    };
    hyprpaper = {
      enable = true;
      settings = {
        general = {
          wallpaper_mode = "fill";
          preload = "$HOME/.background";
          wallpaper = ",$HOME/.background";
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
     	"[workspace 4] clickup"
     	"[workspace 4] slack"
     	"systemctl --user start hyprpolkitagent"
      ];

      monitor =  [
     	"eDP-1, 1920x1080@60, 3440x0, 1.00"
     	"DP-1, 3440x1440@100, 0x0, 1.00"
     	"HDMI-A-1, 2560x1080@60, 1920x0, 1.00"
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
        "float, title:(Media viewer)"
        "opaque, title:(Media viewer)"

        "center, title:^(Open File)(.*)$"
        "center, title:^(Select a File)(.*)$"
        "center, title:^(Choose wallpaper)(.*)$"
        "center, title:^(Open Folder)(.*)$"
        "center, title:^(Save As)(.*)$"
        "center, title:^(Library)(.*)$"
        "center, title:^(File Upload)(.*)$"
      ];

      windowrulev2 = [
        "float, $volume_sidemenu"
        "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "opaque, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
        "opaque, title:^(Netflix)(.*)$"
        "opaque, title:^(.*)(Youtube)(.*)$"
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
        )9)
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
}
