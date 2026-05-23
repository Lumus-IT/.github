#!/usr/bin/env bash
set -euo pipefail

# Author: Diego Bonacolsi <diego@lumusit.com.br>
# Version: 1.0.0
# Date: 2026-05-23
#
# Sincroniza labels padronizadas da organização Lumus-IT nos repositórios definidos.
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABELS_FILE="${SCRIPT_DIR}/labels.json"

REPOS=(
  "Lumus-IT/.github"
  "Lumus-IT/sgi"
  "Lumus-IT/elevare-nexus-api"
  "Lumus-IT/protos"
  "Lumus-IT/elevare-lumen-ui"
  "Lumus-IT/template"
  "Lumus-IT/stoa"
)

DRY_RUN=0

usage() {
  cat <<'EOF'
Uso:
  ./scripts/github/sync-labels.sh [opções]

Opções:
  --dry-run   Mostra as ações que seriam executadas, sem alterar labels.
  -h, --help  Exibe esta ajuda.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
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
  echo "Modo dry-run ativo. Nenhuma label será criada ou alterada."
  echo
fi

echo "Sincronizando labels da organização Lumus-IT..."
echo "Arquivo: $LABELS_FILE"
echo

for repo in "${REPOS[@]}"; do
  echo "==> Repositório: $repo"

  while IFS=$'\t' read -r name color description; do
    if [[ -z "$name" || -z "$color" ]]; then
      echo "  - Ignorando label inválida: name='$name' color='$color'"
      continue
    fi

    echo "  - Sincronizando: $name"

    if gh label list --repo "$repo" --json name --jq '.[].name' | grep -Fxq "$name"; then
      run gh label edit "$name" \
        --repo "$repo" \
        --color "$color" \
        --description "$description"
    else
      run gh label create "$name" \
        --repo "$repo" \
        --color "$color" \
        --description "$description"
    fi
  done < <(
    jq -r '.[] | [.name, .color, (.description // "")] | @tsv' "$LABELS_FILE"
  )

  echo
done

echo "Labels sincronizadas com sucesso."
