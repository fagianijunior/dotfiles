{
  exec-once = [
    "pypr"
    "hyprpaper"
    "hypridle"
    "poweralertd"
    "avizo-service"
    "systemctl --user start psi-notify"
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
    "fish -c autostart"
    "[workspace 1] $browser"
    "[workspace 3] clickup"
    "[workspace 3] slack"
    "systemctl --user start hyprpolkitagent"
  ];
}
