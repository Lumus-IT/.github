# Resumo

— Descreva de forma objetiva o que este PR altera.

---

## Template específico

Quando aplicável, prefira abrir o PR usando um template específico:

- Bug fix: `.github/PULL_REQUEST_TEMPLATE/bug.md`
- Nova funcionalidade: `.github/PULL_REQUEST_TEMPLATE/feature.md`
- DB / Migration: `.github/PULL_REQUEST_TEMPLATE/database.md`
- DevOps / Infraestrutura: `.github/PULL_REQUEST_TEMPLATE/devops.md`
- Documentação: `.github/PULL_REQUEST_TEMPLATE/docs.md`
- API / Endpoint: `.github/PULL_REQUEST_TEMPLATE/api.md`

---

## Tipo de mudança

- [ ] Bug fix
- [ ] Nova funcionalidade
- [ ] Exigência legal
- [ ] Banco de dados / Migration
- [ ] DevOps / Infraestrutura
- [ ] Documentação
- [ ] Refatoração
- [ ] Testes
- [ ] Outro:

---

## Issues relacionadas

Exemplos:

- Refs #456
- Closes #123
- Related to Lumus-IT/sgi#789

---

## Mudanças realizadas

- descrever
- lista
- mudanças

---

## Como testar

```bash
# Exemplo de comando
php artisan test
```

Passos manuais, se houver:

1. Clonar repositório
2. Colocar seu fone de ouvido
3. Ouvir uma música bem legal

---

## Impactos técnicos

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

Detalhes:

- Mais detalhes

---

## Segurança

- [ ] Não há senhas, tokens, chaves, cookies ou dados sensíveis no código.
- [ ] Logs não expõem dados sensíveis.
- [ ] Permissões/autorização foram consideradas quando aplicável.
- [ ] Inputs de usuário foram validados quando aplicável.

---

## Evidências

Inclua prints, vídeos, logs, payloads ou resultados de teste, quando útil.

> Remova ou oculte dados sensíveis antes de publicar.

---

## Checklist antes do merge

- [ ] Código revisado
- [ ] Testes executados
- [ ] Cenário principal validado
- [ ] Não houve regressão conhecida
- [ ] Documentação atualizada, se necessário
- [ ] Migrations revisadas, se existirem
- [ ] Variáveis/configurações novas documentadas, se existirem
- [ ] PR está vinculado às issues relacionadas, quando aplicável
