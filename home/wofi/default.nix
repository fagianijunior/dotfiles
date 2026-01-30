{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    
    settings = {
      # Window settings
      width = 800;
      height = 600;
      location = "center";
      show = "drun";
      prompt = "Apps";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 48;
      gtk_dark = true;
      single_click = true;
      hide_scroll = true;
    };

    style = ''
      /* Catppuccin Macchiato theme for Wofi */
      
      window {
        margin: 0px;
        border: 2px solid #5b6078;
        background-color: #24273a;
        border-radius: 10px;
      }

      #input {
        margin: 5px;
        border: 2px solid #363a4f;
        color: #cad3f5;
        background-color: #1e2030;
        border-radius: 5px;
        padding: 10px;
        font-size: 14px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cad3f5;
        font-size: 14px;
      }

      #entry {
        background-color: transparent;
        margin: 2px;
        padding: 8px;
        border-radius: 5px;
      }

      #entry:selected {
        background-color: #94e2d5;
        color: #181926;
      }

      #entry:hover {
        background-color: #363a4f;
      }

      #text:selected {
        color: #181926;
      }
    '';
  };
}