# NixOS Configuration - Doraemon & Nobita

Configuração NixOS para dois dispositivos AMD com Wayland/Hyprland.

## Dispositivos

- **Nobita** (Desktop): Configuração para desktop com foco em performance e gaming
- **Doraemon** (Notebook): Configuração otimizada para laptop com gerenciamento de energia

## Estrutura

```
├── flake.nix                 # Configuração principal do flake
├── hosts/                    # Configurações específicas por dispositivo
│   ├── nobita.nix           # Desktop
│   ├── doraemon.nix         # Notebook
│   └── quirks/              # Correções específicas de hardware
├── modules/
│   ├── base/                # Configurações base do sistema
│   ├── desktop/             # Ambiente desktop (Hyprland, Pipewire)
│   ├── hardware/            # Drivers e configurações de hardware
│   └── profiles/            # Perfis modulares de software
├── home/                    # Configurações do Home Manager
└── pkgs/                    # Pacotes customizados
```

## Perfis Modulares

### Base
- `base/`: Configurações essenciais (boot, usuários, rede, teclado)

### Hardware
- `hardware/amd-common.nix`: Drivers AMD comuns
- `hardware/graphics-amd.nix`: Configuração gráfica AMD

### Desktop
- `desktop/session.nix`: Configuração de sessão
- `desktop/hyprland.nix`: Window manager Hyprland
- `desktop/pipewire.nix`: Sistema de áudio

### Perfis de Software
- `profiles/workstation.nix`: Configurações base de workstation
- `profiles/development.nix`: Ferramentas de desenvolvimento
- `profiles/multimedia.nix`: Aplicações multimídia
- `profiles/utilities.nix`: Utilitários do sistema
- `profiles/gaming.nix`: Plataformas de jogos (apenas Nobita)
- `profiles/ai-services.nix`: Serviços de IA (apenas Nobita)
- `profiles/bluetooth.nix`: Configuração Bluetooth
- `profiles/logitech.nix`: Suporte a dispositivos Logitech

## Diferenças entre Dispositivos

### Nobita (Desktop)
- Governor de CPU: `performance`
- Inclui gaming (Steam, Heroic, etc.)
- Serviços de IA (Ollama, Qdrant)
- Otimizado para performance

### Doraemon (Notebook)
- Governor de CPU: `schedutil`
- Gerenciamento avançado de energia
- Suspend-then-hibernate no fechamento da tampa
- OBS Studio para criação de conteúdo
- Parâmetros de kernel específicos para laptop

## Uso

### Build do sistema
```bash
sudo nixos-rebuild switch --flake .#nobita    # Desktop
sudo nixos-rebuild switch --flake .#doraemon  # Notebook
```

### Atualização
```bash
nix flake update
sudo nixos-rebuild switch --flake .#<hostname>
```

### Home Manager
As configurações do usuário são gerenciadas automaticamente via Home Manager integrado ao flake.

## Características

- **Wayland**: Interface gráfica moderna com Hyprland
- **Pipewire**: Sistema de áudio de baixa latência
- **Catppuccin**: Tema consistente em todo o sistema
- **Segurança**: USBGuard, Fail2ban, SSH configurado
- **Desenvolvimento**: Docker, linguagens e LSPs
- **Modularidade**: Fácil adição/remoção de funcionalidades