# Makefile para gerenciar configuração NixOS

.PHONY: help build-nobita build-doraemon check-nobita check-doraemon update diff clean

# Detecta hostname atual
CURRENT_HOST := $(shell hostname)

help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Hostname atual: $(CURRENT_HOST)"

build: ## Build para o hostname atual
	@./scripts/build.sh $(CURRENT_HOST)

build-nobita: ## Build para desktop (Nobita)
	@./scripts/build.sh nobita

build-doraemon: ## Build para notebook (Doraemon)
	@./scripts/build.sh doraemon

check: ## Verifica configuração do hostname atual
	@./scripts/build.sh $(CURRENT_HOST) --check

check-nobita: ## Verifica configuração do desktop
	@./scripts/build.sh nobita --check

check-doraemon: ## Verifica configuração do notebook
	@./scripts/build.sh doraemon --check

update: ## Atualiza flake e faz build
	@./scripts/build.sh $(CURRENT_HOST) --update

update-nobita: ## Atualiza e faz build do desktop
	@./scripts/build.sh nobita --update

update-doraemon: ## Atualiza e faz build do notebook
	@./scripts/build.sh doraemon --update

boot: ## Aplica configuração na próxima inicialização
	@./scripts/build.sh $(CURRENT_HOST) --boot

rollback: ## Faz rollback para geração anterior
	@./scripts/build.sh --rollback

diff: ## Mostra diferenças entre hosts
	@./scripts/diff-hosts.sh

diff-modules: ## Compara apenas módulos
	@./scripts/diff-hosts.sh --modules

diff-packages: ## Mostra pacotes únicos
	@./scripts/diff-hosts.sh --packages

clean: ## Remove arquivos temporários
	@echo "Limpando arquivos temporários..."
	@find . -name "*.tmp" -delete
	@find . -name "*.bak" -delete
	@find . -name "*~" -delete
	@echo "Limpeza concluída"

gc: ## Garbage collection do Nix
	@echo "Executando garbage collection..."
	@sudo nix-collect-garbage -d
	@nix-collect-garbage -d

optimize: ## Otimiza store do Nix
	@echo "Otimizando Nix store..."
	@sudo nix-store --optimise

status: ## Mostra status do sistema
	@echo "Sistema: $(CURRENT_HOST)"
	@echo "Geração atual: $$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1)"
	@echo "Uptime: $$(uptime -p)"
	@echo "Kernel: $$(uname -r)"