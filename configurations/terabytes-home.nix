{ pkgs, config, home-manager, ... }:

{
  nixpkgs = {
    # You can add overlays here
    # overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    # ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "terabytes";
    homeDirectory = "/home/terabytes";
    stateVersion = "24.11";
  };

  # Configuração do shell Fish
  programs.fish = {
    enable = true;
    loginShell = true;
    promptInit = ''
      # Customização opcional do prompt
      set_color cyan; echo "Welcome to Fish Shell"
    '';
    # Plugins e configuração inicial
    # plugins = with pkgs.fishPlugins; [
    #   z
    #   fish-nvm
    #   bobthefish
    # ];
  };

  # Exemplo de configuração do Hyprland
  xdg.configFile."hypr/hyprland.conf".source = ../../dotfiles/hypr/hyprland.conf;

  programs = {
    git = {
      enable = true;
      userName = "Terabytes User";
      userEmail = "terabytes@example.com";
    };
  };

  # Instalação de pacotes para uso geral
  home.packages = with pkgs; [
    htop
    neovim
    ripgrep
    fzf
    starship # Prompt customizado
    hyprland # Instalação do Hyprland
    waybar   # Barra de status para Hyprland
    rofi     # Launcher de aplicativos
    grim     # Screenshot tool para Wayland
    slurp    # Seleção de área para screenshots
    swaybg   # Background para Hyprland
  ];
}
