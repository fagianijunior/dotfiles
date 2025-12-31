{ pkgs, ... }:

{
  security.pam.services.hyprlock = {};

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.xwayland.enable = true;
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  programs.light.enable = true;

  programs.fish.enable = true;
  
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user = "greeter";
    };
  };
}
