{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Development Tools
    gcc
    bash
    dbus
    zlib
    bison
    gnumake
    openssl
    autoconf
    automake
    pkg-config
    gobject-introspection
    
    # Language Servers
    ruby-lsp
    typescript-language-server
    lua-language-server
    
    # Version Control
    git
    delta
    lazygit
    gitleaks
    git-ignore
    git-secrets
    pass-git-helper
    license-generator
    
    # Development Environment
    devenv
    libffi
    kdePackages.qtdeclarative
    
    # AWS Tools
    ssm-session-manager-plugin
    
    # Python with packages
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        hidapi
        psutil
        pydbus
        textual
        requests
        dbus-next
        pygobject3
        tkinter
        google-api-python-client
        google-auth-oauthlib
        google-auth
        gssapi
      ]
    ))
  ];
  
  # Docker for development
  virtualisation.docker = {
    enable = true;
  };
}