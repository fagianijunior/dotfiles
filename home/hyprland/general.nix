{
  general = {
    gaps_in     = 3;
    gaps_out    = 3;

    border_size = 2;

    "col.active_border"   = "rgb(94e2d5)";  # teal
    "col.inactive_border" = "rgb(313244)";  # surface1

    resize_on_border = true;
    allow_tearing = false;
    layout = "dwindle";
  };

  misc = {
    force_default_wallpaper   = -1;
    disable_splash_rendering  = true;
    disable_hyprland_logo     = true;
    background_color = "0x1e1e2e"; # base
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
    pseudotile      = true;
    preserve_split  = true;
    smart_split     = true;
  };
}