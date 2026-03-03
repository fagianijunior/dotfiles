# Makefile para Orange Pi Zero 2
# Facilita operações comuns de build, deploy e manutenção

.PHONY: help build deploy test status logs restart backup restore clean

# Configuração
HOST := orangepizero2
USER := root
FLAKE := ..
CONFIG := orangepizero2

# Cores para output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

help: ## Mostra esta ajuda
	@echo "$(GREEN)Orange Pi Zero 2 - Comandos Disponíveis$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Exemplos:$(NC)"
	@echo "  make build          # Build local"
	@echo "  make deploy         # Deploy remoto"
	@echo "  make test           # Testar servidor"
	@echo "  make logs           # Ver logs"

build: ## Build local no Orange Pi (via SSH)
	@echo "$(GREEN)🔨 Building no Orange Pi...$(NC)"
	ssh $(USER)@$(HOST) "cd /root/dotfiles && sudo nixos-rebuild build --flake .#$(CONFIG)"
	@echo "$(GREEN)✅ Build concluído!$(NC)"

switch: ## Aplicar configuração localmente no Orange Pi
	@echo "$(GREEN)🔄 Aplicando configuração no Orange Pi...$(NC)"
	ssh $(USER)@$(HOST) "cd /root/dotfiles && sudo nixos-rebuild switch --flake .#$(CONFIG)"
	@echo "$(GREEN)✅ Configuração aplicada!$(NC)"

deploy: ## Build e deploy remoto do desktop
	@echo "$(GREEN)🚀 Deploy remoto para Orange Pi...$(NC)"
	cd $(FLAKE) && sudo nixos-rebuild switch --flake .#$(CONFIG) --target-host $(USER)@$(HOST)
	@echo "$(GREEN)✅ Deploy concluído!$(NC)"

test: ## Executar script de teste
	@echo "$(GREEN)🧪 Testando Taskchampion Sync Server...$(NC)"
	@echo ""
	ssh $(USER)@$(HOST) 'bash -s' < scripts/test-taskchampion.sh

status: ## Ver status do serviço
	@echo "$(GREEN)📊 Status do Taskchampion Sync Server:$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo systemctl status taskchampion-sync-server'

logs: ## Ver logs em tempo real
	@echo "$(GREEN)📜 Logs do Taskchampion Sync Server (Ctrl+C para sair):$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo journalctl -u taskchampion-sync-server -f'

logs-recent: ## Ver últimas 50 linhas do log
	@echo "$(GREEN)📜 Últimas 50 linhas do log:$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo journalctl -u taskchampion-sync-server -n 50 --no-pager'

restart: ## Reiniciar serviço
	@echo "$(YELLOW)🔄 Reiniciando Taskchampion Sync Server...$(NC)"
	@ssh $(USER)@$(HOST) 'sudo systemctl restart taskchampion-sync-server'
	@sleep 2
	@echo "$(GREEN)✅ Serviço reiniciado!$(NC)"
	@echo ""
	@make status

stop: ## Parar serviço
	@echo "$(YELLOW)⏸️  Parando Taskchampion Sync Server...$(NC)"
	@ssh $(USER)@$(HOST) 'sudo systemctl stop taskchampion-sync-server'
	@echo "$(GREEN)✅ Serviço parado!$(NC)"

start: ## Iniciar serviço
	@echo "$(GREEN)▶️  Iniciando Taskchampion Sync Server...$(NC)"
	@ssh $(USER)@$(HOST) 'sudo systemctl start taskchampion-sync-server'
	@sleep 2
	@echo "$(GREEN)✅ Serviço iniciado!$(NC)"
	@echo ""
	@make status

backup: ## Criar backup dos dados
	@echo "$(GREEN)💾 Criando backup...$(NC)"
	@ssh $(USER)@$(HOST) 'sudo tar -czf /tmp/taskchampion-backup-$$(date +%Y%m%d-%H%M%S).tar.gz -C /var/lib/taskchampion-sync-server .'
	@echo "$(GREEN)✅ Backup criado em /tmp/$(NC)"
	@ssh $(USER)@$(HOST) 'ls -lh /tmp/taskchampion-backup-*.tar.gz | tail -1'

backup-download: ## Criar backup e baixar para local
	@echo "$(GREEN)💾 Criando e baixando backup...$(NC)"
	@ssh $(USER)@$(HOST) 'sudo tar -czf /tmp/taskchampion-backup-$$(date +%Y%m%d-%H%M%S).tar.gz -C /var/lib/taskchampion-sync-server .'
	@BACKUP_FILE=$$(ssh $(USER)@$(HOST) 'ls -t /tmp/taskchampion-backup-*.tar.gz | head -1'); \
	scp $(USER)@$(HOST):$$BACKUP_FILE ./backups/; \
	echo "$(GREEN)✅ Backup baixado para ./backups/$(NC)"

