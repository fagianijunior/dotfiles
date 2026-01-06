{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Audio/Video
    cava
    pamixer
    pavucontrol
    ffmpeg_6-full
    
    # Image/Video editing
    gifsicle
    imagemagick
    shotcut
    
    # Screen capture
    grim
    slurp
    swappy
    wl-screenrec
    
    # Image viewer
    imv
    
    # Chat/Communication
    slack
    clickup
    telegram-desktop
    nchat
  ];
}