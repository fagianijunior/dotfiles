{ pkgs, ... }: {
  environment = {
    variables = {
      GTK_THEME = "catppuccin-macchiato-teal-standard";
      XCURSOR_THEME = "Catppuccin-Macchiato-Teal";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "Catppuccin-Macchiato-Teal";
      HYPRCURSOR_SIZE = "24";

      EDITOR = "nvim";
      #GEMINI_API_KEY = GEMINI_API_KEY;
    };
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}

