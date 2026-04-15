{ pkgs, ... }:

{
  security.pam.services.hyprlock = { };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.xwayland.enable = true;
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  programs.fish.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
      user = "greeter";
    };
  };
}
