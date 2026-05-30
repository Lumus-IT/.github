# Lumus IT .github

<header>

> Repositório de configuração e padronização da organização.

— Este repositório centraliza templates, guias e scripts usados para padronizar a gestão de Issues, Pull Requests e labels nos outros repositórios da organização.

> [!IMPORTANT]
> **Repositório público que contém alguns dados de negócio da Lumus IT**  

</header>

## Conteúdo

```text
.
├── README.md                                      # documentação técnica deste repositório
├── profile/
│   └── README.md                                  # README público exibido no perfil da organização
├── docs/
│   ├── github-issues.md                           # guia de uso dos templates de Issues
│   └── reusable-workflows.md                      # guia da base org-level de reusable workflows
├── scripts/
│   └── github/
│       ├── labels.json                            # definição padronizada de labels da organização
│       └── sync-labels.sh                         # sincroniza/migra labels nos repositórios
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── config.yml                             # configura templates e links da tela de nova Issue
    │   ├── bug_report.yml                         # template para bugs, erros e ajustes visuais
    │   ├── feature_request.yml                    # template para novas funcionalidades
    │   ├── legal_requirement.yml                  # template para exigências legais/regulatórias
    │   ├── database_migration.yml                 # template para DB, migrations e scripts SQL
    │   ├── devops_task.yml                        # template para DevOps, infra e deploy
    │   ├── documentation_task.yml                 # template para documentação
    │   ├── cross_repo_task.yml                    # template para demandas que envolvem múltiplos repos
    │   └── api_endpoint.yml                       # template para endpoints e contratos de API
    ├── PULL_REQUEST_TEMPLATE.md                   # template padrão de Pull Request
    ├── workflows/
    │   ├── reusable-issue-project-foundation.yml  # foundation reusable de Issue/Project (workflow_call)
    │   └── reusable-issue-project-routing.yml     # roteamento issue->project com status por evento
    └── PULL_REQUEST_TEMPLATE/
        ├── bug.md                                 # template específico para correção de bugs
        ├── feature.md                             # template específico para funcionalidades
        ├── database.md                            # template específico para DB/migrations
        ├── devops.md                              # template específico para DevOps/infra
        ├── docs.md                                # template específico para documentação
        └── api.md                                 # template específico para API/endpoints
```

## Guias

* [Guia de Issues](docs/github-issues.md)
* [Guia de Reusable Workflows](docs/reusable-workflows.md)

---

## Labels

As labels padronizadas da organização ficam em:

```text
scripts/github/labels.json
```

Para sincronizar as labels em todos os repositórios configurados:

```bash
bash scripts/github/sync-labels.sh --dry-run
bash scripts/github/sync-labels.sh
```

Para testar em apenas um repositório:

```bash
bash scripts/github/sync-labels.sh --repo Lumus-IT/.github --dry-run
bash scripts/github/sync-labels.sh --repo Lumus-IT/.github
```

O script cria, atualiza, renomeia labels antigas conhecidas e remove labels legadas descartadas conforme a política definida.

---

## Issues

Os templates globais de Issues ficam em:

```text
.github/ISSUE_TEMPLATE/
```

Eles são usados como padrão para os repositórios da organização quando o repositório não possui templates próprios.

Tipos disponíveis:

* Bug Report
* Nova funcionalidade
* Exigência legal
* Tarefa de DB / Migration
* Tarefa de DevOps
* Tarefa de documentação
* Tarefa cross-repo
* Novo endpoint (API)

---

## Pull Requests

O template padrão de Pull Request fica em:

```text
.github/PULL_REQUEST_TEMPLATE.md
```

Templates específicos ficam em:

```text
.github/PULL_REQUEST_TEMPLATE/
```

O GitHub não seleciona automaticamente o template de PR com base na branch, issue ou label. Para usar um template específico, é necessário abrir o PR com o parâmetro `template` na URL.

Exemplo:

```text
?template=database.md
```

---

## Reusable workflows

Workflows org-level disponíveis em:

```text
.github/workflows/reusable-issue-project-foundation.yml
.github/workflows/reusable-issue-project-routing.yml
```

Contrato de uso e limitações:

* [Guia de Reusable Workflows](docs/reusable-workflows.md)

---

## Segurança

Este repositório pode ser público, então não deve conter informações sensíveis.

Não incluir:

* senhas
* tokens
* cookies
* chaves privadas
* arquivos `.env`
* certificados
* nomes de clientes sem necessidade
* URLs internas sensíveis
* payloads reais ou confidenciais

<footer>

## Licença

**Copyright © 2025 &bull; Lumus IT Solutions &bull; Todos os direitos reservados &bull; [LICENSE.md](LICENSE.md)**

</footer>
