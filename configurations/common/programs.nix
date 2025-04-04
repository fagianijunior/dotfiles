{ pkgs, lib, ... }:
{
  environment = {
    variables = {
      EDITOR = "nvim";
    };
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };

    # Common packages
    systemPackages = with pkgs; [
      sumneko-lua-language-server
      mldonkey
      git
      wezterm
      vorta
      unzip
      zip
      gparted

      biber
      wget
      curl
      tmux
      htop
      tree
      nil
      nixpkgs-fmt

      # sound
      pamixer
      pavucontrol
      xfce.thunar-volman

      wofi

      tree-sitter
      # file managers
      ranger

      # chat
      tdesktop

      # remote access
      remmina

      # images
      gimp
      imv             # image viewer. https://github.com/Elvysia/imv
      zathura         # pdf viewer. https://pwmt.org/projects/zathura/

      # development
      awscli2
      ssm-session-manager-plugin
      buildpack
      # terraform
      distrobox
      qemu
      gcc
      ruby
      ruby-lsp
      rubyPackages.prism 

      # USB
      usbutils

      # fonts
      jetbrains-mono
      nerd-font-patcher
      noto-fonts-color-emoji
      powerline-fonts

      # brightness control
      wlsunset        # Night gamma. https://github.com/Elvysia/wlsunset
      brightnessctl   # Brightness control. https://github.com/Elvysia/brightnessctl

      # Shell completion, neeed to be configured with your shell. https://github.com/starship/starship/
      starship

      # Hyprland
      pyprland        # A tool to manage your wayland compositor. https://github.com/Elvysia/pyprland
      hyprpicker      # Color picker
      hyprcursor      # Cursor manager. https://github.com/Elvysia/hyprcursor
      hyprlock        # Lock screen. https://github.com/Elvysia/hyprlock
      hypridle        # Idle manager. https://github.com/Elvysia/hypridle
      hyprpolkitagent # Polkit
      hyprls          # Language server. https://github.com/Elvysia/hyprls

      waybar          # Waybar. https://github.com/Alexays/Waybar

      # spell check
      nuspell
      hyphen
      hunspell
      hunspellDicts.pt_BR
      hunspellDicts.en_US

      # boot
      # policycoreutils

      # passphrase2pgp
      pass-wayland
      pass2csv
      passExtensions.pass-tomb
      passExtensions.pass-update
      passExtensions.pass-otp
      passExtensions.pass-import
      passExtensions.pass-audit
      tomb
      pwgen
      pwgen-secure

      # misselaneous
      at-spi2-atk
      qt6.qtwayland
      psi-notify
      poweralertd
      playerctl
      psmisc
      grim
      slurp
      imagemagick
      swappy
      ffmpeg_6-full
      wl-screenrec
      wl-clipboard
      wl-clip-persist
      cliphist
      xdg-utils
      wtype
      wlrctl
      rofi-wayland
      dunst
      avizo
      wlogout
      gifsicle

      # games
      # support both 32- and 64-bit applications
      wineWowPackages.stable
      # winetricks (all versions)
      winetricks
      lutris
      # native wayland support (unstable)
      wineWowPackages.waylandFull

      # terminal utils
      file
      upx
      git
      lazygit
      delta
      license-generator
      git-ignore
      gitleaks
      git-secrets
      pass-git-helper
      just
      xh
      process-compose
      # mcfly # terminal history
      zellij
      progress
      noti
      topgrade
      ripgrep
      rewrk
      wrk2
      procs
      tealdeer
      # skim #fzf better alternative in rust
      monolith
      aria
      # macchina #neofetch alternative in rust
      sd
      ouch
      duf
      du-dust
      fd
      jq
      gh
      trash-cli
      zoxide
      tokei
      fzf
      bat
      hexyl
      mdcat
      pandoc
      lsd
      lsof
      gping
      viu
      tre-command
      yazi
      chafa

      cmatrix
      pipes-rs
      rsclock
      cava
      figlet

      # themes
      numix-icon-theme-circle
      # colloid-icon-theme
      catppuccin-gtk
      catppuccin-kvantum
      catppuccin-cursors.macchiatoTeal

      # gnome.gnome-tweaks
      # gnome.gnome-shell
      # gnome.gnome-shell-extensions
      # xsettingsd
      # themechanger
    ];
  };

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = [];
    dconf.enable = true;
    thunar.enable = true;
    xfconf.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    light.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    fish = {
      enable = true;
    };

    mtr.enable = true;
  };
}
