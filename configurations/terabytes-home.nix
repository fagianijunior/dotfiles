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
  teal = "rgb(8bd5ca)";
  tealAlpha = "8bd5ca";
  sky = "rgb(91d7e3)";
  text = "rgb(cad3f5)";
  surface1 = "rgb(494d64)";
  surface0 = "rgb(363a4f)";
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

    xdg = {
      configFile."hypr/pyprland.toml".source = ../dotfiles/hypr/pyprland.toml;
      configFile."solaar/config.yaml".source = ../dotfiles/solaar/config.yaml;

      configFile."rofi/themes/catppuccin-macchiato.rasi".source = ../dotfiles/rofi/themes/catppuccin-macchiato.rasi;
      configFile."bat/themes/Catppuccin-macchiato.tmTheme".source = ../dotfiles/bat/themes/Catppuccin-macchiato.tmTheme;

      configFile."wlogout/icons/hibernate.png".source = ../dotfiles/wlogout/icons/hibernate.png;
      configFile."wlogout/icons/lock.png".source = ../dotfiles/wlogout/icons/lock.png;
      configFile."wlogout/icons/logout.png".source = ../dotfiles/wlogout/icons/logout.png;
      configFile."wlogout/icons/reboot.png".source = ../dotfiles/wlogout/icons/reboot.png;
      configFile."wlogout/icons/shutdown.png".source = ../dotfiles/wlogout/icons/shutdown.png;
      configFile."wlogout/icons/suspend.png".source = ../dotfiles/wlogout/icons/suspend.png;

      desktopEntries.firefox = {
        categories = [ "Network" "WebBrowser" ];
        exec = "firefox --profileManager %U";
        genericName = "Web Browser";
        icon ="firefox";
        mimeType = ["text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
        name = "Firefox";
        terminal = false;
        type = "Application";
      };
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
     	"openvscode-server --host 0.0.0.0 --without-connection-token &"
     	"fish -c autostart"
     	"[workspace 1] $browser"
     	"[workspace 3] telegram-desktop"
     	"[workspace 3] firefox -P whatsapp -kiosk https://web.whatsapp.com"
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

  programs = {
    helix.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = ''

          -- disable netrw at the very start of your init.lua
          vim.g.loaded_netrw = 1
          vim.g.loaded_netrwPlugin = 1
          -- set termguicolors to enale highlight groups
          vim.opt.termguicolors = true
          -- empty setup using defaults
          require("nvim-tree").setup()
          --local function open_nvim_tree(data)
          -- buffer is a real file on the disk
          --  local real_file = vim.fn.filereadable(data.file) == 1
          -- buffer is a [No Name]
          --    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
          --    if not real_file and not no_name then
          --    return
          --  end
          -- open the tree, find the file but don't focus it
          --  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
          --end
          -- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree });
          '';
        }
        { plugin = nvim-treesitter.withAllGrammars; }
        { plugin = nvim-lspconfig; }
        {
          plugin = luasnip;
          type = "lua";
          config = ''
          local luasnip = require'luasnip';
          local s = luasnip.snippet;
          local sn = luasnip.snippet_node;
          local t = luasnip.text_node;
          local i = luasnip.insert_node;
          local f = luasnip.function_node;
          local c = luasnip.choice_node;
          local d = luasnip.dynamic_node;
          local r = luasnip.restore_node;

          luasnip.add_snippets("tex", 
          {
            s("\\start", {t({ "\\documentclass[a4paper]{article}", 
            "\\usepackage{alltt, amssymb, listings, todonotes}",
            "\\begin{document}", 
            "\\section*{ - \\today}", "",}), 
            i(1), 
            t({"", 
            "\\end{document}",}), 
            }),

            s("\\verbatim", {t({ "\\begin{verbatim}", "" }),
            i(1), 
            t({"", 
            "\\end{verbatim}",}), 
          }),

          s("\\alltt", {t({ "\\begin{alltt}", "" }),
          i(1), 
          t({"", 
          "\\end{alltt}",}), 
        }), 

        s("\\itemize", {t({ "\\begin{itemize}", "" }),
        t("\\item "), i(1), 
        t({"", 
        "\\end{itemize}",}), 
      }),

      s("\\enumerate", {t({ "\\begin{enumerate}", "" }),
      t("\\item "), i(1), 
      t({"", 
      "\\end{enumerate}",}), 
    }),

    s("\\lstlisting", {t({ "%\\lstset{language=C}", "\\begin{lstlisting}", "" }),
    i(1), 
    t({"", 
    "\\end{lstlisting}",}), 
  }),

  --text
  s("\\dc", { t("\\documentclass{"), i(1), t("}"), }),
  s("\\bf", { t("\\textbf{"), i(1), t("}"), }),
  s("\\it", { t("\\textit{"), i(1), t("}"), }),
  s("\\section", { t("\\section{"), i(1), t("}"), }),
  s("\\todo", { t("\\todo{"), i(1), t("}"), }),

  s("\\red", { t("\\textcolor{red}{"), i(1), t("}"), }),
  s("\\green", { t("\\textcolor{green}{"), i(1), t("}"), }),
  s("\\blue", { t("\\textcolor{blue}{"), i(1), t("}"), }),
  s("\\gray", { t("\\textcolor{gray}{"), i(1), t("}"), }),
  s("\\pink", { t("\\textcolor{pink}{"), i(1), t("}"), }),

  -- math
  s("\\frac", { t("\\frac{"), i(1), t("}{"), i(2), t("}"), }),
            });
            '';
          }
          {
            plugin = cmp-nvim-lsp;
            type = "lua";
            config = ''
            -- mostly stolen from rafaelrc7's dotfile
            local lspconfig = require "lspconfig"
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- nix
            lspconfig.nil_ls.setup{

              cmd = { "${pkgs.nil}/bin/nil" },
              capabilities = capabilities,
            };

            -- html
            capabilities.textDocument.completion.completionItem.snippetSupport = true;
            lspconfig.html.setup {
              cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio"},
              capabilities = capabilities,
            };

            -- CSS
            lspconfig.cssls.setup {
              cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio"},
              capabilities = capabilities,
            };

            -- Json
            lspconfig.jsonls.setup {
              cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio"},
              commands = {
                Format = {
                  function()
                  vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0});
                  end
                },
              },
              capabilities = capabilities,
            };

            -- Python (pyright)
            lspconfig.pyright.setup{
              cmd = {"${pkgs.pyright}/bin/pyright-langserver", "--stdio"},
              settings = {
                python = {
                  analysis = {
                    extraPaths = {".", "src"},
                  },
                },
              },
              capabilities = capabilities,
            };

            -- Lua
            lspconfig.lua_ls.setup {
              cmd = {"${pkgs.sumneko-lua-language-server}/bin/lua-language-server"},
              settings = {
                Lua = {
                  runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  -- Do not send telemetry data containing a randomized but unique identifier
                  telemetry = {
                    enable = false,
                  },
                },
              },
              capabilities = capabilities,
            }
            '';
          }
          { plugin = cmp-buffer; }
          { plugin = cmp-path; }
          { plugin = cmp-cmdline; }
          { plugin = cmp_luasnip; }
          {
            plugin = nvim-cmp;
            type = "lua";
            config = ''
            local cmp = require'cmp';
            cmp.setup({
              snippet = {
                expand = function(args)
                luasnip.lsp_expand(args.body)
                end
              };
              window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              };
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              });
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
              });
            });
            '';
          }
          { plugin = vim-nix; }
          {
            plugin = vimtex;
            config = ''
            let g:vimtex_view_method = 'zathura'
            autocmd User VimtexEventQuit VimtexClean
            nnoremap <F4> :NvimTreeToggle<CR>
            nnoremap <F5> :VimtexCompile<CR>
            nnoremap <F6> :VimtexStop<CR>:VimtexClean<CR>
            '';
          }
          { plugin = img-clip-nvim; }
          { plugin = markview-nvim; }
          { plugin = comment-nvim; }
          { 
            plugin = lualine-nvim;
            type = "lua";
            config = ''
            require("lualine").setup {
              options = {
                icons_enabled = true,
                theme = "auto",
              },
            }
            '';
          }
          {
            plugin = plenary-nvim;
          }
          {
            plugin = codecompanion-nvim;
            type = "lua";
            config = ''
            require("codecompanion").setup {
              opts = {
                log_level = "DEBUG", -- or "TRACE"
              },
              strategies = {
                chat = {
                  adapter = "gemini",
                },
                inline = {
                  adapter = "gemini",
                },
                ollama = {
                  adapter = "ollama",
                  model = "meditron:latest",
                },
              },
              gemini = function()
              return require("codecompanion.adapters").extend("gemini", {
                schema = {
                  model = {
                    default = "gemini-2.0-flash-exp",
                  },
                },
                env = {
                  api_key = "GEMINI_API_KEY",
                },
              })
              end,
              ollama = function()
              return require("codecompanion.adapters").extend("ollama", {
                schema = {
                  model = {
                    default = "meditron:latest",
                  },
                },
              })
              end,
              display = {
                diff = {
                  provider = "mini_diff",
                },
              },
            }
            '';
          }
          {
            plugin  = telescope-nvim;
          }
          {
            plugin = oil-nvim;
          }
          {
            plugin = none-ls-nvim;
          }
          {
            plugin = dashboard-nvim;
          }
        ];
        extraConfig = ''
        set number relativenumber
        set mouse=a
        '';
      };
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
