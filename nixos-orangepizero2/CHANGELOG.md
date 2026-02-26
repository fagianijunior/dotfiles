# Changelog - Orange Pi Zero 2

Histórico de mudanças na configuração do Orange Pi Zero 2.

## [2026-02-26] - Tailscale VPN

### Adicionado

#### Tailscale
- Habilitado serviço Tailscale no Orange Pi Zero 2
- Configuração como servidor (useRoutingFeatures = "server")
- Interface tailscale0 como trusted no firewall
- Porta UDP do Tailscale aberta automaticamente

#### Documentação
- `docs/tailscale-setup.md`: Guia completo do Tailscale
  - Configuração inicial
  - MagicDNS
  - Exit node
  - Subnet router
  - ACLs
  - Integração com Taskwarrior
  - Troubleshooting
  - ~400 linhas

#### README Atualizado
- Seção sobre Tailscale VPN
- Comandos de configuração
- Uso com Taskwarrior via Tailscale

#### Segurança
- Atualizado guia de segurança com Tailscale como opção recomendada
- Comparação entre Tailscale e outras soluções VPN

### Características

- ✅ Acesso remoto seguro de qualquer lugar
- ✅ Zero configuração de port forwarding
- ✅ Criptografia WireGuard
- ✅ NAT traversal automático
- ✅ MagicDNS para usar hostnames
- ✅ Pode funcionar como exit node
- ✅ Pode rotear subnet local

### Benefícios para Taskwarrior

- Sincronizar de qualquer lugar (casa, trabalho, viagem)
- Sem expor porta 8080 na internet pública
- IP estável (não muda)
- Funciona em redes restritivas
- Latência baixa (conexão direta quando possível)

## [2026-02-26] - Taskchampion Sync Server

### Adicionado

#### Módulo do Servidor
- Criado módulo NixOS para taskchampion-sync-server (`modules/taskchampion-sync-server.nix`)
- Configuração declarativa com opções:
  - `enable`: Habilitar/desabilitar serviço
  - `port`: Porta do servidor (padrão: 8080)
  - `address`: Endereço de bind (padrão: 0.0.0.0)
  - `dataDir`: Diretório de dados (padrão: /var/lib/taskchampion-sync-server)
  - `openFirewall`: Abrir porta no firewall automaticamente
- Usuário e grupo dedicados (`taskchampion:taskchampion`)
- Serviço systemd com restart automático
- Permissões e segurança configuradas (NoNewPrivileges, ProtectSystem, etc)

#### Configuração do Orange Pi
- Habilitado taskchampion-sync-server em `orangepizero2.nix`
- Porta 8080 aberta no firewall
- Servidor escutando em todas as interfaces (0.0.0.0)

#### Scripts e Ferramentas
- `scripts/test-taskchampion.sh`: Script completo de teste e diagnóstico
  - Verifica status do serviço
  - Testa conectividade
  - Valida permissões
  - Mostra logs recentes
  - Fornece informações de configuração

#### Documentação
- `TASKWARRIOR-SETUP.md`: Guia completo de instalação
- `docs/taskwarrior-sync-setup.md`: Setup detalhado do cliente e servidor
- `docs/taskwarrior-security.md`: Guia de segurança e boas práticas
  - Configuração de firewall por IP
  - Túnel SSH
  - VPN (Tailscale/WireGuard)
  - Reverse proxy com HTTPS
  - Backup automático
- `docs/taskwarrior-troubleshooting.md`: Resolução de problemas
  - Problemas comuns e soluções
  - Comandos de diagnóstico
  - Modo debug
  - Reset completo
- `docs/taskwarrior-quick-reference.md`: Referência rápida
  - Comandos essenciais
  - Configurações
  - Atalhos úteis

#### Integração Home-Manager
- `home/taskwarrior/sync-config.nix`: Configuração básica do cliente
  - Configuração automática do taskrc
  - Scripts helper (task-sync-init, task-sync-status)
  - Suporte a múltiplos dispositivos
- `home/taskwarrior/sync-services.nix`: Serviços avançados
  - Sincronização automática (timer systemd)
  - Túnel SSH automático (opcional)
  - Backup automático diário
  - Verificação de conectividade
  - Notificações de erro
  - Scripts adicionais (task-sync-now, task-sync-services, task-sync-toggle)
- `home/taskwarrior/SYNC-README.md`: Guia de configuração do cliente

#### README Atualizado
- Seção sobre Taskchampion Sync Server
- Instruções de configuração do cliente
- Links para documentação completa
- Comandos de verificação e teste

### Características Técnicas

#### Servidor
- Pacote: `taskchampion-sync-server` (versão 0.7.1)
- Porta: 8080 (HTTP)
- Protocolo: HTTP (sem autenticação nativa)
- Armazenamento: Arquivo local em `/var/lib/taskchampion-sync-server/`
- Arquitetura: ARM64 (aarch64-linux)

#### Segurança
- Usuário dedicado sem privilégios
- Proteção do sistema de arquivos
- Firewall configurável
- Suporte a túnel SSH
- Suporte a VPN
- Suporte a reverse proxy com HTTPS

#### Backup
- Diretório de dados: `/var/lib/taskchampion-sync-server/`
- Backup manual via tar
- Backup automático via systemd timer (opcional)
- Retenção configurável

#### Monitoramento
- Logs via journalctl
- Status via systemctl
- Script de teste automatizado
- Verificação de conectividade

### Compatibilidade

- Taskwarrior 3.x
- NixOS 25.11+
- Home-Manager (qualquer versão recente)
- Múltiplos clientes simultâneos
- Múltiplos dispositivos por usuário

### Próximos Passos Sugeridos

- [ ] Configurar backup automático
- [ ] Adicionar monitoramento com alertas
- [ ] Configurar HTTPS com Caddy
- [ ] Adicionar autenticação via reverse proxy
- [ ] Integrar com sistema de backup existente
- [ ] Adicionar métricas (Prometheus/Grafana)

## [Anterior] - Configuração Base

### Adicionado
- Configuração inicial do Orange Pi Zero 2
- Suporte a ARM64
- Docker + Docker Compose
- SSH habilitado
- Módulos base-server e server-profile
- Hardware configuration para SD card
- Swap de 2GB
- README com instruções de deploy

### Características
- Headless (sem interface gráfica)
- Ethernet via interface end0
- IPv6 desabilitado
- systemd-resolved para DNS
- Kernel Linux 6.2+
