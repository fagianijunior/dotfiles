{ ... }:
{
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
}
