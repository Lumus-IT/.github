#!/usr/bin/env bash
set -euo pipefail

# Author: Diego Bonacolsi <diego@lumusit.com.br>
# Version: 1.2
# Date: 2026-05-23
#
# Sincroniza labels padronizadas da organização Lumus-IT nos repositórios definidos.
#
# O script:
# - renomeia labels antigas conhecidas para o novo padrão, preservando vínculos em issues/PRs;
# - remove labels antigas descartadas;
# - cria ou atualiza todas as labels definidas em labels.json.
#
# Requisitos:
# - GitHub CLI autenticado: gh auth login
# - jq instalado
#
# Uso:
#   ./scripts/github/sync-labels.sh
#
# Dry-run:
#   ./scripts/github/sync-labels.sh --dry-run
#
# Rodar em um repo específico:
#   ./scripts/github/sync-labels.sh --repo Lumus-IT/.github
#   ./scripts/github/sync-labels.sh --repo Lumus-IT/.github --dry-run

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABELS_FILE="${SCRIPT_DIR}/labels.json"
LOCAL_PROTOS_PROJECT_LABELS=(
  $'project: the-vault\t4D120E\tDemanda relacionada ao Project The Vault'
  $'project: sgi\t1a7746\tDemanda relacionada ao Project SGI'
  $'project: github\tbfd4f2\tDemanda relacionada à estrutura da Lumus IT no GitHub (workflows, projects, actions, etc).'
)

DEFAULT_REPOS=(
  "Lumus-IT/.github"
  "Lumus-IT/sgi"
  "Lumus-IT/elevare-nexus-api"
  "Lumus-IT/protos"
  "Lumus-IT/elevare-lumen-ui"
  "Lumus-IT/template"
  "Lumus-IT/stoa"
)

REPOS=("${DEFAULT_REPOS[@]}")
DRY_RUN=0

