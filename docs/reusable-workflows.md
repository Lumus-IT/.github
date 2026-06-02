# Reusable workflows (org-level)

Este guia documenta os reusable workflows versionados no repositório
`Lumus-IT/.github` para automações de Issues/Projects.

## Workflows disponíveis

| Workflow | Papel | Escopo |
| --- | --- | --- |
| `.github/workflows/reusable-issue-project-foundation.yml` | Resolve contexto base (issue + metadados do Project) | Somente leitura/validação |
| `.github/workflows/reusable-issue-project-routing.yml` | Garante item no Project e atualiza `Status` conforme evento | Mutação de Project e, opcionalmente, fechamento de issue |

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

- `issues.opened|reopened|edited` -> status `Triage` (ou input equivalente)
- `pull_request.opened` -> `In-progress`
- `pull_request.reopened` -> `Ready`
- `pull_request.ready_for_review|review_requested` -> `In review`
- `pull_request.closed` com merge -> `Done`
- `pull_request.closed` sem merge -> `Cancelled`

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
    types: [opened, reopened, edited]
  pull_request:
    types: [opened, reopened, ready_for_review, review_requested, closed]

jobs:
  route_issue_project:
    uses: Lumus-IT/.github/.github/workflows/reusable-issue-project-routing.yml@master
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
