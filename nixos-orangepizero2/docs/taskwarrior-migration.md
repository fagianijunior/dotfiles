# Migração do Taskd para Taskchampion Sync Server

Guia para migrar do antigo taskd (Taskwarrior 2.x) para o novo taskchampion-sync-server (Taskwarrior 3.x).

## 📋 Visão Geral

### Diferenças Principais

| Aspecto | Taskd (antigo) | Taskchampion (novo) |
|---------|----------------|---------------------|
| Versão TW | 2.x | 3.x |
| Protocolo | TLS/SSL | HTTP |
| Autenticação | Certificados | Nenhuma (nativa) |
| Configuração | Complexa | Simples |
| Porta padrão | 53589 | 8080 |
| Formato dados | Proprietário | JSON |
| Identificador | Org/User/Key | UUID |

### Por que migrar?

- ✅ Configuração muito mais simples
- ✅ Sem necessidade de certificados
- ✅ Melhor performance
- ✅ Suporte oficial do Taskwarrior 3
- ✅ Formato de dados mais acessível (JSON)
- ✅ Desenvolvimento ativo

## 🚀 Processo de Migração

### Pré-requisitos

- [ ] Backup completo das tarefas atuais
- [ ] Taskwarrior 3.x instalado em todos os clientes
- [ ] Orange Pi Zero 2 configurado com taskchampion-sync-server
- [ ] Acesso SSH ao servidor antigo (se aplicável)

### Passo 1: Backup dos Dados

#### No servidor taskd antigo

```bash
# Backup do diretório de dados
sudo tar -czf taskd-backup-$(date +%Y%m%d).tar.gz /var/lib/taskd/

# Copiar para local seguro
scp taskd-backup-*.tar.gz usuario@backup-server:/backups/
```

#### Em cada cliente

```bash
# Exportar todas as tarefas
task export > taskwarrior-backup-$(date +%Y%m%d).json

# Backup do diretório completo
tar -czf task-data-backup-$(date +%Y%m%d).tar.gz ~/.task/

# Guardar em local seguro
cp taskwarrior-backup-*.json ~/Backups/
cp task-data-backup-*.tar.gz ~/Backups/
```

### Passo 2: Atualizar Taskwarrior para 3.x

#### NixOS (via home-manager)

```nix
# home/default.nix ou similar
home.packages = with pkgs; [
  taskwarrior3  # Versão 3.x
];
```

Aplicar:
```bash
home-manager switch
```

#### Verificar versão

```bash
task --version
# Deve mostrar: 3.x.x
```

### Passo 3: Limpar Configuração Antiga

#### Backup da configuração antiga

```bash
cp ~/.taskrc ~/.taskrc.taskd-backup
cp ~/.task/ca.cert.pem ~/.task/ca.cert.pem.backup
cp ~/.task/private.certificate.pem ~/.task/private.certificate.pem.backup
cp ~/.task/private.key.pem ~/.task/private.key.pem.backup
```

#### Remover configuração do taskd

Edite `~/.taskrc` e remova/comente estas linhas:

```bash
# Remover:
taskd.certificate=~/.task/private.certificate.pem
taskd.key=~/.task/private.key.pem
taskd.ca=~/.task/ca.cert.pem
taskd.server=host.domain:53589
taskd.credentials=Org/First Last/cf31f287-ee9e-43a8-843e-e8bbd5de4294
```

Ou criar novo taskrc limpo:

```bash
# Backup do antigo
mv ~/.taskrc ~/.taskrc.old

# Criar novo (Taskwarrior 3 usa ~/.config/task/taskrc)
mkdir -p ~/.config/task
task config data.location ~/.local/share/task
```

### Passo 4: Configurar Taskchampion Sync

#### Gerar UUID único

```bash
CLIENT_ID=$(uuidgen)
echo "Seu UUID: $CLIENT_ID"
# Anote este UUID!
```

#### Configurar cliente

```bash
# Configurar servidor
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $CLIENT_ID
```

Ou via home-manager (recomendado):

```nix
# home/taskwarrior/sync-config.nix
clientId = "seu-uuid-aqui";
serverOrigin = "http://orangepizero2:8080";
```

### Passo 5: Migrar Dados

#### Opção A: Inicializar com dados locais (recomendado)

```bash
# Suas tarefas locais serão enviadas para o servidor
task sync init
```

Isso envia todas as tarefas do cliente para o servidor.

#### Opção B: Importar do backup

Se você quer começar do zero:

```bash
# Limpar dados locais
rm -rf ~/.local/share/task/*

# Importar do backup
task import taskwarrior-backup-20260226.json

# Inicializar sync
task sync init
```

### Passo 6: Configurar Outros Clientes

Para cada cliente adicional:

```bash
# 1. Atualizar para Taskwarrior 3
# 2. Gerar UUID DIFERENTE
CLIENT_ID=$(uuidgen)

# 3. Configurar
task config sync.server.origin http://orangepizero2:8080
task config sync.server.client_id $CLIENT_ID

# 4. Sincronizar (NÃO use init!)
task sync
```

### Passo 7: Verificar Migração

```bash
# Verificar tarefas
task list

# Verificar sync
task sync

# Comparar com backup
diff <(task export | jq -S .) <(jq -S . taskwarrior-backup-20260226.json)
```

### Passo 8: Desativar Servidor Antigo

Após confirmar que tudo funciona:

```bash
# No servidor taskd antigo
sudo systemctl stop taskd
sudo systemctl disable taskd

# Manter backup por segurança
sudo tar -czf taskd-final-backup-$(date +%Y%m%d).tar.gz /var/lib/taskd/
```

