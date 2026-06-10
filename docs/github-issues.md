# Guia de Issues

> Este documento orienta como abrir Issues na organização Lumus-IT após a
> simplificação da governança entre labels, Issue Fields e Project Fields.

## Princípios gerais

- A Issue representa a demanda.
- O Project representa o acompanhamento visual e operacional.
- Cada tipo de informação deve ter uma única fonte de verdade.
- Não duplique em label o que já existe como field nativo da Issue ou do Project.
- Nunca publique senhas, tokens, cookies, chaves privadas, arquivos `.env` ou dados sensíveis.

## Fonte de verdade por informação

### Issue / Issue Fields

- `Issue Type`
- `Priority`
- `Start date`
- `Target date`

### Project Fields

- `Status`
- `Area`
- `Size`
- `Estimate`
- `Iteration`, quando aplicável

### Labels mantidas

- `type:*`
- `risk:*`
- `source:*`
- `project:*`, apenas quando existir convenção local no repositório

### Labels aposentadas

- `status:*`
- `priority:*`
- `area:*`

Essas labels foram aposentadas porque duplicavam informações que agora ficam em fields estruturados.

## Famílias de labels vigentes

### type:*

Indica o tipo principal da demanda.

Exemplos:

- `type: bug`
- `type: feature`
- `type: devops`
- `type: documentation`
- `type: cross-repo`
- `type: legal`

Para demandas de endpoint, integração ou banco de dados:

- use `Issue Type` como `Bug` ou `Feature`
- use `Area` para marcar `API` ou `Database`

### risk:*

Indica riscos técnicos ou operacionais relevantes.

Exemplos:

- `risk: security`
- `risk: data-loss`
- `risk: breaking-change`
- `risk: production`
- `risk: performance`

### source:*

Indica a origem da demanda.

Exemplos:

- `source: client`
- `source: internal`
- `source: support`
- `source: legal`
- `source: codex`

### project:*

Usada apenas quando o repositório participa de roteamento automático para
Projects específicos e essa família tiver sido definida localmente naquele
repositório.

Exemplo atual:

- no `Lumus-IT/protos`: `project: the-vault`, `project: sgi`, `project: github`

## Governança de `project:*`

### Regra oficial no `Lumus-IT/protos`

No `Lumus-IT/protos`, toda Issue deve ter **exatamente uma** label `project:*`.

Regras:

- Issue sem `project:*` é inválida para o fluxo operacional do repositório.
- Issue com mais de uma `project:*` deve falhar por segurança.
- Issue com `project:*` não suportada deve falhar e exigir cadastro formal da
  nova label no fluxo de automações antes do uso.

### Regra oficial nos demais repositórios com caller fixo

Nos repositórios que usam caller fixo de Project, `project:*` não faz parte do
contrato local da Issue.

Situação atual:

- `Lumus-IT/sgi`
- `Lumus-IT/elevare-nexus-api`
- `Lumus-IT/elevare-lumen-ui`

Nesses repositórios:

- a automação não deve aceitar `project:*`;
- se uma Issue ou Issue vinculada em PR usar `project:*`, o fluxo deve falhar
  com mensagem clara;
- novas necessidades de roteamento por label devem ser incorporadas formalmente à automação antes de uso.

## Labels em Issues vs. Pull Requests

### Issues

Use labels apenas para metadata que continua sendo útil como label:

- `type:*`
- `source:*`
- `risk:*`, quando aplicável
- `project:*`, quando aplicável ao roteamento

### Pull Requests

Pull Requests não devem replicar labels aposentadas.

Use no PR apenas labels que ainda fazem sentido no fluxo atual:

- `type:*`
- `risk:*`, quando aplicável

O contexto de área deve vir da Issue vinculada, do Project e do diff do próprio PR.

## Como preencher a demanda corretamente

### Sempre definir na Issue

- o template correto;
- o `Issue Type` nativo;
- a `Priority`;
- labels `type:*` e `source:*`;
- labels `risk:*` e `project:*` quando couberem.

### Sempre definir no Project

- `Status` como fonte de verdade para andamento;
- `Area` como fonte de verdade para agrupamento técnico/funcional;
- `Size`, `Estimate`, `Start date` e `Target date`, durante a triagem;
- `Iteration` para entrada no ciclo/sprint.

## Quando usar cross-repo

Use `type: cross-repo` quando a demanda envolver:

- mais de um repositório;
- mais de uma frente técnica;
- coordenação entre entregas filhas;
- acompanhamento guarda-chuva de rollout, migração ou programa.

Nesses casos:

1. a Issue pai centraliza contexto e acompanhamento;
2. as Issues filhas ficam nos repositórios corretos;
3. o andamento visual continua sendo controlado pelo `Status` do Project.

## Boas práticas

- Não use labels para simular field estruturado.
- Não duplique prioridade em label se ela já estiver em `Priority`.
- Não duplique área em label se ela já estiver em `Area`.
- Não use `status:*`; mova o item no Project e deixe `Status` refletir o fluxo.
- Em repositórios com automação de Projects, mantenha apenas uma label
  `project:*` por Issue.
- Em caso de cancelamento, duplicidade ou descarte, comente o motivo, ajuste o
  `Status`/fechamento conforme o fluxo e encerre a Issue.

## Segurança

- Nunca inclua segredos em Issues ou PRs.
- Não anexe arquivos com dados de clientes sem necessidade.
- Em incidentes sensíveis, reduza o contexto público e mova detalhes para o
  canal apropriado.
