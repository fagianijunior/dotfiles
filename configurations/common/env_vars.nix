{ pkgs, ... }: {

  environment.etc."secrets/gemini-api-key".source = /etc/secrets/gemini-api-key;
  
  environment = {
    variables = {
      GTK_THEME = "catppuccin-macchiato-teal-standard";
      XCURSOR_THEME = "Catppuccin-Macchiato-Teal";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "Catppuccin-Macchiato-Teal";
      HYPRCURSOR_SIZE = "24";

      EDITOR = "nvim";
      GEMINI_API_KEY = "${pkgs.lib.fileContents /etc/secrets/gemini-api-key}";
    };
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}

