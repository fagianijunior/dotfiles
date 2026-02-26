# Como Validar se os Dados foram Escritos no Servidor

## 🚀 Método Rápido (Script Automático)

Execute o script de validação:

```bash
./nixos-orangepizero2/scripts/validate-taskwarrior-sync.sh
```

Este script verifica automaticamente:
- ✅ Serviço rodando
- ✅ Porta aberta
- ✅ Servidor respondendo
- ✅ Dados no diretório do servidor
- ✅ Logs recentes
- ✅ Configuração do cliente
- ✅ Estatísticas de sincronização

## 🔍 Validação Manual Passo a Passo

### 1. Verificar Serviço no Servidor

```bash
ssh orangepizero2 'sudo systemctl status taskchampion-sync-server'
```

Deve mostrar: `Active: active (running)`

### 2. Verificar Diretório de Dados

```bash
ssh orangepizero2 'sudo ls -lah /var/lib/taskchampion-sync-server/'
```

Se houver dados sincronizados, você verá arquivos como:
- `*.db` - Banco de dados SQLite
- `client_*` - Dados dos clientes
- `snapshots/` - Snapshots periódicos

### 3. Verificar Tamanho dos Dados

```bash
ssh orangepizero2 'sudo du -sh /var/lib/taskchampion-sync-server/'
```

Se mostrar apenas `4.0K` ou `0`, significa que nenhum dado foi sincronizado ainda.

### 4. Verificar Logs do Servidor

```bash
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -f'
```

Procure por:
- ✅ `Listening on 0.0.0.0:8080` - Servidor iniciado
- ✅ `POST /sync` - Requisições de sincronização
- ❌ `Connection refused` - Cliente não consegue conectar
- ❌ `Authentication failed` - Problema de autenticação

### 5. Testar Conexão do Cliente

```bash
curl -v http://orangepizero2:8080
```

Deve retornar HTTP 200 ou 404 (ambos indicam que o servidor está respondendo).

### 6. Verificar Configuração Local

```bash
task show | grep sync
```

Deve mostrar:
```
sync.server.url=http://orangepizero2:8080
sync.server.client_id=<seu-uuid>
sync.encryption_secret=<sua-chave>
```

### 7. Sincronizar com Verbose

```bash
task sync rc.verbose=on
```

Isso mostra detalhes da sincronização:
- Quantas tarefas foram enviadas
- Quantas foram recebidas
- Erros de conexão ou autenticação

## 🧪 Teste Completo de Sincronização

### Teste 1: Adicionar Tarefa e Sincronizar

```bash
# 1. Adicionar tarefa de teste
task add "Teste de sincronização $(date +%H:%M:%S)"

# 2. Sincronizar
task sync

# 3. Verificar no servidor
ssh orangepizero2 'sudo ls -lh /var/lib/taskchampion-sync-server/'

# 4. Verificar logs
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -n 20'
```

### Teste 2: Sincronizar de Outro Dispositivo

Se você tem outro dispositivo configurado:

```bash
# No segundo dispositivo
task sync

# Verificar se a tarefa aparece
task list
```

## 🔧 Diagnóstico de Problemas

### Problema: Diretório Vazio no Servidor

**Possíveis causas:**

1. **Primeira sincronização não foi feita**
   ```bash
   task sync init
   ```

2. **Cliente não está configurado corretamente**
   ```bash
   task show | grep sync
   ```

3. **Servidor não está acessível**
   ```bash
   ping orangepizero2
   curl http://orangepizero2:8080
   ```

### Problema: Erro "Connection refused"

**Soluções:**

1. Verificar se o serviço está rodando:
   ```bash
   ssh orangepizero2 'sudo systemctl restart taskchampion-sync-server'
   ```

2. Verificar firewall:
   ```bash
   ssh orangepizero2 'sudo iptables -L -n | grep 8080'
   ```

3. Verificar se a porta está aberta:
   ```bash
   ssh orangepizero2 'sudo ss -tlnp | grep :8080'
   ```

### Problema: Sincronização Não Envia Dados

**Verificações:**

1. **Client ID está configurado?**
   ```bash
   task show sync.server.client_id
   ```

2. **Encryption secret está configurado?**
   ```bash
   task show sync.encryption_secret
   ```

3. **Há tarefas para sincronizar?**
   ```bash
   task status:pending count
   ```

4. **Sincronização foi inicializada?**
   ```bash
   task sync init
   ```

## 📊 Monitoramento Contínuo

### Ver Logs em Tempo Real

```bash
ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -f'
```

### Verificar Tamanho dos Dados Periodicamente

```bash
watch -n 5 'ssh orangepizero2 "sudo du -sh /var/lib/taskchampion-sync-server/"'
```

### Estatísticas de Sincronização

```bash
# Criar alias útil
alias task-sync-stats='echo "Local:" && task count && echo "Servidor:" && ssh orangepizero2 "sudo du -sh /var/lib/taskchampion-sync-server/"'
```

## 🎯 Checklist de Validação

Use este checklist para garantir que tudo está funcionando:

- [ ] Serviço está ativo: `systemctl status taskchampion-sync-server`
- [ ] Porta 8080 está aberta: `ss -tlnp | grep :8080`
- [ ] Servidor responde: `curl http://orangepizero2:8080`
- [ ] Diretório de dados existe: `ls /var/lib/taskchampion-sync-server/`
- [ ] Diretório tem arquivos (não está vazio)
- [ ] Logs não mostram erros: `journalctl -u taskchampion-sync-server`
- [ ] Cliente está configurado: `task show | grep sync`
- [ ] Sincronização funciona: `task sync`
- [ ] Dados aparecem no servidor após sync
- [ ] Segundo dispositivo consegue sincronizar

## 💡 Dicas Úteis

1. **Sempre use verbose na primeira vez:**
   ```bash
   task sync rc.verbose=on
   ```

2. **Verifique os logs após cada sync:**
   ```bash
   ssh orangepizero2 'sudo journalctl -u taskchampion-sync-server -n 10'
   ```

3. **Faça backup antes de testar:**
   ```bash
   task export > backup-$(date +%Y%m%d).json
   ```

4. **Use o script de validação regularmente:**
   ```bash
   ./nixos-orangepizero2/scripts/validate-taskwarrior-sync.sh
   ```

## 📚 Referências

- [TASKWARRIOR-SETUP.md](./TASKWARRIOR-SETUP.md) - Guia completo de instalação
- [Documentação Taskchampion](https://github.com/GothenburgBitFactory/taskchampion)
- [Taskwarrior 3 Docs](https://taskwarrior.org/docs/)
