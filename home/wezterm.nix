{ ... }:

{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- Shell
      config.default_prog = { "fish" }

      -- Fonte
      config.font = wezterm.font_with_fallback {
        "JetBrains Mono Nerd Font",
      }
      config.font_size = 11.5

      -- Tema
      config.color_scheme = "Catppuccin Macchiato"
      config.window_background_opacity = 0.60

      -- Tabs
      config.hide_tab_bar_if_only_one_tab = true
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = true

      -- Layout
      config.enable_wayland = true
      config.window_padding = {
        left = 6,
        right = 6,
        top = 6,
        bottom = 6,
      }

      -- Scroll
      config.scrollback_lines = 10000

      -- Keybindings
      config.keys = {
        { key = "d", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal },
        { key = "s", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical },

        { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Left" },
        { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Right" },
        { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Up" },
        { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Down" },

        { key = "q", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane { confirm = true } },
      }

      return config
    '';
  };
}
