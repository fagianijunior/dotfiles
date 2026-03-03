# Segurança e Melhores Práticas - Taskchampion Sync Server

Este documento descreve considerações de segurança e melhores práticas para o servidor de sincronização do Taskwarrior.

## Modelo de Ameaças

O taskchampion-sync-server **NÃO** possui autenticação ou criptografia nativa. Ele foi projetado para uso em redes locais confiáveis.

### Riscos

1. **Sem autenticação**: Qualquer pessoa na rede pode ler/modificar suas tarefas
2. **Sem criptografia**: Dados trafegam em texto claro
3. **Sem controle de acesso**: Não há separação entre usuários

## Cenários de Uso

### ✅ Seguro: Rede Local Doméstica

Se você usa apenas em casa, na sua rede WiFi privada:

- Risco: Baixo
- Recomendação: Configuração padrão é suficiente
- Proteção adicional: Firewall do roteador

```nix
services.taskchampion-sync-server = {
  enable = true;
  port = 8080;
  address = "0.0.0.0";  # OK para rede local
  openFirewall = true;
};
```

### ⚠️ Cuidado: Rede Compartilhada

Se você usa em rede compartilhada (escritório, universidade, etc):

- Risco: Médio
- Recomendação: Limitar acesso por IP
- Proteção adicional: VPN ou túnel SSH

```nix
services.taskchampion-sync-server = {
  enable = true;
  port = 8080;
  address = "127.0.0.1";  # Apenas localhost
  openFirewall = false;
};

# Usar túnel SSH para acessar
# ssh -L 8080:localhost:8080 orangepizero2
```

### ❌ Não Recomendado: Internet Pública

Não exponha diretamente à internet sem proteção adicional.

## Estratégias de Proteção

### 1. Firewall por IP (Simples)

Limitar acesso apenas aos seus dispositivos:

```nix
networking.firewall = {
  enable = true;
  allowedTCPPorts = [ ];  # Não abrir globalmente
  
  # Regras específicas
  extraCommands = ''
    # Permitir apenas IPs específicos
    iptables -A INPUT -p tcp --dport 8080 -s 192.168.1.10 -j ACCEPT  # Desktop
    iptables -A INPUT -p tcp --dport 8080 -s 192.168.1.20 -j ACCEPT  # Laptop
    iptables -A INPUT -p tcp --dport 8080 -j DROP  # Bloquear resto
  '';
};
```

### 2. Túnel SSH (Recomendado para redes não confiáveis)

Não abrir porta no firewall e usar SSH:

```nix
services.taskchampion-sync-server = {
  enable = true;
  port = 8080;
  address = "127.0.0.1";  # Apenas localhost
  openFirewall = false;   # Não abrir no firewall
};
```

No cliente, criar túnel:

```bash
# Criar túnel SSH
ssh -L 8080:localhost:8080 -N -f orangepizero2

# Configurar cliente para usar localhost
task config sync.server.origin http://localhost:8080
```

Automatizar com systemd:

```ini
# ~/.config/systemd/user/taskwarrior-tunnel.service
[Unit]
Description=SSH Tunnel for Taskwarrior Sync
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ssh -L 8080:localhost:8080 -N orangepizero2
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
```

### 3. VPN (Melhor para múltiplos serviços)

Use Tailscale, WireGuard ou outra VPN:

#### Opção A: Tailscale (Recomendado - Já instalado!)

O Tailscale já está configurado no Orange Pi. Basta autenticar:

```bash
# No Orange Pi
ssh orangepizero2
sudo tailscale up

# Seguir URL para autenticar no navegador
```

Configurar cliente:

```bash
# Instalar Tailscale no cliente
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Descobrir IP do Orange Pi
TAILSCALE_IP=$(ssh orangepizero2 'sudo tailscale ip -4')

# Configurar Taskwarrior
task config sync.server.origin http://$TAILSCALE_IP:8080
```

Vantagens:
- ✅ Zero configuração de firewall
- ✅ Funciona através de NAT
- ✅ Criptografia automática
- ✅ Acesso de qualquer lugar
- ✅ MagicDNS (usar hostname)

Consulte o [Guia do Tailscale](./tailscale-setup.md) para detalhes.

#### Opção B: WireGuard Manual

```nix
# Exemplo com WireGuard manual
services.wireguard = {
  enable = true;
  # ... configuração manual
};

services.taskchampion-sync-server = {
  enable = true;
  port = 8080;
  address = "10.0.0.1";  # IP do WireGuard
  openFirewall = false;
};

networking.firewall.interfaces."wg0".allowedTCPPorts = [ 8080 ];
```

### 4. Reverse Proxy com HTTPS (Para acesso externo)

Use Caddy ou nginx com certificado SSL:

```nix
services.caddy = {
  enable = true;
  virtualHosts."sync.seudominio.com".extraConfig = ''
    reverse_proxy localhost:8080
    
    # Autenticação básica (opcional)
    basicauth {
      usuario $2a$14$hash_bcrypt_aqui
    }
  '';
};

services.taskchampion-sync-server = {
  enable = true;
  port = 8080;
  address = "127.0.0.1";  # Apenas localhost
  openFirewall = false;
};

# Abrir apenas HTTPS
networking.firewall.allowedTCPPorts = [ 443 ];
```

## Backup e Recuperação

### Backup Automático

```nix
# Adicionar ao orangepizero2.nix
systemd.services.taskchampion-backup = {
  description = "Backup Taskchampion Data";
  serviceConfig = {
    Type = "oneshot";
    ExecStart = pkgs.writeShellScript "backup-taskchampion" ''
      #!/usr/bin/env bash
      BACKUP_DIR="/var/backup/taskchampion"
      DATA_DIR="/var/lib/taskchampion-sync-server"
      DATE=$(date +%Y%m%d-%H%M%S)
      
      mkdir -p "$BACKUP_DIR"
      tar -czf "$BACKUP_DIR/taskchampion-$DATE.tar.gz" -C "$DATA_DIR" .
      
      # Manter apenas últimos 30 backups
      ls -t "$BACKUP_DIR"/taskchampion-*.tar.gz | tail -n +31 | xargs -r rm
    '';
  };
};

systemd.timers.taskchampion-backup = {
  description = "Backup Taskchampion Timer";
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = "daily";
    Persistent = true;
  };
};
```

### Restaurar Backup

```bash
# Parar serviço
sudo systemctl stop taskchampion-sync-server

# Restaurar
sudo tar -xzf /var/backup/taskchampion/taskchampion-20260226.tar.gz -C /var/lib/taskchampion-sync-server/

# Corrigir permissões
sudo chown -R taskchampion:taskchampion /var/lib/taskchampion-sync-server/

# Reiniciar
sudo systemctl start taskchampion-sync-server
```

## Monitoramento

### Logs

```bash
# Ver logs em tempo real
sudo journalctl -u taskchampion-sync-server -f

# Logs das últimas 24h
sudo journalctl -u taskchampion-sync-server --since "24 hours ago"

# Erros apenas
sudo journalctl -u taskchampion-sync-server -p err
```

### Alertas

```nix
# Exemplo com systemd-notify
systemd.services.taskchampion-sync-server = {
  # ... configuração existente ...
  
  serviceConfig = {
    # Notificar se o serviço falhar
    OnFailure = "notify-failure@%n.service";
  };
};
```

## Auditoria

### Verificar Acessos

```bash
# Ver conexões ativas
sudo ss -tnp | grep :8080

# Ver IPs que acessaram (requer logging no nginx/caddy)
sudo journalctl -u caddy | grep sync.seudominio.com
```

### Verificar Integridade dos Dados

```bash
# Exportar tarefas do servidor
task export > server-tasks.json

# Comparar com cliente
diff <(jq -S . server-tasks.json) <(jq -S . client-tasks.json)
```

## Checklist de Segurança

- [ ] Servidor rodando apenas em rede confiável OU com proteção adicional
- [ ] Firewall configurado adequadamente
- [ ] Backups automáticos habilitados
- [ ] Logs sendo monitorados
- [ ] Certificado SSL se exposto externamente
- [ ] Autenticação adicional se necessário (via proxy)
- [ ] Dados sensíveis não estão nas tarefas (senhas, tokens, etc)

## Privacidade dos Dados

### O que é armazenado

- Descrição das tarefas
- Tags, projetos, prioridades
- Datas (criação, modificação, conclusão)
- UDAs (User Defined Attributes) como `client`
- Anotações

### Boas Práticas

1. **Não armazene dados sensíveis** nas tarefas:
   - ❌ "Trocar senha do banco: senha123"
   - ✅ "Trocar senha do banco"

2. **Use referências** ao invés de dados completos:
   - ❌ "Ligar para João (11) 98765-4321"
   - ✅ "Ligar para João (ver contatos)"

3. **Criptografe dados sensíveis** se necessário:
   ```bash
   # Usar anotações criptografadas
   task 1 annotate "$(echo 'dados sensíveis' | gpg -e -r seu@email.com)"
   ```

## Conformidade

### LGPD/GDPR

Se você armazena tarefas de outras pessoas:

1. Obtenha consentimento
2. Implemente direito ao esquecimento:
   ```bash
   # Deletar todas as tarefas de um cliente
   task client:ClienteX delete
   ```
3. Mantenha backups seguros
4. Documente processamento de dados

## Referências

- [Taskwarrior Security](https://taskwarrior.org/docs/security/)
- [NixOS Firewall](https://nixos.wiki/wiki/Firewall)
- [Caddy Security](https://caddyserver.com/docs/security)
- [SSH Tunneling](https://www.ssh.com/academy/ssh/tunneling)