restore: ## Restaurar backup (requer BACKUP_FILE=caminho)
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "$(RED)❌ Erro: Especifique BACKUP_FILE=caminho$(NC)"; \
		echo "Exemplo: make restore BACKUP_FILE=./backups/taskchampion-backup-20260226.tar.gz"; \
		exit 1; \
	fi
	@echo "$(YELLOW)⚠️  Restaurando backup: $(BACKUP_FILE)$(NC)"
	@echo "$(YELLOW)⚠️  Isso irá sobrescrever os dados atuais!$(NC)"
	@read -p "Continuar? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		scp $(BACKUP_FILE) $(USER)@$(HOST):/tmp/restore.tar.gz; \
		ssh $(USER)@$(HOST) 'sudo systemctl stop taskchampion-sync-server'; \
		ssh $(USER)@$(HOST) 'sudo rm -rf /var/lib/taskchampion-sync-server/*'; \
		ssh $(USER)@$(HOST) 'sudo tar -xzf /tmp/restore.tar.gz -C /var/lib/taskchampion-sync-server/'; \
		ssh $(USER)@$(HOST) 'sudo chown -R taskchampion:taskchampion /var/lib/taskchampion-sync-server/'; \
		ssh $(USER)@$(HOST) 'sudo systemctl start taskchampion-sync-server'; \
		echo "$(GREEN)✅ Backup restaurado!$(NC)"; \
	else \
		echo "$(YELLOW)Operação cancelada$(NC)"; \
	fi

info: ## Informações do sistema
	@echo "$(GREEN)ℹ️  Informações do Orange Pi Zero 2:$(NC)"
	@echo ""
	@echo "$(YELLOW)Hostname:$(NC)"
	@ssh $(USER)@$(HOST) 'hostname'
	@echo ""
	@echo "$(YELLOW)IP:$(NC)"
	@ssh $(USER)@$(HOST) "ip -4 addr show end0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
	@echo ""
	@echo "$(YELLOW)Uptime:$(NC)"
	@ssh $(USER)@$(HOST) 'uptime'
	@echo ""
	@echo "$(YELLOW)Memória:$(NC)"
	@ssh $(USER)@$(HOST) 'free -h'
	@echo ""
	@echo "$(YELLOW)Disco:$(NC)"
	@ssh $(USER)@$(HOST) 'df -h /'
	@echo ""
	@echo "$(YELLOW)Temperatura:$(NC)"
	@ssh $(USER)@$(HOST) 'cat /sys/class/thermal/thermal_zone0/temp | awk "{print \$$1/1000 \"°C\"}"' || echo "N/A"

connections: ## Ver conexões ativas na porta 8080
	@echo "$(GREEN)🔌 Conexões ativas:$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo ss -tnp | grep :8080'

data-size: ## Ver tamanho dos dados
	@echo "$(GREEN)📊 Tamanho dos dados:$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo du -sh /var/lib/taskchampion-sync-server/'
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo ls -lh /var/lib/taskchampion-sync-server/'

clean-backups: ## Limpar backups antigos (mantém últimos 5)
	@echo "$(YELLOW)🧹 Limpando backups antigos...$(NC)"
	@ssh $(USER)@$(HOST) 'ls -t /tmp/taskchampion-backup-*.tar.gz | tail -n +6 | xargs -r rm'
	@echo "$(GREEN)✅ Backups antigos removidos!$(NC)"

update-flake: ## Atualizar flake.lock
	@echo "$(GREEN)🔄 Atualizando flake...$(NC)"
	cd $(FLAKE) && nix flake update
	@echo "$(GREEN)✅ Flake atualizado!$(NC)"

rebuild-update: update-flake deploy ## Atualizar flake e fazer deploy

ssh: ## SSH no Orange Pi
	@ssh $(USER)@$(HOST)

ping: ## Testar conectividade
	@echo "$(GREEN)🏓 Testando conectividade...$(NC)"
	@ping -c 4 $(HOST)

curl-test: ## Testar servidor HTTP
	@echo "$(GREEN)🌐 Testando servidor HTTP...$(NC)"
	@curl -v http://$(HOST):8080 2>&1 | head -20

docs: ## Abrir documentação principal
	@less TASKWARRIOR-SETUP.md

docs-security: ## Abrir guia de segurança
	@less docs/taskwarrior-security.md

docs-troubleshooting: ## Abrir guia de troubleshooting
	@less docs/taskwarrior-troubleshooting.md

docs-quick: ## Abrir referência rápida
	@less docs/taskwarrior-quick-reference.md

docs-tailscale: ## Abrir guia do Tailscale
	@less docs/tailscale-setup.md

tailscale-status: ## Ver status do Tailscale
	@echo "$(GREEN)🔐 Status do Tailscale:$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo tailscale status'

tailscale-ip: ## Ver IP do Tailscale
	@echo "$(GREEN)🌐 IP do Tailscale:$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo tailscale ip -4'

tailscale-up: ## Conectar Tailscale
	@echo "$(GREEN)🔌 Conectando Tailscale...$(NC)"
	@ssh $(USER)@$(HOST) 'sudo tailscale up'
	@echo ""
	@make tailscale-status

tailscale-down: ## Desconectar Tailscale
	@echo "$(YELLOW)🔌 Desconectando Tailscale...$(NC)"
	@ssh $(USER)@$(HOST) 'sudo tailscale down'
	@echo "$(GREEN)✅ Desconectado!$(NC)"

tailscale-logs: ## Ver logs do Tailscale
	@echo "$(GREEN)📜 Logs do Tailscale (Ctrl+C para sair):$(NC)"
	@echo ""
	@ssh $(USER)@$(HOST) 'sudo journalctl -u tailscaled -f'

clean: ## Limpar arquivos temporários
	@echo "$(YELLOW)🧹 Limpando arquivos temporários...$(NC)"
	@rm -f *.log *.tmp
	@echo "$(GREEN)✅ Limpeza concluída!$(NC)"

.DEFAULT_GOAL := help
