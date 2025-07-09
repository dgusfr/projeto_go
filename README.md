# **CI/CD: Qualidade e Testes (Fluxo de Comandos)**

### **1. Configuração Inicial do Docker**

Certifique-se de que sua aplicação Docker está rodando:

  * **Iniciar contêineres em segundo plano:**
    ```bash
    docker compose up -d
    ```
  * **Ver logs da aplicação (opcional):**
    ```bash
    docker compose logs -f app
    ```

-----

### **2. Verificação de Qualidade (Lint)**

Use o Lint para analisar seu código em busca de erros e padrões. No Go, usaremos `golangci-lint` via Docker.

  * **Comando para executar o Lint:**

    ```bash
    docker run --rm -itv $(pwd):/app -w /app golangci/golangci-lint golangci-lint run controllers/ database/ models/ routes/
    ```

    (Este comando executa o Lint dentro de um contêiner, mapeando seu código local para `/app` no contêiner.)

  * **Exemplos de Correções (Go):**

      * No `db.go`, ignore o retorno de `AutoMigrate()`:
        ```go
        _ = DB.AutoMigrate(&models.Aluno{})
        ```
      * No `route.go`, ignore o retorno de `r.Run()`:
        ```go
        _ = r.Run()
        ```

  * **Re-executar Lint após correções:**

    ```bash
    docker run --rm -itv $(pwd):/app -w /app golangci/golangci-lint golangci-lint run controllers/ database/ models/ routes/
    ```

  * **Verificar o status da execução (sucesso/falha):**

    ```bash
    echo $?
    ```

    (`0` = sucesso, qualquer outro valor = erro.)

-----

### **3. Execução de Testes Automatizados**

Execute os testes para validar as funcionalidades da sua aplicação.

  * **Comando para executar os testes:**

    ```bash
    docker compose exec app go test main_teste.go
    ```

    (Este comando roda os testes Go diretamente no contêiner da sua aplicação.)

  * **Verificar o status dos testes:**

    ```bash
    echo $?
    ```

    (`0` = testes passaram, `1` = testes falharam.)

---

## **CI Pipeline: Automação Essencial com Makefile**

Um **CI Pipeline** automatiza etapas de qualidade e testes. Use o `Makefile` para gerenciar isso localmente.

### **1. `Makefile`: A Base da Automação**

Crie o arquivo `Makefile` na raiz do seu projeto. Ele define as tarefas que `make` irá executar.

```makefile
# Inicia Docker Compose (app e DB) em segundo plano
start:
	docker compose up -d

# Executa o Lint (golangci-lint) via Docker
# CURDIR garante o caminho correto no Make
lint:
	docker run --rm -itv $(CURDIR):/app -w /app golangci/golangci-lint golangci-lint run controllers/ database/ models/ routes/

# Executa os testes Go dentro do contêiner 'app'
test:
	docker compose exec app go test main_teste.go

# Pipeline completo: inicia app, roda lint, roda testes
# Se uma etapa falha, o pipeline para
ci: start lint test
```

### **2. Comandos para Executar as Tarefas**

Com o `Makefile` pronto, use `make` no terminal para rodar suas etapas:

  * **Executar o Lint:**

    ```bash
    make lint
    ```

  * **Executar os Testes:**

    ```bash
    make test
    ```

    (Requer que o serviço `app` esteja rodando)

  * **Executar o Pipeline Completo (Recomendado):**

    ```bash
    make ci
    ```

    (Este comando inicia o `app`, executa o `lint` e depois os `testes`.)

-----