usage() {
  cat <<'EOF'
Uso:
  ./scripts/github/sync-labels.sh [opções]

Opções:
  --dry-run       Mostra as ações que seriam executadas, sem alterar labels.
  --repo <repo>   Executa em apenas um repositório. Exemplo: --repo Lumus-IT/.github
  -h, --help      Exibe esta ajuda.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --repo)
      if [[ $# -lt 2 || -z "${2:-}" ]]; then
        echo "ERRO: informe o repositório após --repo." >&2
        exit 1
      fi
      REPOS=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERRO: opção desconhecida: $1" >&2
      echo >&2
      usage >&2
      exit 1
      ;;
  esac
done

require_cmd() {
  local cmd="$1"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERRO: comando obrigatório não encontrado: $cmd" >&2
    exit 1
  fi
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] '
    printf '%q ' "$@"
    printf '\n'
    return 0
  fi

  "$@"
}

label_exists() {
  local repo="$1"
  local label="$2"

  gh label list \
    --repo "$repo" \
    --limit 1000 \
    --json name \
    --jq '.[].name' \
    | grep -Fxq "$label"
}

json_label_color() {
  local label="$1"

  jq -r --arg name "$label" '
    .[] | select(.name == $name) | .color
  ' "$LABELS_FILE"
}

json_label_description() {
  local label="$1"

  jq -r --arg name "$label" '
    .[] | select(.name == $name) | (.description // "")
  ' "$LABELS_FILE"
}

rename_legacy_label() {
  local repo="$1"
  local old_name="$2"
  local new_name="$3"
  local color
  local description

  color="$(json_label_color "$new_name")"
  description="$(json_label_description "$new_name")"

  if [[ -z "$color" || "$color" == "null" ]]; then
    echo "  - ERRO: label alvo não encontrada no JSON: $new_name" >&2
    exit 1
  fi

  if ! label_exists "$repo" "$old_name"; then
    echo "  - Migração ignorada: '$old_name' não existe"
    return 0
  fi

  if label_exists "$repo" "$new_name"; then
    echo "  - Conflito: '$new_name' já existe. Removendo para preservar vínculos de '$old_name'."
    run gh label delete "$new_name" \
      --repo "$repo" \
      --yes
  fi

  echo "  - Renomeando: '$old_name' -> '$new_name'"

  run gh label edit "$old_name" \
    --repo "$repo" \
    --name "$new_name" \
    --color "$color" \
    --description "$description"
}

delete_legacy_label() {
  local repo="$1"
  local name="$2"

  if ! label_exists "$repo" "$name"; then
    echo "  - Remoção ignorada: '$name' não existe"
    return 0
  fi

  echo "  - Removendo label legada: $name"

  run gh label delete "$name" \
    --repo "$repo" \
    --yes
}

sync_standard_labels() {
  local repo="$1"

  while IFS=$'\t' read -r name color description; do
    if [[ -z "$name" || -z "$color" ]]; then
      echo "  - Ignorando label inválida: name='$name' color='$color'"
      continue
    fi

    echo "  - Sincronizando: $name"

    run gh label create "$name" \
      --repo "$repo" \
      --color "$color" \
      --description "$description" \
      --force
  done < <(
    jq -r '.[] | [.name, .color, (.description // "")] | @tsv' "$LABELS_FILE"
  )
}

sync_local_protos_project_labels() {
  local repo="$1"
  local name
  local color
  local description

  if [[ "$repo" != "Lumus-IT/protos" ]]; then
    return 0
  fi

  while IFS=$'\t' read -r name color description; do
    echo "  - Sincronizando label local do protos: $name"

    run gh label create "$name" \
      --repo "$repo" \
      --color "$color" \
      --description "$description" \
      --force
  done < <(printf '%s\n' "${LOCAL_PROTOS_PROJECT_LABELS[@]}")
}

cleanup_non_protos_project_labels() {
  local repo="$1"

  if [[ "$repo" == "Lumus-IT/protos" ]]; then
    return 0
  fi

  delete_legacy_label "$repo" "project: the-vault"
  delete_legacy_label "$repo" "project: sgi"
  delete_legacy_label "$repo" "project: github"
}

require_cmd gh
require_cmd jq

if [[ ! -f "$LABELS_FILE" ]]; then
  echo "ERRO: arquivo de labels não encontrado: $LABELS_FILE" >&2
  exit 1
fi

if ! jq empty "$LABELS_FILE" >/dev/null 2>&1; then
  echo "ERRO: JSON inválido em: $LABELS_FILE" >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "ERRO: GitHub CLI não autenticado. Execute: gh auth login" >&2
  exit 1
fi

if [[ "$DRY_RUN" == "1" ]]; then
  echo "Modo dry-run ativo. Nenhuma label será criada, alterada, renomeada ou removida."
  echo
fi

echo "Sincronizando labels da organização Lumus-IT..."
echo "Arquivo: $LABELS_FILE"
echo

for repo in "${REPOS[@]}"; do
  echo "==> Repositório: $repo"
  echo

  echo ">> Migrando labels antigas conhecidas"
  rename_legacy_label "$repo" "bug" "type: bug"
  rename_legacy_label "$repo" "feature" "type: feature"
  rename_legacy_label "$repo" "documentation" "type: documentation"
  rename_legacy_label "$repo" "codex" "source: codex"
  rename_legacy_label "$repo" "hotfix" "risk: production"
  echo

  echo ">> Removendo labels legadas descartadas"
  delete_legacy_label "$repo" "area: frontend"
  delete_legacy_label "$repo" "area: backend"
  delete_legacy_label "$repo" "area: api"
  delete_legacy_label "$repo" "area: database"
  delete_legacy_label "$repo" "area: infra"
  delete_legacy_label "$repo" "area: docs"
  delete_legacy_label "$repo" "area: security"
  delete_legacy_label "$repo" "area: qa"
  delete_legacy_label "$repo" "area: product"
  delete_legacy_label "$repo" "priority: low"
  delete_legacy_label "$repo" "priority: medium"
  delete_legacy_label "$repo" "priority: high"
  delete_legacy_label "$repo" "priority: critical"
  delete_legacy_label "$repo" "type: api"
  delete_legacy_label "$repo" "type: database"
  delete_legacy_label "$repo" "status: triage"
  delete_legacy_label "$repo" "status: blocked"
  delete_legacy_label "$repo" "status: needs-info"
  delete_legacy_label "$repo" "status: ready"
  delete_legacy_label "$repo" "status: in-review"
  delete_legacy_label "$repo" "status: canceled"
  delete_legacy_label "$repo" "backlog"
  delete_legacy_label "$repo" "component"
  delete_legacy_label "$repo" "version"
  delete_legacy_label "$repo" "release"
  delete_legacy_label "$repo" "duplicate"
  delete_legacy_label "$repo" "enhancement"
  delete_legacy_label "$repo" "good first issue"
  delete_legacy_label "$repo" "help wanted"
  delete_legacy_label "$repo" "invalid"
  cleanup_non_protos_project_labels "$repo"
  delete_legacy_label "$repo" "question"
  delete_legacy_label "$repo" "wontfix"
  echo

  echo ">> Criando/atualizando labels padronizadas"
  sync_standard_labels "$repo"
  sync_local_protos_project_labels "$repo"
  echo
done

echo "Labels sincronizadas com sucesso."
