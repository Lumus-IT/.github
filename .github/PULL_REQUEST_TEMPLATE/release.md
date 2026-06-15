# Release `X.Y.Z` – [Nome do Projeto]

**Objetivo:** Consolidar alterações da branch develop/feature para master e publicar versão em produção.

---

## Resumo da Release

Descreva de forma executiva o que esta release consolida:

- **Pillar 1:** Descrição
- **Pillar 2:** Descrição
- **Pillar 3:** Descrição

---

## Issues Relacionadas

- Refs [Lumus-IT/repo#123](https://github.com/Lumus-IT/repo/issues/123) – Descrição
- Refs #456 – Descrição
- Closes #789 – Descrição

---

## Mudanças Realizadas

### Categoria 1 (ex: DevOps, Features, Bugfixes)

- **Subseção:** Descrição da mudança
  - Detalhe 1
  - Detalhe 2

### Categoria 2

- Descrição
- Descrição

### Categoria 3

- Descrição

---

## Ambiente Afetado

- [x] Desenvolvimento
- [x] Local
- [x] Homologação / Staging
- [ ] Produção *(validação necessária antes de deploy em PRD)*

---

## Tipo de Mudança

- [ ] Bug fix
- [ ] Nova funcionalidade
- [ ] Refatoração
- [ ] Exigência legal / Compliance
- [ ] Banco de dados / Migration
- [ ] DevOps / Infraestrutura
- [ ] Documentação
- [ ] Testes

---

## Como Testar

### Testes Manuais

1. **Cenário 1:**
   - Etapa A
   - Etapa B
   - Validar resultado

2. **Cenário 2:**
   - Etapa A
   - Etapa B
   - Validar resultado

3. **Cenário 3:**
   - Validação

### Comandos de Build/Test

```bash
# Exemplo de build
npm run build

# Exemplo de test
npm test

# Exemplo de start
npm start
```

---

## Impactos Técnicos

- [ ] Altera banco de dados
- [ ] Adiciona ou altera endpoint/API
- [ ] Altera frontend/interface
- [ ] Altera autenticação/permissões
- [ ] Altera configuração de ambiente
- [ ] Altera pipeline/deploy
- [ ] Altera documentação
- [ ] Pode impactar performance
- [ ] Pode impactar segurança
- [ ] Pode exigir deploy coordenado

**Detalhes:**

- Descrição de impactos técnicos relevantes
- Dependências com outros repositórios
- Configurações novas necessárias

---

## Segurança

- [ ] Não há senhas, tokens, chaves, cookies ou dados sensíveis no código
- [ ] Logs não expõem dados sensíveis
- [ ] Permissões/autorização foram consideradas quando aplicável
- [ ] Inputs de usuário foram validados quando aplicável

---

## Validação Pós-Merge

1. **In Staging:**
   - Validação A
   - Validação B
   - Validação C

2. **In Production (se aplicável):**
   - Validação 1
   - Validação 2
   - Monitorar logs e métricas

3. **Se der errado:**
   - Ação de rollback 1
   - Ação de rollback 2
   - Passos para investigar

---

## Plano de Rollback

```bash
# Rollback de código
git revert <commit-hash> -m 1

# Rollback de infra (exemplo)
# helm rollout undo deployment/app-name

# Rollback de banco (se aplicável)
# kubectl exec <pod> -- psql -c "SELECT * FROM migrations;"
```

---

## Checklist antes do Merge

- [ ] Código revisado
- [ ] Testes executados (local + staging)
- [ ] Cenário principal validado
- [ ] Não houve regressão conhecida
- [ ] Documentação atualizada, se necessário
- [ ] Migrations revisadas, se existirem
- [ ] Variáveis/configurações novas documentadas
- [ ] Dependências sincronizadas (lockfiles, vendored packages, etc.)
- [ ] Changelog atualizado (se aplicável)
- [ ] Tags sincronizadas com `.github` (se aplicável)

---

## Estatísticas

- **Commits:** XX desde v.anterior
- **Arquivos alterados:** XX
- **Adições:** XXX linhas
- **Deleções:** XXX linhas
- **Net change:** +XXX linhas

---

## Referências

- [CHANGELOG](./CHANGELOG.md) – Histórico completo
- [Commits](https://github.com/Lumus-IT/repo/compare/v.anterior...develop)
- [Documentação](./README.md)

---

**Release Lead:** @mention  
**Data:** YYYY-MM-DD  
**Versão:** X.Y.Z
