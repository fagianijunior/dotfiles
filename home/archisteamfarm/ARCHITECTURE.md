# ArchiSteamFarm - Arquitetura

## Visão Geral

```
┌─────────────────────────────────────────────────────────────┐
│                         Host: Nobita                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  Sistema (NixOS)                                      │ │
│  │  modules/profiles/gaming.nix                          │ │
│  │                                                       │ │
│  │  • Instala pacote: archisteamfarm                    │ │
│  │  • Disponível em: /nix/store/.../bin/ArchiSteamFarm │ │
│  └───────────────────────────────────────────────────────┘ │
│                           │                                 │
│                           ▼                                 │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  Usuário (home-manager)                               │ │
│  │  home/archisteamfarm/default.nix                      │ │
│  │                                                       │ │
│  │  • Cria: ~/.config/ArchiSteamFarm/                   │ │
│  │  • Gera: config/ASF.json                             │ │
│  │  • Configura: systemd user service                   │ │
│  └───────────────────────────────────────────────────────┘ │
│                           │                                 │
│                           ▼                                 │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  Runtime (systemd --user)                             │ │
│  │  archisteamfarm.service                               │ │
│  │                                                       │ │
│  │  • Executa como: terabytes                           │ │
│  │  • WorkDir: ~/.config/ArchiSteamFarm/                │ │
│  │  • Interface: http://localhost:1242                  │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Separação de Responsabilidades

### Nível Sistema (gaming.nix)
- **Responsabilidade**: Instalar o binário do ArchiSteamFarm
- **Escopo**: System-wide (disponível para todos os usuários)
- **Localização**: `modules/profiles/gaming.nix`
- **Por quê aqui?**: 
  - Relacionado ao Steam (já instalado no mesmo módulo)
  - Usado apenas no Nobita (gaming.nix só é importado no nobita.nix)
  - Mantém organização lógica (tudo de gaming junto)

### Nível Usuário (home-manager)
- **Responsabilidade**: Configurar o ASF para o usuário específico
- **Escopo**: User-specific (apenas para terabytes)
- **Localização**: `home/archisteamfarm/default.nix`
- **Por quê aqui?**:
  - Configurações pessoais (credenciais Steam)
  - Serviço roda como usuário (não root)
  - Dados em ~/.config (padrão XDG)

## Fluxo de Dados

```
1. nixos-rebuild switch
   │
   ├─> Sistema: Instala archisteamfarm
   │
   └─> Home-manager: 
       ├─> Cria ~/.config/ArchiSteamFarm/
       ├─> Gera config/ASF.json
       └─> Registra systemd user service

2. systemctl --user start archisteamfarm
   │
   └─> Inicia serviço como usuário
       ├─> Lê: ~/.config/ArchiSteamFarm/config/ASF.json
       ├─> Lê: ~/.config/ArchiSteamFarm/config/*.json (bots)
       ├─> Escreve: ~/.config/ArchiSteamFarm/logs/
       ├─> Escreve: ~/.config/ArchiSteamFarm/database/
       └─> Abre: http://localhost:1242 (IPC)

3. Usuário configura bots
   │
   └─> Cria: ~/.config/ArchiSteamFarm/config/MeuBot.json
       └─> ASF detecta e carrega automaticamente
```

## Vantagens desta Arquitetura

### 1. Separação Clara
- Sistema gerencia binários
- Usuário gerencia configurações
- Nenhuma mistura de responsabilidades

### 2. Segurança
- Serviço roda como usuário (não root)
- Credenciais ficam em ~/.config (protegidas)
- PrivateTmp e NoNewPrivileges habilitados

### 3. Manutenibilidade
- Fácil de entender onde cada coisa está
- Atualização do pacote: apenas gaming.nix
- Mudança de config: apenas home/archisteamfarm/

### 4. Organização Lógica
- Gaming-related: tudo em gaming.nix
- User-specific: tudo em home/archisteamfarm/
- Segue convenções NixOS

## Comparação com Outras Abordagens

### ❌ Tudo no home-manager
```nix
# Ruim: duplica instalação do pacote
home.packages = [ pkgs.archisteamfarm ];
```
- Problema: Pacote já está em gaming.nix
- Resultado: Redundância desnecessária

### ❌ Tudo no sistema
```nix
# Ruim: configurações de usuário no sistema
systemd.services.archisteamfarm = { ... };
```
- Problema: Serviço rodaria como root ou usuário específico
- Resultado: Menos flexível e menos seguro

### ✅ Abordagem Atual (Híbrida)
```nix
# gaming.nix: pacote
environment.systemPackages = [ pkgs.archisteamfarm ];

# home/archisteamfarm/default.nix: configuração
systemd.user.services.archisteamfarm = { ... };
```
- Vantagem: Melhor de ambos os mundos
- Resultado: Limpo, seguro, manutenível

## Arquivos de Configuração

### Gerenciados pelo Nix
- `~/.config/ArchiSteamFarm/config/ASF.json` (gerado automaticamente)

### Gerenciados pelo Usuário
- `~/.config/ArchiSteamFarm/config/*.json` (bots)
- Não são tocados pelo Nix
- Podem ser editados livremente
- Protegidos pelo .gitignore

## Conclusão

Esta arquitetura segue as melhores práticas do NixOS:
- Sistema gerencia software
- Usuário gerencia dados
- Separação clara de responsabilidades
- Segurança por design
- Fácil manutenção
