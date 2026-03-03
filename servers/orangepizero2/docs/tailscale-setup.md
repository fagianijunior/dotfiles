# Tailscale VPN - Guia Completo

Guia de configuração e uso do Tailscale no Orange Pi Zero 2 para acesso remoto seguro.

## 📋 O que é Tailscale?

Tailscale é uma VPN moderna baseada em WireGuard que:

- ✅ Cria uma rede privada entre seus dispositivos
- ✅ Funciona através de NAT e firewalls
- ✅ Criptografia end-to-end
- ✅ Zero configuração de portas/firewall
- ✅ Acesso de qualquer lugar (internet)
- ✅ Gratuito para uso pessoal (até 100 dispositivos)

## 🚀 Configuração Inicial

### 1. Criar Conta no Tailscale

1. Acesse https://tailscale.com/
2. Clique em "Get Started"
3. Faça login com Google, GitHub, Microsoft ou email

### 2. Configurar no Orange Pi

```bash
# SSH no Orange Pi
ssh orangepizero2

# Autenticar no Tailscale
sudo tailscale up

# Isso mostrará uma URL como:
# https://login.tailscale.com/a/xxxxxxxxxxxxx
```

### 3. Autenticar no Navegador

1. Copie a URL mostrada
2. Abra no seu navegador
3. Faça login na sua conta Tailscale
4. Autorize o dispositivo "orangepizero2"

### 4. Verificar Conexão

```bash
# Ver status
sudo tailscale status

# Deve mostrar algo como:
# 100.x.x.x   orangepizero2        user@       linux   -

# Ver IP do Tailscale
sudo tailscale ip -4
# Exemplo: 100.64.0.1
```

## 🔧 Configuração Avançada

### Hostname Personalizado

Por padrão, o hostname é "orangepizero2". Para personalizar:

```bash
# Definir hostname customizado
sudo tailscale up --hostname=orange-pi-server

# Ou com tags para organização
sudo tailscale up --hostname=orange-pi-server --advertise-tags=tag:server
```

### Exit Node (Roteador VPN)

Permite usar o Orange Pi como gateway para toda a internet:

```bash
# No Orange Pi, anunciar como exit node
sudo tailscale up --advertise-exit-node

# Aprovar no painel web:
# https://login.tailscale.com/admin/machines
# Clique no Orange Pi > Edit route settings > Use as exit node

# Em outro dispositivo, usar como exit node
tailscale up --exit-node=orangepizero2
```

### Subnet Router

Permite acessar outros dispositivos na rede local do Orange Pi:

```bash
# Anunciar subnet (ajuste para sua rede)
sudo tailscale up --advertise-routes=192.168.1.0/24

# Aprovar no painel web:
# https://login.tailscale.com/admin/machines
# Clique no Orange Pi > Edit route settings > Approve routes
```

### MagicDNS

Acesse dispositivos por nome ao invés de IP:

```bash
# Habilitar no painel web:
# https://login.tailscale.com/admin/dns
# Enable MagicDNS

# Agora você pode usar:
ping orangepizero2
ssh orangepizero2
curl http://orangepizero2:8080
```

## 🔐 Segurança

### ACLs (Access Control Lists)

Controle quem pode acessar o quê:

```json
// https://login.tailscale.com/admin/acls
{
  "acls": [
    // Permitir todos acessarem o Orange Pi na porta 8080
    {
      "action": "accept",
      "src": ["*"],
      "dst": ["orangepizero2:8080"]
    },
    // Permitir apenas você acessar SSH
    {
      "action": "accept",
      "src": ["seu-email@example.com"],
      "dst": ["orangepizero2:22"]
    }
  ]
}
```

### Key Expiry

Por padrão, chaves expiram em 180 dias. Para desabilitar:

```bash
# No painel web:
# https://login.tailscale.com/admin/machines
# Clique no Orange Pi > Disable key expiry
```

### Autenticação de Dois Fatores

Habilite 2FA na sua conta Tailscale:

```
https://login.tailscale.com/admin/settings/account
```

## 📱 Configurar Outros Dispositivos

### Desktop/Laptop Linux

```bash
# Instalar Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Conectar
sudo tailscale up

# Verificar
tailscale status
```

### NixOS (via home-manager ou system)

```nix
# configuration.nix ou home.nix
services.tailscale.enable = true;
```

```bash
# Aplicar
sudo nixos-rebuild switch

# Conectar
sudo tailscale up
```

### macOS

```bash
# Instalar via Homebrew
brew install tailscale

# Ou baixar app:
# https://tailscale.com/download/mac

# Conectar
sudo tailscale up
```

### Windows

1. Baixar: https://tailscale.com/download/windows
2. Instalar e executar
3. Fazer login quando solicitado

### Android/iOS

1. Instalar app da loja (Play Store/App Store)
2. Fazer login
3. Conectar

## 🌐 Usar com Taskwarrior

### Configuração do Cliente

```bash
# Descobrir IP do Tailscale do Orange Pi
TAILSCALE_IP=$(ssh orangepizero2 'sudo tailscale ip -4')
echo $TAILSCALE_IP

# Configurar Taskwarrior
task config sync.server.origin http://$TAILSCALE_IP:8080
task config sync.server.client_id $(uuidgen)

# Inicializar
task sync init
```

