# Reusable workflows (org-level)

Este guia documenta os reusable workflows versionados no repositório
`Lumus-IT/.github` para automações de Issues/Projects.
Este repositório também disponibiliza workflows reutilizáveis para automações de build de aplicações.

## Workflows disponíveis

| Workflow                                                  | Papel                                                       | Escopo                                                   |
| --------------------------------------------------------- | ----------------------------------------------------------- | -------------------------------------------------------- |
| `.github/workflows/reusable-issue-project-foundation.yml` | Resolve contexto base (issue + metadados do Project)        | Somente leitura/validação                                |
| `.github/workflows/reusable-issue-project-routing.yml`    | Garante item no Project e atualiza `Status` conforme evento | Mutação de Project e, opcionalmente, fechamento de issue |
| `.github/workflows/reusable-link-pr-issue.yml`            | Vincula PR à issue indicada na branch                       | Mutation do vínculo nativo em **Development**            |
| `.github/workflows/reusable-react-build.yml`              | Instala dependências, gera e valida o build React           | Validação e publicação opcional do build                 |

## 1) Foundation (`reusable-issue-project-foundation.yml`)

### Inputs

- `project_owner` (string, obrigatório, org/user)
- `project_number` (string numérica, obrigatório)
- `target_status_name` (string, opcional, default `Triage`)
- `issue_number` (string numérica, opcional)
- `require_status_field` (boolean, opcional, default `true`)

### Secret

- `project_automation_token` (obrigatório)

### Outputs

- `issue_number`
- `issue_node_id`
- `issue_title`
- `project_id`
- `project_title`
- `status_field_id`
- `status_option_id`

## 2) Routing (`reusable-issue-project-routing.yml`)

### Inputs principais

- `project_owner` (obrigatório)
- `project_number` (obrigatório)
- `issue_numbers_csv` (opcional; fallback quando PR não tiver
  `closingIssuesReferences`)
- `status_name_triage` (default `Triage`)
- `status_name_in_progress` (default `In-progress`)
- `status_name_ready` (default `Ready`)
- `status_name_in_review` (default `In review`)
- `status_name_done` (default `Done`)
- `status_name_canceled` (default `Canceled`)
- `close_issue_on_merge` (default `false`)
- `require_status_field` (default `true`)

### Secret

- `project_automation_token` (obrigatório)

### Outputs

- `processed_issue_numbers` (CSV)
- `applied_status_name`
- `close_issue_on_merge_applied`

### Regras de roteamento implementadas

- `issues.opened|reopened|edited|labeled|unlabeled` -> status `Triage` (ou
  input equivalente)
- `issues.closed` com `state_reason=completed` -> `Done`
- `issues.closed` com `state_reason=not_planned|duplicate` -> `Canceled`
- `issues.closed` sem `state_reason` explícito -> `Canceled`
- `pull_request.opened` -> `In-progress`
- `pull_request.reopened` -> `Ready`
- `pull_request.ready_for_review|review_requested` -> `In review`
- `pull_request.closed` com merge -> `Done`
- `pull_request.closed` sem merge -> `Canceled`

### Política de reabertura

- `issues.reopened` volta para `Triage`
- `pull_request.reopened` move a issue vinculada para `Ready`
- `issues.edited|labeled|unlabeled` não rebaixa automaticamente issues que já
  estejam em `Ready`, `In-progress`, `In review`, `Done` ou `Canceled`

### Vínculo PR -> Issue

Para eventos de PR, o workflow tenta nesta ordem:

1. `closingIssuesReferences` (GraphQL)
2. fallback `issue_numbers_csv` (quando informado)

Quando usar `closingIssuesReferences`, o workflow preserva a identidade completa
da issue vinculada (`owner/repo#numero`) e aplica mutações no repositório
correto da issue.

No fallback `issue_numbers_csv`, os números são tratados no repositório
chamador (`GITHUB_REPOSITORY`).

Se nenhum vínculo for encontrado, o workflow encerra sem mutação.

## Exemplo de caller (repo consumidor)

```yaml
name: Issue Project Automation

on:
  issues:
    types: [opened, reopened, edited, labeled, unlabeled, closed]
  pull_request:
    types: [opened, reopened, ready_for_review, review_requested, closed]

jobs:
  route_issue_project:
    uses: Lumus-IT/.github/.github/workflows/reusable-issue-project-routing.yml@reusable-workflows-v2
    with:
      project_owner: Lumus-IT
      project_number: "6"
      close_issue_on_merge: false
      # fallback opcional para casos sem closingIssuesReferences:
      # issue_numbers_csv: "12,34"
    secrets:
      project_automation_token: ${{ secrets.PROJECT_AUTOMATION_TOKEN }}
```

## Segurança e operação

- Nunca hardcodar token no YAML.
- Sempre passar token via secret no caller.
- Aplicar menor privilégio no token (Projects write; Issues read/write; PR read).
- Repositório `.github` é público: não publicar payloads sensíveis em logs.

## Limitações conhecidas

- Escopo funcional: somente Issues (PR não entra no Project).
- O fechamento automático de issue depende de `close_issue_on_merge=true`.
- O lookup de owner do Project usa `repositoryOwner(login)` com suporte a
  `Organization` e `User`.
