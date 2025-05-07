{ pkgs, lib, ... }:
{
  environment = {
    # Common packages
    systemPackages = with pkgs; [
      # Development
      devenv
      sumneko-lua-language-server
      nil
      gcc
      ruby-lsp
      typescript-language-server
      terraform-ls
      awscli2
      ssm-session-manager-plugin
      (python312.withPackages (python-pkgs: with python-pkgs; [
        # select Python packages here
        psutil
        textual
        pydbus
      ]))
      dbus
      gnumake
      libffi
      zlib
      openssl
      pkg-config
      autoconf
      automake
      bison

      # Version Control
      git
      lazygit
      delta
      license-generator
      git-ignore
      gitleaks
      git-secrets
      pass-git-helper

      # Utilities
      ncdu
      wget
      curl
      tmux
      htop
      tree
      fmt
      gnupg
      usbutils
      wtype
      wlrctl
      xdg-utils
      trash-cli
      zoxide
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
      just
      xh
      process-compose
      zellij
      progress
      noti
      topgrade
      ripgrep
      rewrk
      wrk2
      procs
      tealdeer
      monolith
      aria
      sd
      ouch
      duf
      du-dust
      fd
      jq
      gh
      
      # file managers
      ranger
      file
      upx
      yazi

      # Multimidea
      pamixer
      pavucontrol
      ffmpeg_6-full
      wl-screenrec
      slurp
      imagemagick
      swappy
      gifsicle
      cava
      
      # chat
      tdesktop
      clickup
      (slack.overrideAttrs
        (default: {
          installPhase = default.installPhase + ''
rm $out/bin/slack

makeWrapper $out/lib/slack/slack $out/bin/slack \
--prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
--prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
--add-flags "--enable-features=WebRTCPipeWireCapturer"
          '';
        })
      )

      # remote access
      remmina

      # images
      gimp
      imv             # image viewer. https://github.com/Elvysia/imv
      zathura         # pdf viewer. https://pwmt.org/projects/zathura/

      # Containers
      buildpack
      # terraform
      distrobox
      qemu

      # Fonts
      jetbrains-mono
      nerd-font-patcher
      noto-fonts-color-emoji
      powerline-fonts

      # Hyprland
      pyprland        # A tool to manage your wayland compositor. https://github.com/Elvysia/pyprland
      hyprpicker      # Color picker
      hyprcursor      # Cursor manager. https://github.com/Elvysia/hyprcursor
      hyprlock        # Lock screen. https://github.com/Elvysia/hyprlock
      hypridle        # Idle manager. https://github.com/Elvysia/hypridle
      hyprpolkitagent # Polkit
      hyprls          # Language server. https://github.com/Elvysia/hyprls
      rofi-wayland
      dunst

      # Speel Checking
      nuspell
      hyphen
      hunspell
      hunspellDicts.pt_BR
      hunspellDicts.en_US

      # Password
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

      # Miscellaneous
      at-spi2-atk
      qt6.qtwayland
      psi-notify
      poweralertd
      playerctl
      psmisc
      grim
      wl-clipboard
      wl-clip-persist
      cliphist
      avizo

      # Theme
      numix-icon-theme-circle
      # colloid-icon-theme
      catppuccin-gtk
      catppuccin-kvantum
      catppuccin-cursors.macchiatoTeal

      # Hyprland
      wlsunset        # Night gamma. https://github.com/Elvysia/wlsunset
      brightnessctl   # Brightness control. https://github.com/Elvysia/brightnessctl

      # Games
      # support both 32- and 64-bit applications
      wineWowPackages.stable
      # winetricks (all versions)
      winetricks
      lutris
      # native wayland support (unstable)
      wineWowPackages.waylandFull

      # System
      mldonkey
      wezterm
      vorta
      unzip
      zip
      gparted
      biber
      xfce.thunar-volman
      f2fs-tools
      
      # Appearance
      wofi
      chafa
      cmatrix
      pipes-rs
      rsclock
      tree-sitter

      # Shell completion, neeed to be configured with your shell. https://github.com/starship/starship/
      starship

      wlogout
      tokei
      figlet
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
