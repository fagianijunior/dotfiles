# NixOS Configuration - Doraemon & Nobita

Configuração NixOS para dois dispositivos AMD com Wayland/Hyprland.

## Dispositivos

- **Nobita** (Desktop): Configuração para desktop com foco em performance e gaming
- **Doraemon** (Notebook): Configuração otimizada para laptop com gerenciamento de energia
- **Orange Pi Zero 2** (Servidor): Servidor ARM headless com Docker e Taskchampion Sync Server

## Estrutura

```
├── flake.nix                 # Configuração principal do flake
├── hosts/                    # Configurações específicas por dispositivo
│   ├── nobita.nix           # Desktop
│   ├── doraemon.nix         # Notebook
│   └── quirks/              # Correções específicas de hardware
├── nixos-orangepizero2/     # Configuração do Orange Pi Zero 2
│   ├── orangepizero2.nix    # Configuração principal
│   ├── modules/             # Módulos específicos (taskchampion, etc)
│   ├── docs/                # Documentação detalhada
│   └── scripts/             # Scripts de teste e manutenção
├── modules/
│   ├── base/                # Configurações base do sistema
│   ├── desktop/             # Ambiente desktop (Hyprland, Pipewire)
│   ├── hardware/            # Drivers e configurações de hardware
│   └── profiles/            # Perfis modulares de software
├── home/                    # Configurações do Home Manager
│   └── taskwarrior/         # Configuração do Taskwarrior com sync
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

### Orange Pi Zero 2 (Servidor)
- Arquitetura: ARM64 (aarch64-linux)
- Headless (sem interface gráfica)
- Docker + Docker Compose
- Taskchampion Sync Server (porta 8080)
- SSH habilitado
- Swap de 2GB configurado

## Uso

### Makefile - Automação de Tarefas

O Makefile fornece uma interface simplificada para gerenciar a configuração NixOS, automatizando comandos comuns e detectando automaticamente o hostname atual.

#### Comandos Principais

```bash
make help           # Mostra todos os comandos disponíveis
make build          # Build para o hostname atual
make check          # Verifica configuração sem aplicar
make update         # Atualiza flake e faz build
make boot           # Aplica na próxima inicialização
make rollback       # Volta para geração anterior
```

#### Comandos Específicos por Host

```bash
make build-nobita     # Build para desktop
make build-doraemon   # Build para notebook
make check-nobita     # Verifica desktop
make check-doraemon   # Verifica notebook
```

#### Utilitários

```bash
make diff           # Compara configurações entre hosts
make diff-modules   # Compara apenas módulos
make diff-packages  # Mostra pacotes únicos por host
make clean          # Remove arquivos temporários
make gc             # Garbage collection do Nix
make optimize       # Otimiza Nix store
make status         # Mostra informações do sistema
```

### Build Manual do Sistema
```bash
sudo nixos-rebuild switch --flake .#nobita       # Desktop
sudo nixos-rebuild switch --flake .#doraemon     # Notebook
sudo nixos-rebuild switch --flake .#orangepizero2 # Orange Pi
```

### Atualização Manual
```bash
nix flake update
sudo nixos-rebuild switch --flake .#<hostname>
```

### Orange Pi Zero 2

Para configuração e uso do servidor:

```bash
# Build e deploy
sudo nixos-rebuild switch --flake .#orangepizero2

# Testar instalação
./nixos-orangepizero2/scripts/test-taskchampion.sh
```

Documentação completa:
- [📖 Setup do Taskwarrior Sync](./nixos-orangepizero2/TASKWARRIOR-SETUP.md)
- [📚 README do Orange Pi](./nixos-orangepizero2/README.md)

### Home Manager
As configurações do usuário são gerenciadas automaticamente via Home Manager integrado ao flake.

## Características

- **Wayland**: Interface gráfica moderna com Hyprland
- **Pipewire**: Sistema de áudio de baixa latência
- **Catppuccin**: Tema consistente em todo o sistema
- **Segurança**: USBGuard, Fail2ban, SSH configurado
- **Desenvolvimento**: Docker, linguagens e LSPs
- **Modularidade**: Fácil adição/remoção de funcionalidades
- **Taskwarrior Sync**: Servidor de sincronização no Orange Pi Zero 2
- **Tailscale VPN**: Acesso remoto seguro em todos os dispositivos
- **Multi-arquitetura**: Suporte para x86_64 e ARM64

## Taskwarrior Sync

Todos os hosts (Nobita, Doraemon e Orange Pi Zero 2) estão configurados para sincronização do Taskwarrior:

- **Servidor**: Orange Pi Zero 2 (porta 8080)
- **Clientes**: Nobita (desktop) e Doraemon (notebook)
- **Acesso**: Via Tailscale VPN (MagicDNS)
- **UUIDs únicos**: Configurados automaticamente por dispositivo

### Primeiros Passos

```bash
# 1. Rebuild do sistema
sudo nixos-rebuild switch

# 2. Conectar ao Tailscale
sudo tailscale up

# 3. Verificar configuração
task-sync-info

# 4. Inicializar sincronização (primeira vez)
task-sync-init

# 5. Sincronizar
task sync
```

Consulte [docs/TASKWARRIOR-CLIENT-SETUP.md](./docs/TASKWARRIOR-CLIENT-SETUP.md) para detalhes completos.