### Com MagicDNS (Recomendado)

```bash
# Usar hostname ao invés de IP
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $(uuidgen)

# Inicializar
task sync init
```

### Vantagens

- ✅ Funciona de qualquer lugar (casa, trabalho, viagem)
- ✅ Sem necessidade de port forwarding
- ✅ Criptografia automática
- ✅ IP estável (não muda)
- ✅ Funciona em redes restritivas

## 🔍 Monitoramento

### Status do Serviço

```bash
# Status do Tailscale
sudo systemctl status tailscaled

# Logs
sudo journalctl -u tailscaled -f

# Status da conexão
sudo tailscale status

# Informações detalhadas
sudo tailscale status --json | jq .
```

### Ping Test

```bash
# Do Orange Pi para outro dispositivo
sudo tailscale ping nome-do-dispositivo

# De outro dispositivo para Orange Pi
tailscale ping orangepizero2
```

### Netcheck

```bash
# Verificar conectividade e latência
sudo tailscale netcheck
```

## 🐛 Troubleshooting

### Problema: Não consegue conectar

```bash
# Verificar se o serviço está rodando
sudo systemctl status tailscaled

# Reiniciar serviço
sudo systemctl restart tailscaled

# Tentar reconectar
sudo tailscale up
```

### Problema: IP não aparece

```bash
# Verificar status
sudo tailscale status

# Se mostrar "Stopped", conectar
sudo tailscale up

# Verificar logs
sudo journalctl -u tailscaled -n 50
```

### Problema: Não consegue acessar Orange Pi

```bash
# Verificar se está na mesma rede Tailscale
tailscale status

# Verificar ACLs no painel web
# https://login.tailscale.com/admin/acls

# Testar conectividade
tailscale ping orangepizero2

# Testar porta específica
nc -zv orangepizero2 8080
```

### Problema: Lento

```bash
# Verificar rota
sudo tailscale netcheck

# Forçar rota direta (sem relay)
sudo tailscale up --accept-routes=false

# Verificar se está usando relay
sudo tailscale status --json | jq '.Peer[].Relay'
```

## 📊 Comandos Úteis

```bash
# Status
sudo tailscale status

# IPs
sudo tailscale ip

# Conectar
sudo tailscale up

# Desconectar
sudo tailscale down

# Ping
sudo tailscale ping <dispositivo>

# Netcheck
sudo tailscale netcheck

# Versão
tailscale version

# Logout
sudo tailscale logout

# File sharing
tailscale file cp arquivo.txt orangepizero2:

# SSH via Tailscale
ssh orangepizero2
```

## 🎯 Casos de Uso

### 1. Acesso Remoto ao Taskwarrior

```bash
# De qualquer lugar do mundo
task sync  # Funciona automaticamente via Tailscale
```

### 2. SSH Seguro

```bash
# Sem expor porta 22 na internet
ssh orangepizero2  # Via Tailscale
```

### 3. Acesso à Rede Local

```bash
# Com subnet router configurado
ssh 192.168.1.10  # Outro dispositivo na rede do Orange Pi
```

### 4. Exit Node para Privacidade

```bash
# Usar Orange Pi como VPN
tailscale up --exit-node=orangepizero2

# Todo tráfego passa pelo Orange Pi
curl ifconfig.me  # Mostra IP do Orange Pi
```

## 💡 Dicas

1. **Habilite MagicDNS**: Facilita muito o uso
2. **Desabilite key expiry**: Evita reconexões
3. **Use tags**: Organize dispositivos por função
4. **Configure ACLs**: Controle de acesso granular
5. **Monitore uso**: Painel web mostra estatísticas

## 🔗 Recursos

- [Tailscale Docs](https://tailscale.com/kb/)
- [Painel Admin](https://login.tailscale.com/admin/)
- [ACL Editor](https://login.tailscale.com/admin/acls)
- [Status Page](https://status.tailscale.com/)

## 🆚 Comparação com Outras Soluções

| Aspecto | Tailscale | OpenVPN | WireGuard | Port Forward |
|---------|-----------|---------|-----------|--------------|
| Configuração | Fácil | Difícil | Média | Fácil |
| NAT Traversal | Sim | Não | Não | N/A |
| Criptografia | Sim | Sim | Sim | Não |
| Performance | Alta | Média | Alta | Alta |
| Custo | Grátis* | Grátis | Grátis | Grátis |
| Manutenção | Baixa | Alta | Média | Baixa |

*Grátis para uso pessoal (até 100 dispositivos)

## ✅ Checklist de Configuração

- [ ] Conta Tailscale criada
- [ ] Orange Pi autenticado
- [ ] MagicDNS habilitado
- [ ] Key expiry desabilitado
- [ ] Outros dispositivos conectados
- [ ] Taskwarrior configurado com IP Tailscale
- [ ] Teste de sincronização funcionando
- [ ] ACLs configuradas (opcional)
- [ ] Exit node configurado (opcional)
- [ ] Subnet router configurado (opcional)

## 🎉 Conclusão

Com o Tailscale configurado, você pode acessar seu Orange Pi Zero 2 de qualquer lugar do mundo de forma segura e sem complicações de port forwarding ou configuração de firewall.

Aproveite! 🚀