## 🔄 Migração de Dados Específicos

### UDAs (User Defined Attributes)

UDAs são preservados automaticamente na migração:

```bash
# Verificar UDAs no taskrc
grep "^uda\." ~/.config/task/taskrc

# Exemplo:
uda.client.type=string
uda.client.label=Client
```

### Contextos

Contextos são preservados:

```bash
# Verificar contextos
grep "^context\." ~/.config/task/taskrc

# Exemplo:
context.work=project:Work or +work
```

### Reports Customizados

Reports precisam ser reconfigurados manualmente:

```bash
# Copiar do taskrc antigo
grep "^report\." ~/.taskrc.old >> ~/.config/task/taskrc
```

### Hooks

Hooks do Taskwarrior 2 geralmente funcionam no 3, mas teste:

```bash
# Copiar hooks
cp -r ~/.task/hooks/ ~/.config/task/hooks/

# Testar
task add "Teste de hook"
```

## 🐛 Problemas Comuns

### Problema 1: Tarefas duplicadas

**Causa**: Executou `sync init` em múltiplos clientes

**Solução**:
```bash
# Escolher um cliente como fonte de verdade
# Nesse cliente:
task sync init

# Nos outros clientes:
rm -rf ~/.local/share/task/*
task sync
```

### Problema 2: UUIDs conflitantes

**Causa**: Importou mesmo backup em múltiplos clientes

**Solução**:
```bash
# Regenerar UUIDs
task export | jq '.[] | .uuid = (uuidgen | ascii_downcase)' | task import
```

### Problema 3: Formato de data diferente

**Causa**: Taskwarrior 3 usa formato ISO 8601

**Solução**: Já é tratado automaticamente na importação

### Problema 4: Certificados antigos causam erro

**Causa**: Configuração antiga do taskd ainda presente

**Solução**:
```bash
# Remover certificados
rm ~/.task/*.pem

# Limpar configuração
task config taskd.certificate ""
task config taskd.key ""
task config taskd.ca ""
task config taskd.server ""
task config taskd.credentials ""
```

## 📊 Comparação de Performance

### Taskd (antigo)

```
Primeira sincronização: ~5-10 segundos
Sync incremental: ~2-3 segundos
Overhead: Certificados SSL/TLS
Complexidade: Alta
```

### Taskchampion (novo)

```
Primeira sincronização: ~1-2 segundos
Sync incremental: <1 segundo
Overhead: Mínimo (HTTP simples)
Complexidade: Baixa
```

## ✅ Checklist de Migração

### Preparação
- [ ] Backup completo de todos os clientes
- [ ] Backup do servidor taskd
- [ ] Taskwarrior 3.x instalado
- [ ] Taskchampion-sync-server rodando
- [ ] Documentação lida

### Migração
- [ ] Configuração antiga removida/backup
- [ ] UUID único gerado para cada cliente
- [ ] Primeiro cliente configurado e testado
- [ ] Dados migrados com sucesso
- [ ] Outros clientes configurados
- [ ] Sincronização testada entre clientes

### Validação
- [ ] Todas as tarefas presentes
- [ ] UDAs preservados
- [ ] Contextos funcionando
- [ ] Reports funcionando
- [ ] Hooks funcionando (se aplicável)
- [ ] Sincronização funcionando

### Finalização
- [ ] Servidor taskd desativado
- [ ] Backup final do taskd
- [ ] Documentação atualizada
- [ ] Equipe notificada (se aplicável)

## 🔐 Considerações de Segurança

### Taskd tinha:
- ✅ Criptografia TLS/SSL
- ✅ Autenticação por certificado
- ❌ Configuração complexa

### Taskchampion tem:
- ❌ Sem criptografia nativa
- ❌ Sem autenticação nativa
- ✅ Configuração simples

### Recomendações:

Para manter segurança equivalente ao taskd:

1. **Túnel SSH**:
```bash
ssh -L 8080:localhost:8080 -N -f orangepizero2
task config sync.server.origin http://localhost:8080
```

2. **VPN (Tailscale)**:
```bash
# Servidor escuta apenas na interface VPN
address = "100.x.x.x";
```

3. **Reverse Proxy com HTTPS**:
```bash
# Caddy com certificado Let's Encrypt
sync.seudominio.com {
    reverse_proxy localhost:8080
    basicauth {
        usuario $2a$14$hash
    }
}
```

## 📚 Recursos Adicionais

### Documentação
- [Setup Completo](../TASKWARRIOR-SETUP.md)
- [Guia de Segurança](./taskwarrior-security.md)
- [Troubleshooting](./taskwarrior-troubleshooting.md)

### Links Externos
- [Taskwarrior 3 Migration Guide](https://taskwarrior.org/docs/upgrade-3/)
- [Taskchampion GitHub](https://github.com/GothenburgBitFactory/taskchampion-sync-server)
- [Taskwarrior Forum](https://github.com/GothenburgBitFactory/taskwarrior/discussions)

## 💡 Dicas

1. **Migre um cliente por vez**: Teste completamente antes de migrar o próximo
2. **Mantenha backups**: Guarde backups do taskd por pelo menos 1 mês
3. **Documente UUIDs**: Anote qual UUID pertence a qual dispositivo
4. **Teste sincronização**: Faça vários syncs de teste antes de confiar
5. **Comunique a equipe**: Se trabalha em equipe, coordene a migração

## 🎉 Conclusão

A migração do taskd para taskchampion-sync-server é direta e traz benefícios significativos em simplicidade e performance. Com os backups adequados e seguindo este guia, a migração deve ser tranquila.

Boa sorte! 🚀
