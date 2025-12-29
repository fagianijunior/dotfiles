{
  exec-once = [
    "pypr"
    "hyprpaper"
    "hypridle"
    "poweralertd"
    "avizo-service"
    "systemctl --user start psi-notify"
    "fish -c autostart"
    "[workspace 1] $browser"
    "[workspace 3] clickup"
    "[workspace 3] slack"
    "systemctl --user start hyprpolkitagent"
  ];
}