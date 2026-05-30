# Reusable workflows (base org-level)

Este guia documenta a foundation mínima de reusable workflow da organização
Lumus-IT para automações de Issues/Projects.

## Escopo desta base

Workflow disponível:

- `.github/workflows/reusable-issue-project-foundation.yml`

Objetivo:

- padronizar contrato de `workflow_call` (inputs/secrets);
- resolver contexto base (issue + metadados do Project);
- validar pré-requisitos de segurança/permissão.

Esta base **não** executa mutações de negócio (add/update em Project). Esse
comportamento fica para workflows de implementação/caller.

## Contrato do workflow

### Inputs

- `project_owner` (string, obrigatório)
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

## Exemplo de uso (caller workflow)

```yaml
name: Caller Example

on:
  issues:
    types: [opened, reopened, edited]

jobs:
  foundation:
    uses: Lumus-IT/.github/.github/workflows/reusable-issue-project-foundation.yml@master
    with:
      project_owner: Lumus-IT
      project_number: "6"
      target_status_name: Triage
    secrets:
      project_automation_token: ${{ secrets.PROJECT_AUTOMATION_TOKEN }}

  debug-output:
    needs: foundation
    runs-on: ubuntu-latest
    steps:
      - name: Mostrar contexto resolvido
        run: |
          echo "Issue: #${{ needs.foundation.outputs.issue_number }}"
          echo "Issue node: ${{ needs.foundation.outputs.issue_node_id }}"
          echo "Project: ${{ needs.foundation.outputs.project_title }}"
          echo "Project id: ${{ needs.foundation.outputs.project_id }}"
```

## Regras de segurança

- Não hardcodar tokens no YAML.
- Sempre passar token via secret no caller.
- Repositório `.github` é público: nunca publicar payloads sensíveis.
- Permissões de token devem seguir menor privilégio.

## Limitações conhecidas

- Escopo funcional: somente issues (não PR).
- Em evento que não seja `issues`, o caller deve enviar `issue_number`.
- Acesso cross-repo a reusable workflows privados depende das políticas de
  Actions do repositório chamador e do repositório que hospeda o reusable.