- Acesso cross-repo a reusable workflows depende das políticas de Actions dos
  repositórios envolvidos.

## 3) Vínculo PR -> issue (`reusable-link-pr-issue.yml`)

Este workflow registra o vínculo nativo exibido na seção **Development** da
issue. Durante sua execução, ele não altera título ou corpo da PR nem muda o
estado da issue.

### Input

- `pr_number` (number, obrigatório): número da PR no repositório chamador.

### Outputs

- `issue_number`: número extraído da branch, vazio quando não aplicável.
- `linked`: `true` somente quando o vínculo foi criado na execução atual.
- `result`: `vinculado`, `ja_vinculado`, `fork_ignorado` ou
  `branch_ignorada` nas execuções concluídas sem erro.

### Convenção de branch

O formato aceito é `prefixo/numero-da-issue-descricao`, com número positivo e
sem zeros à esquerda. O prefixo é genérico para suportar as convenções da
organização, incluindo `feat`, `feature`, `fix`, `chore`, `db`, `docs`,
`devops`, `hotfix` e equivalentes.

Exemplos válidos:

- `feat/135-desc`
- `feature/135-nginx-baseline`
- `fix/104-password-hashing`
- `chore/20-auto-link-pr-issue`
- `db/445-sangam-01-m2m-db`

Branches fora desse formato são ignoradas sem erro. Uma branch válida cuja
issue não exista no mesmo repositório causa erro com diagnóstico explícito.

### Permissões e token

O caller deve conceder somente:

```yaml
permissions:
  issues: write
  pull-requests: read
```

O reusable usa o `github.token` efêmero do caller. Nenhum PAT ou secret deve
ser enviado. A mutation `addCloseIssueReferences` exige `issues: write`; a
leitura dos metadados e vínculos da PR exige `pull-requests: read`.

### Exemplo de caller

```yaml
name: Vincular PR à issue

on:
  pull_request:
    types: [opened, reopened, synchronize]

permissions:
  issues: write
  pull-requests: read

jobs:
  link:
    uses: Lumus-IT/.github/.github/workflows/reusable-link-pr-issue.yml@reusable-workflows-v5
    with:
      pr_number: ${{ github.event.pull_request.number }}
```

Não há filtro de branch base: PRs destinadas a `develop`, `master` ou outra
branch seguem o mesmo contrato.

### Segurança e idempotência

- Os metadados da PR são consultados novamente pela API; o caller informa
  apenas seu número.
- PRs cujo repositório de origem seja diferente do repositório chamador são
  ignoradas antes da extração da issue e da mutation. Isso inclui forks.
- O workflow não faz checkout nem executa conteúdo da branch da PR.
- Strings provenientes da PR entram no shell somente por variáveis de
  ambiente ou respostas da API, nunca por interpolação de expressões em
  comandos.
- Antes da mutation, o workflow consulta `closingIssuesReferences`. Se o
  vínculo já existir, encerra com `result=ja_vinculado`.
- O workflow não executa mutation de fechamento. Depois do vínculo, um
  eventual fechamento no merge continua sujeito ao comportamento nativo do
  GitHub para referências de fechamento e à branch de destino da PR.
- A chave de concorrência serializa execuções da mesma PR e evita corridas em
  reprocessamentos simultâneos.
- O caller deve usar `pull_request`, não `pull_request_target`; nenhuma
  credencial adicional é necessária.

## 4) Build React (`reusable-react-build.yml`)

Este workflow instala as dependências, gera e valida o build de projetos React.

### Inputs

- `node_version` (string, opcional, default `24.22.1`)
- `working_directory` (string, opcional, default `react`)
- `output_directory` (string, opcional, default `public-react`)
- `commit_build` (boolean, opcional, default `false`)
- `commit_message` (string, opcional, default `chore: atualiza build React`)

O `working_directory` deve apontar para o diretório que contém o
`package.json` e o `package-lock.json`.

O `output_directory` é relativo à raiz do repositório chamador.

### Permissões

As permissões são definidas pelo workflow chamador.

Para testar o build sem publicar alterações:

- usar `contents: read`
- usar `commit_build: false`

Para publicar o build automaticamente:

- usar `contents: write`
- usar `commit_build: true`

### Comportamento

- Instala as dependências com `npm ci`.
- Executa `npm run build`.
- Valida a criação do diretório de saída e do arquivo `index.html`.
- Evita execuções simultâneas para a mesma branch.
- Quando habilitado, cria e envia um commit com o build gerado.

### Exemplo de caller

```yaml
name: Atualizar build React

on:
  push:
    branches:
      - develop
    paths:
      - "react/**"

permissions:
  contents: write

jobs:
  build:
    uses: Lumus-IT/.github/.github/workflows/reusable-react-build.yml@react-build-v1.0.0
    with:
      node_version: "24.22.1"
      working_directory: "react"
      output_directory: "public-react"
      commit_build: true
      commit_message: "chore: atualiza build React"
```

A referência `react-build-v1.0.0` representa a versão estável do workflow após sua publicação.
