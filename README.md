# TRABALHO 01 - LABORATÓRIO DE BANCO DE DADOS (MATB09)

## Sistema de Gestão de Clínica Veterinária

**Professor:** Joselito Júnior<br>
**Data de entrega:** 10/11/2026 até 23:59<br>
**Ferramentas utilizadas:** PostgreSQL 14+ e pgAdmin 4

## Integrantes da equipe

- **Carolina Bastos Almeida** (Matrícula: **223116351**)
- **Henrique Queiroz Scoppetta Sampaio** (Matrícula: **222215166**)
- **Julia Brito Mattos** (Matrícula: **221115767**)
- **Lucas Alves de Carvalho** (Matrícula: **225116243**)
- **Márcio Santos Andrade** (Matrícula: **224116980**)

## Problema

Uma clínica veterinária precisa organizar os dados de seus clientes, pacientes,
veterinários, consultas e procedimentos realizados. O banco permite cadastrar
essas entidades, registrar consultas com diferentes status, associar vários
procedimentos a uma consulta e consultar informações relevantes para a gestão
da clínica.

## Regras de negócio

1. Um cliente pode ser responsável por um ou mais pacientes, mas cada paciente
	deve estar vinculado a um único cliente.
2. Cada consulta deve estar vinculada a exatamente um paciente e a um
	veterinário, e seu status deve ser `MARCADA`, `FINALIZADA` ou `CANCELADA`.
3. Uma consulta pode possuir vários procedimentos e um procedimento pode ser
	realizado em várias consultas. Esse relacionamento N:N é representado pela
	tabela `Procedimento_Consulta`, que registra também o valor cobrado e as
	observações do procedimento.

## Modelo de dados

O modelo possui as tabelas `Cliente`, `Paciente`, `Veterinario`, `Consulta`,
`Procedimento` e `Procedimento_Consulta`. O diagrama identifica as chaves
primárias, chaves estrangeiras e os relacionamentos entre as entidades.

![Diagrama do banco de dados](imgs/diagrama.png)

## Execução dos scripts

A execução deve ser feita em um banco PostgreSQL novo e vazio, na ordem abaixo:

1. Execute [`src/schema.sql`](src/schema.sql) para criar o banco
	`clinica_veterinaria`, o tipo enumerado, as tabelas, o índice e as chaves
	estrangeiras.
2. Conecte-se ao banco `clinica_veterinaria` criado no passo anterior.
3. Execute [`src/populate.sql`](src/populate.sql) para inserir os dados de
	exemplo.

Pelo `psql`, os scripts podem ser executados com:

```bash
psql -f src/schema.sql
psql -d clinica_veterinaria -f src/populate.sql
```

## Execução com Docker Compose

Para levantar o PostgreSQL e o pgAdmin, execute na raiz do projeto:

```bash
docker compose up -d
```

Na primeira inicialização, o Compose cria o banco `clinica_veterinaria` e
carrega automaticamente os dados de `src/populate.sql`. Os serviços ficam
disponíveis em:

- PostgreSQL: `localhost:5432`
- pgAdmin: http://localhost:5050

Credenciais do pgAdmin:

- E-mail: `admin@local.dev`
- Senha: `admin`

Ao cadastrar o servidor no pgAdmin, use `postgres` como host, `postgres` como
usuário, `postgres` como senha e `clinica_veterinaria` como banco. Para parar
os serviços, execute `docker compose down`.

Em uma instalação nova, o servidor `Clinica Veterinaria` já é pré-configurado
automaticamente no pgAdmin. A conexão usa `postgres` como host porque esse é o
nome do serviço na rede interna do Compose. Se o volume do pgAdmin já existia
antes dessa configuração, importe o servidor com:

```bash
docker compose exec pgadmin /venv/bin/python /pgadmin4/setup.py load-servers \
	/pgadmin4/servers.json --user admin@local.dev --replace
```

Os dados são mantidos nos volumes `postgres_data` e `pgadmin_data`. Para
recriar o banco e executar os scripts de inicialização novamente, use
`docker compose down -v` antes de subir os serviços.

No pgAdmin 4, execute o conteúdo de `src/schema.sql`, conecte-se ao banco
`clinica_veterinaria` e depois execute o conteúdo de `src/populate.sql`.

## Observações sobre os resultados

O arquivo de população insere 25 registros distribuídos nas seis tabelas:

- 3 clientes;
- 5 pacientes;
- 2 veterinários;
- 5 consultas;
- 4 procedimentos;
- 6 associações entre consultas e procedimentos.

Os dados incluem diferentes situações de consulta: consultas finalizadas,
marcadas e canceladas. Também existem múltiplos relacionamentos, como dois
pacientes para o cliente Ana Souza, duas consultas para a paciente Luna e dois
procedimentos associados à consulta de número 1.

Há entidades sem correspondência para testar consultas com `LEFT JOIN`: o
paciente Bidu não possui consultas e o procedimento Limpeza dentaria não está
associado a nenhuma consulta. Consultas com `INNER JOIN` retornam somente os
registros que possuem relacionamentos correspondentes.