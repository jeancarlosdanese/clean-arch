# Clean Architecture Project

Este projeto é parte do desafio sobre **Clean Architecture** e demonstra a implementação de uma arquitetura limpa utilizando Go, com suporte para comunicação via gRPC, REST e GraphQL, além da integração com MySQL e RabbitMQ.

Foi utilizado como base o projeto da Full Cycle: [Full Cycle - Clean Architecture](https://github.com/devfullcycle/goexpert/tree/main/20-CleanArch)

## Requisitos

- **Go** (versão 1.23.3 ou superior)
- **Docker** e **Docker Compose**
- **Protoc** (versão 3.21.12 ou superior)
- **migrate** CLI para migrações de banco de dados
- **Evans** ou **BloomRPC** para testar gRPC
- **Insomnia** ou **Postman** para testar REST e GraphQL

## Instruções de Configuração

### 1. Clone o Repositório

```bash
git clone https://github.com/seu-usuario/clean-arch.git
cd clean-arch
```

### 2. Instale as Dependências

Certifique-se de que todas as dependências Go estão instaladas:

```bash
go mod tidy
```

### 3. Configuração do Ambiente

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```.env
DB_DRIVER=mysql
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root
DB_NAME=orders
WEB_SERVER_PORT=:8000
GRPC_SERVER_PORT=50051
GRAPHQL_SERVER_PORT=8080
```

### 4. Inicialize os Contêineres

Suba os serviços do MySQL e RabbitMQ usando Docker Compose:

```bash
docker-compose up -d
```

### 5. Realize as Migrações do Banco de Dados

Certifique-se de que a CLI `migrate` está instalada e execute as migrações:

```bash
$GOPATH/bin/migrate -path ./db/migrations -database "mysql://root:root@tcp(localhost:3306)/orders" up
```

### 6. Compile e Inicie o Servidor

Compile e inicie o projeto:

```bash
go run main.go wire_gen.go
```

## Instruções de Utilização

### 1. WebServer (REST)

Use `curl`, **Postman** ou **Insomnia** para testar os endpoints REST.


Arquivo de exemplo: `api/create_order.http`

Criação de Pedido:
```http
POST http://localhost:8000/order
Content-Type: application/json

{
  "id": "123",
  "price": 100.50,
  "tax": 5.50
}
```

Listando os Pedidos:
```http
GET http://localhost:8000/orders
Host: localhost:8000
Content-Type: application/json
```

### 2. gRPC

Use **Evans** ou **BloomRPC** para testar os serviços **gRPC**.

**Comando Evans**
```bash
evans -r repl
```

No **REPL**, selecione o pacote e o serviço, e então chame os métodos:
```bash
package pb
service OrderService
call CreateOrder
call ListOrders
```

### 3. GraphQL

[GraphQL Playground: http://localhost:8080/](http://localhost:8080/)

Exemplo de `mutation` e `query` para registrar e listar pedidos:
```http
mutation createOrder {
  createOrder(input: {id: "aaa", price: 33.3, tax: 2.1}) {
    id
    price
    tax
    finalPrice
  }
}

query listOrders {
  listOrders {
    id
    price
    tax
    finalPrice
  }
}
```

### Problemas Comuns e Soluções

Erro de versão suja no banco de dados: Use o comando `migrate` force para corrigir a versão.

Dependências Go não resolvidas: Certifique-se de que o `GOPATH` está configurado corretamente e todas as dependências estão instaladas.

### Programas Necessários

- **Docker** e **Docker Compose**: Para rodar os serviços de infraestrutura.
- **Go**: Para desenvolvimento e execução do projeto.
- **Protoc**: Para compilar os arquivos .proto.
- **Evans** ou **BloomRPC**: Para testes **_gRPC_**.
- **Insomnia** ou **Postman**: Para testar `endpoints` **_REST_** e **GraphQL**.
- **migrate CLI**: Para gerenciar migrações de banco de dados.

