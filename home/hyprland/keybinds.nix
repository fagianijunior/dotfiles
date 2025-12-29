{
  bind = [
    "$mainMod, TAB, exec, "
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
    "$mainMod, J, togglesplit,"
    "$mainMod, L, exec, hyprlock"
    "$mainMod ALT, M, exit,"
    "$mainMod, P, pseudo,"
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
}