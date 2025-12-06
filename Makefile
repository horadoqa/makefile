.PHONY: menu buscar_ids deletar_ids criar_usuario

# ================================
# MENU
# ================================
menu:
	@echo "==================================="; \
	echo "        MENU DE OPERAÇÕES"; \
	echo "==================================="; \
	echo "1 - Criar usuário"; \
	echo "2 - Buscar IDs"; \
	echo "3 - Deletar usuários"; \
	echo "==================================="; \
	read -p 'Escolha uma opção: ' opt; \
	case $$opt in \
		1) $(MAKE) --no-print-directory criar_usuario ;; \
		2) $(MAKE) --no-print-directory buscar_ids ;; \
		3) $(MAKE) --no-print-directory deletar_ids ;; \
		*) echo 'Opção inválida!'; exit 1 ;; \
	esac


# ================================
# 1) Criar usuário
# ================================
criar_usuario:
	@echo "Criando usuário 'Hora do QA'..."
	@RESPONSE=$$(curl -s -X POST "https://serverest.dev/usuarios" \
		-H "accept: application/json" \
		-H "Content-Type: application/json" \
		-d '{ "nome": "Hora do QA", "email": "horadoqa6@qa.com.br", "password": "teste", "administrador": "true" }'); \
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
buscar_ids:
	@echo "Buscando IDs de usuários com nome 'Hora do QA'..."
	@curl -s "https://serverest.dev/usuarios" \
	| jq -r '.usuarios[] | select(.nome == "Hora do QA") | ._id' \
	> ids.txt
	@echo "IDs encontrados foram salvos em ids.txt"

# ================================
# 3) Deletar usuários via ids.txt
# ================================
deletar_ids:
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


# make criar_usuario
# make buscar_ids
# make deletar_ids
# make menu