# Makefile

Um **Makefile** é um arquivo de configuração usado pelo utilitário `make` para automatizar a compilação e construção de projetos. Ele define regras, dependências e comandos que permitem compilar código, gerar executáveis e executar tarefas repetitivas de forma eficiente.

---

## Sumário

* [O que é um Makefile](#o-que-é-um-makefile)
* [Estrutura de um Makefile](#estrutura-de-um-makefile)
* [Como usar](#como-usar)
* [Exemplo de Makefile](#exemplo-de-makefile)
* [Comandos úteis](#comandos-úteis)

---

## O que é um Makefile

Um Makefile permite:

* Compilar programas automaticamente sem precisar digitar comandos longos toda vez.
* Gerenciar dependências entre arquivos (por exemplo, `.c` e `.h` no C).
* Definir regras para diferentes tarefas, como limpar arquivos temporários ou gerar documentação.

Ele é amplamente usado em linguagens como **C, C++, Java** e em projetos de software que requerem automação de build.

---

## Estrutura de um Makefile

Um Makefile é composto por **regras** no formato:

```makefile
target: dependencies
    command
```

* **target**: o arquivo ou ação que você quer gerar (ex: `main`, `all`, `clean`).
* **dependencies**: arquivos necessários para gerar o target. Se algum deles mudar, o comando será executado.
* **command**: o comando que será executado para gerar o target (deve começar com **tab**).

Além disso, você pode definir **variáveis** para facilitar a manutenção:

```makefile
CC = gcc
CFLAGS = -Wall -g
```

---

## Como usar

Para usar um Makefile:

1. Crie um arquivo chamado `Makefile` no diretório do projeto.
2. Defina targets, dependências e comandos.
3. No terminal, execute:

```bash
make        # Executa o primeiro target do Makefile
make clean  # Executa o target clean, se definido
```

---

## Exemplo de Makefile

```makefile
# Variáveis
CC = gcc
CFLAGS = -Wall -g
OBJ = main.o utils.o

# Target padrão
all: program

# Regra para gerar o executável
program: $(OBJ)
    $(CC) $(CFLAGS) -o program $(OBJ)

# Regras para compilar cada arquivo .c
main.o: main.c utils.h
    $(CC) $(CFLAGS) -c main.c

utils.o: utils.c utils.h
    $(CC) $(CFLAGS) -c utils.c

# Limpeza de arquivos gerados
clean:
    rm -f *.o program
```

Neste exemplo:

* `all` é o target padrão.
* `program` depende de `main.o` e `utils.o`.
* O target `clean` remove arquivos temporários e o executável.

---

## Comandos úteis

* `make` → Executa o primeiro target do Makefile.
* `make <target>` → Executa um target específico.
* `make clean` → Remove arquivos gerados.
* `make -n` → Mostra quais comandos seriam executados, sem executar.
* `make -B` → Força a recompilação de todos os arquivos.

---


