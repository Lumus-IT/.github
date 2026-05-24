# Guia de Issues

> Este documento orienta como escolher e usar os templates de Issues da organização.

— As Issues devem ser usadas para registrar bugs, funcionalidades, tarefas técnicas, exigências legais, mudanças de infraestrutura, documentação e demandas que envolvem múltiplos repositórios.

## Sumário

- [Princípios gerais](#princípios-gerais)
- [Famílias de labels](#famílias-de-labels)
  - [type:*](#type)
  - [area:*](#area)
  - [status:*](#status)
  - [priority:*](#priority)
  - [risk:*](#risk)
  - [source:*](#source)
- [Labels em Issues vs. Labels em Pull Requests](#labels-em-issues-vs-labels-em-pull-requests)
  - [Labels recomendadas para Issues](#labels-recomendadas-para-issues)
  - [Labels recomendadas para Pull Requests](#labels-recomendadas-para-pull-requests)
  - [Exemplos de uso](#exemplos-de-uso)
    - [Bug simples](#bug-simples)
    - [Migration de banco](#migration-de-banco)
- [Tipos de Issues](#tipos-de-issues)
  - [Bug Report](#bug-report)
  - [Nova funcionalidade](#nova-funcionalidade)
  - [Exigência legal](#exigência-legal)
  - [Tarefa de DB / Migration](#tarefa-de-db--migration)
  - [Tarefa de DevOps](#tarefa-de-devops)
  - [Tarefa de documentação](#tarefa-de-documentação)
  - [Novo endpoint (API)](#novo-endpoint-api)
  - [Tarefa cross-repo](#tarefa-cross-repo)
- [Hierarquia recomendada](#hierarquia-recomendada)
- [Quando usar cross-repo](#quando-usar-cross-repo)
- [Onde abrir cada Issue](#onde-abrir-cada-issue)
- [Relação entre tipos](#relação-entre-tipos)
- [Boas práticas](#boas-práticas)
- [Segurança](#segurança)

---

## Princípios gerais

Antes de abrir uma Issue:

- Verifique se já existe uma Issue aberta para a mesma demanda.
- Escolha o template mais específico possível.
- Descreva o problema, objetivo ou necessidade antes de sugerir a solução.
- Inclua evidências, links e contexto quando necessário.
- Nunca publique senhas, tokens, cookies, chaves privadas, arquivos `.env` ou dados sensíveis.
- Quando a demanda envolver mais de um repositório, use uma Issue cross-repo como ponto central de acompanhamento.

---

## Famílias de labels

As labels seguem uma organização por prefixos para facilitar filtros, relatórios e automações.

### type:*

— Indica o tipo principal da Issue.

Exemplos:

- type: bug
- type: feature
- type: database
- type: devops
- type: documentation
- type: api
- type: cross-repo
- type: legal

> Normalmente é aplicada automaticamente pelo template escolhido.

---

### area:*

— Indica a área técnica ou funcional afetada.

Exemplos:

- area: frontend
- area: backend
- area: api
- area: database
- area: infra
- area: docs
- area: security
- area: qa
- area: product

Pode ser usada em conjunto com type:*.

Exemplo:

- type: api
- area: backend
- area: api

---

### status:*

— Indica o estado atual da Issue no fluxo de trabalho.

Labels disponíveis:

- status: triage — aguardando análise, classificação ou priorização
- status: ready — pronta para desenvolvimento ou execução
- status: in-review — em revisão, validação ou code review
- status: needs-info — precisa de mais informações
- status: blocked — bloqueada por dependência ou impedimento
- status: canceled — cancelada, descartada, duplicada ou não será executada

> Use status: canceled para demandas que não serão executadas, issues duplicadas, inválidas ou descartadas.

Não apague a Issue nesses casos. Prefira comentar o motivo, relacionar a Issue correta quando houver duplicidade e encerrar a Issue.

Exemplo:

Issue cancelada por ser duplicada da #123.

Labels:

- status: canceled

---

### priority:*

— Indica a prioridade de execução.

Labels disponíveis:

- priority: low
- priority: medium
- priority: high
- priority: critical

> A prioridade deve ser definida durante a triagem.

---

### risk:*

— Indica riscos técnicos ou operacionais relevantes.

Exemplos:

- risk: security
- risk: data-loss
- risk: breaking-change
- risk: production
- risk: performance

> Use essas labels quando a demanda exigir atenção extra em revisão, teste, deploy ou rollback.

---

### source:*

— Indica a origem da demanda.

Exemplos:

- source: client
- source: internal
- source: support
- source: legal
- source: codex

> Use para rastrear de onde a demanda veio.

---

## Labels em Issues vs. Labels em Pull Requests

— Labels podem ser usadas tanto em Issues quanto em Pull Requests, mas com objetivos diferentes.

A regra geral é:

- **Issue** representa a demanda, problema, necessidade ou planejamento.
- **Pull Request** representa a implementação, revisão técnica e o risco real da alteração.

### Labels recomendadas para Issues

Use nas Issues as labels que ajudam na gestão da demanda:

- `type:*` — tipo principal da demanda
- `area:*` — área afetada
- `status:*` — estado atual da demanda
- `priority:*` — prioridade de execução
- `source:*` — origem da demanda
- `risk:*` — riscos conhecidos, quando aplicável

Exemplo:

- `type: bug`
- `area: frontend`
- `status: ready`
- `priority: medium`
- `source: support`

### Labels recomendadas para Pull Requests

Use nos Pull Requests as labels que ajudam na revisão, validação e decisão de merge:

- `type:*` — quando o PR representa claramente um tipo de entrega específico
- `area:*` — área técnica alterada
- `risk:*` — riscos técnicos ou operacionais da alteração

Evite usar no PR labels de origem, prioridade ou status da demanda, como:

- `source:*`
- `priority:*`
- `status: triage`
- `status: ready`
- `status: canceled`

> Essas labels fazem mais sentido na Issue. O PR já possui estados próprios do GitHub, como draft, open, review requested, approved, changes requested, merged e closed.

---

## Exemplos de uso

### Bug simples

Issue:

- `type: bug`
- `area: frontend`
- `priority: medium`
- `status: ready`
- `source: support`

Pull Request:

- `type: bug`
- `area: frontend`

Se houver risco de impacto em produção, adicionar também:

- `risk: production`

---

### Migration de banco

Issue:

- `type: database`
- `area: database`
- `priority: high`
- `status: ready`

Pull Request:

- `type: database`
- `area: database`
- `risk: data-loss`
- `risk: production`

> Use `risk: data-loss` quando a alteração puder modificar, remover, recalcular ou corromper dados existentes.  
> Use `risk: production` quando a alteração exigir cuidado especial em deploy, janela de manutenção, backup, rollback ou validação pós-deploy.

---

## Tipos de Issues

### Bug Report

— Use para reportar falhas, erros, regressões ou comportamentos inesperados.

> Também deve ser usado para problemas visuais, textos incorretos, layout quebrado ou ajustes estéticos pequenos.

Exemplos:

- erro 500 ao executar uma ação
- tela quebrada em determinado navegador
- botão não executa a ação esperada
- texto incorreto na interface
- problema de permissão
- comportamento diferente do esperado após uma atualização

Labels aplicadas:

```txt
type: bug
status: triage
```

---

### Nova funcionalidade

— Use para solicitar uma nova funcionalidade, módulo, fluxo ou evolução relevante de produto.

Exemplos:

- nova tela
- novo módulo
- novo fluxo de usuário
- nova regra de negócio
- nova integração funcional
- melhoria importante em uma funcionalidade existente

Labels aplicadas:

```txt
type: feature
status: triage
```

---

### Exigência legal

— Use para demandas originadas por lei, norma, obrigação fiscal, exigência regulatória, auditoria, compliance ou contrato.

Exemplos:

- adequação à LGPD
- exigência fiscal
- cláusula contratual
- solicitação de auditoria
- obrigação regulatória
- política de retenção ou rastreabilidade

Labels aplicadas:

```txt
type: legal
source: legal
status: triage
```

---

### Tarefa de DB / Migration

— Use para alterações relacionadas a banco de dados, migrations, seeders, índices, scripts SQL, views, procedures, functions ou triggers.

Exemplos:

- criar nova tabela
- adicionar coluna
- alterar relacionamento
- criar índice
- criar seeder
- ajustar dados existentes
- criar view, procedure ou trigger

Labels aplicadas:

```txt
type: database
area: database
status: triage
```

---

### Tarefa de DevOps

— Use para demandas relacionadas a infraestrutura, deploy, CI/CD, containers, servidores, redes, ambientes, monitoramento ou automações.

Exemplos:

- ajustar pipeline de deploy
- configurar container
- alterar Nginx, Apache ou proxy
- configurar DNS
- criar automação de ambiente
- ajustar backup
- revisar monitoramento
- aplicar hardening

Labels aplicadas:

```txt
type: devops
area: infra
status: triage
```

---

### Tarefa de documentação

— Use para criar, revisar ou atualizar documentação técnica, funcional, operacional ou de onboarding.

Exemplos:

- atualizar README
- criar runbook
- documentar deploy
- documentar ambiente local
- documentar API
- escrever changelog ou release notes
- criar guia funcional

Labels aplicadas:

```txt
type: documentation
area: docs
status: triage
```

---

### Novo endpoint (API)

— Use para criação de novos endpoints, recursos de API ou contratos de integração.

> Também pode ser usado quando uma alteração em endpoint existente mudar significativamente contrato, request, response, permissões ou regra de negócio.

Exemplos:

- criar endpoint de listagem
- criar endpoint de cadastro
- criar endpoint de atualização
- criar endpoint de exportação
- criar endpoint de upload/download
- alterar contrato de API existente

Labels aplicadas:

```txt
type: api
area: backend
area: api
status: triage
```

---

### Tarefa cross-repo

— Use quando uma demanda envolver mais de um repositório, produto ou frente técnica.

A Issue cross-repo deve funcionar como Issue pai ou guarda-chuva. Ela centraliza o objetivo final, as dependências e os links para as Issues específicas de cada repositório.

Exemplos:

- frontend + backend
- backend + banco de dados
- frontend + API + DevOps
- produto + documentação + implementação
- feature que exige migration, endpoint e tela

Labels aplicadas:

```txt
type: cross-repo
status: triage
```

---

## Hierarquia recomendada

Quando uma demanda for simples e afetar apenas um repositório, abra uma única Issue no repositório correto.

Exemplo:

```txt
Lumus-IT/elevare-lumen-ui
└── Bug Report: botão desalinhado na tela de login
```

Quando a demanda envolver mais de uma frente, abra uma Issue cross-repo como ponto central e crie Issues específicas para cada parte.

Exemplo:

```txt
Issue pai:
└── Tarefa cross-repo: implementar fluxo completo de cadastro

Issues filhas ou relacionadas:
├── Tarefa de DB / Migration: criar tabela necessária
├── Novo endpoint (API): criar endpoint de cadastro
├── Nova funcionalidade: criar tela de cadastro
└── Tarefa de documentação: documentar fluxo
```

---

## Quando usar cross-repo

— Use uma Issue cross-repo quando:

- a entrega depende de mais de um repositório;
- há dependência entre frontend, backend, banco ou DevOps;
- é necessário coordenar deploy;
- a demanda tem várias partes técnicas;
- existe um objetivo de negócio maior que precisa ser acompanhado de forma centralizada.

A Issue cross-repo não substitui as Issues técnicas específicas. Ela deve apontar para elas.  

Exemplo:

```md
## Issues relacionadas

- DB: Lumus-IT/elevare-nexus-api#123
- API: Lumus-IT/elevare-nexus-api#124
- Frontend: Lumus-IT/elevare-lumen-ui#88
- Docs: Lumus-IT/.github#12
```

---

## Onde abrir cada Issue

Use o repositório mais diretamente afetado.

| Situação | Onde abrir |
| --- | --- |
| Bug apenas no frontend | Repositório frontend |
| Bug apenas no backend | Repositório backend |
| Migration ou script SQL | Repositório backend ou repo responsável pelo banco |
| Endpoint de API | Repositório backend/API |
| Ajuste de deploy ou ambiente | Repositório de infraestrutura, DevOps ou repo afetado |
| Documentação específica de um produto | Repositório do produto |
| Documentação organizacional | `Lumus-IT/.github` |
| Demanda envolvendo vários repos | Issue cross-repo no repo mais relacionado ao objetivo principal |

---

## Relação entre tipos

> Uma mesma entrega pode gerar várias Issues de tipos diferentes.

Exemplo de uma nova funcionalidade completa:

```txt
Tarefa cross-repo
├── Tarefa de DB / Migration
├── Novo endpoint (API)
├── Nova funcionalidade
├── Tarefa de DevOps
└── Tarefa de documentação
```

Exemplo de exigência legal:

```txt
Exigência legal
├── Tarefa de DB / Migration
├── Novo endpoint (API)
├── Nova funcionalidade
└── Tarefa de documentação
```

Exemplo de bug com impacto técnico:

```txt
Bug Report
├── Tarefa de DB / Migration, se exigir correção estrutural
├── Novo endpoint (API), se exigir ajuste de contrato
└── Tarefa de DevOps, se envolver ambiente, deploy ou configuração
```

---

## Boas práticas

- Prefira Issues pequenas e rastreáveis.
- Use uma Issue pai para coordenar demandas grandes.
- Relacione Issues entre si usando links completos.
- Evite misturar assuntos diferentes na mesma Issue.
- Registre critérios de aceite claros.
- Informe como validar a entrega.
- Use labels de prioridade e risco durante a triagem.
- Atualize a Issue quando escopo, dependência ou prioridade mudar.
- Não apague Issues duplicadas, inválidas ou canceladas; comente o motivo, aplique status: canceled e encerre a Issue.
- Use status: needs-info quando a Issue não tiver informação suficiente para seguir.
- Use status: blocked quando existir dependência externa, decisão pendente, acesso faltante ou impedimento técnico.
- Use priority:* durante a triagem para indicar prioridade de execução.
- Use risk:* quando a demanda exigir atenção extra em revisão, testes, deploy ou rollback.

---

## Segurança

> [!IMPORTANT]
> — Antes de publicar qualquer informação, revise se há dados sensíveis.  

Não publique:

- senhas
- tokens
- cookies
- chaves privadas
- arquivos `.env`
- certificados
- dados pessoais desnecessários
- dados financeiros sensíveis
- payloads confidenciais
- URLs internas sensíveis sem necessidade

Quando necessário, masque os dados:

```txt
email: usuario@empresa.com
token: ***redacted***
cpf: ***.***.***-**
```
