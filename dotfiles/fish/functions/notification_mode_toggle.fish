function notification_mode_toggle
  set IS_PAUSED $(dunstctl is-paused)
  if $IS_PAUSED
    dunstctl set-paused false
    dunstify "Notifications On"
  else
    dunstify "Notifications Off"
    sleep 5
    dunstctl set-paused true
  end
end
