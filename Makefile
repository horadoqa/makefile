.PHONY: menu buscar_ids deletar_ids criar_usuario

# ================================
# CORES
# ================================
YELLOW  = \033[1;33m
BLUE    = \033[1;34m
CYAN    = \033[1;36m
GREEN   = \033[1;32m
RED     = \033[1;31m
NC      = \033[0m     # Reset

# ================================
# MENU
# ================================
menu:
	@clear; \
	echo ""; \
	echo "${CYAN}╔═══════════════════════════════════════╗${NC}"; \
	echo "${CYAN}║${NC}     MENU DE OPERAÇÕES            ${CYAN}║${NC}"; \
	echo "${CYAN}╠═══════════════════════════════════════╣${NC}"; \
	echo "${CYAN}║${NC}  ${YELLOW}1${NC} - ${BLUE}Criar usuário          ${CYAN}║${NC}"; \
	echo "${CYAN}║${NC}  ${YELLOW}2${NC} - ${BLUE}Buscar IDs             ${CYAN}║${NC}"; \
	echo "${CYAN}║${NC}  ${YELLOW}3${NC} - ${BLUE}Deletar usuários       ${CYAN}║${NC}"; \
	echo "${CYAN}║${NC}  ${YELLOW}4${NC} - ${BLUE}Sair                   ${CYAN}║${NC}"; \
	echo "${CYAN}╚═══════════════════════════════════════╝${NC}"; \
	echo ""; \
	read -p 'Escolha uma opção: ' opt; \
	case $$opt in \
		1) $(MAKE) --no-print-directory criar_usuario ;; \
		2) $(MAKE) --no-print-directory buscar_ids ;; \
		3) $(MAKE) --no-print-directory deletar_ids ;; \
		4) $(MAKE) --no-print-directory sair ;; \
		*) echo "${RED}Opção inválida!${NC}"; exit 1 ;; \
	esac


# ================================
# 1) Criar usuário
# ================================
criar_usuario:
	@echo "Criando usuário 'Hora do QA'..."
	@RESPONSE=$$(curl -s -X POST "https://serverest.dev/usuarios" \
		-H "accept: application/json" \
		-H "Content-Type: application/json" \
		-d '{ "nome": "Hora do QA", "email": "horadoqa7@qa.com.br", "password": "teste", "administrador": "true" }'); \
	MESSAGE=$$(echo "$$RESPONSE" | jq -r '.message'); \
	if [ "$$MESSAGE" = "Cadastro realizado com sucesso" ]; then \
		echo "$$RESPONSE"; \
		echo "Usuário criado com sucesso!"; \
	else \
		echo "Erro ao criar usuário:"; \
		echo "$$RESPONSE"; \
		exit 1; \
	fi


# ================================
# 2) Buscar IDs de usuários
# ================================
buscar_ids: consultar_ids
	@echo "Buscando IDs de usuários com nome 'Hora do QA'..."
	@curl -s "https://serverest.dev/usuarios" | jq -r '.usuarios[] | select(.nome == "Hora do QA") | ._id' > ids.txt
	@echo "IDs encontrados foram salvos em ids.txt"

consultar_ids:
	@count=$$(curl -s "https://serverest.dev/usuarios" | jq '.usuarios | map(select(.nome == "Hora do QA")) | length'); \
	echo "Foram encontrados $$count registros com o nome 'Hora do QA'"

# ================================
# 3) Deletar usuários via ids.txt
# ================================
deletar_ids: buscar_ids
	@BASE_URL="https://serverest.dev/usuarios"; \
	if [ ! -f ids.txt ]; then \
	  echo "Arquivo ids.txt não encontrado!"; \
	  exit 1; \
	fi; \
	while read -r ID; do \
	  if [ -n "$$ID" ]; then \
	    echo "Deletando usuário com ID: $$ID"; \
	    curl -s -X DELETE "$$BASE_URL/$$ID"; \
	    echo -e "\n---------------------------------------"; \
	  fi; \
	done < ids.txt
	@> ids.txt

# ================================
# 4 - SAIR
# ================================
sair:
	@echo ""; \
	printf "${GREEN}Saindo"; \
	for i in 1 2 3; do \
		sleep 0.4; \
		printf "."; \
	done; \
	printf "${NC}\n"; \
	sleep 0.3; \
	clear

# make menu
