{
  exec-once = [
    "pypr"
    "hyprpaper"
    "poweralertd"
    "avizo-service"
    "systemctl --user start psi-notify"
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
    "fish -c autostart"
    "[workspace 1] $browser"
    "[workspace 3] clickup"
    "[workspace 3] slack"
    "[workspace 3] Telegram"
    "systemctl --user start hyprpolkitagent"
  ];
}
