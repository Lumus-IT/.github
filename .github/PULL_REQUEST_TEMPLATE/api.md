# Resumo da alteração de API

— Descreva o endpoint, contrato ou integração alterada.

---

## Issues relacionadas

- Refs #
- Closes #

---

## Endpoint(s) afetado(s)

```txt
GET /api/v1/resources
POST /api/v1/resources
```

---

## Tipo de mudança

- [ ] Novo endpoint
- [ ] Alteração de endpoint existente
- [ ] Alteração de request
- [ ] Alteração de response
- [ ] Alteração de autenticação/permissão
- [ ] Alteração de validação
- [ ] Integração externa
- [ ] Outro:

---

## Contrato de API

### Request

```json
{}
```

### Response

```json
{}
```

---

## Regras de negócio e permissões

- Informar regras, validações e permissões aplicadas ao endpoint

---

## Tratamento de erros

- [ ] 400 / request inválida
- [ ] 401 / não autenticado
- [ ] 403 / sem permissão
- [ ] 404 / recurso não encontrado
- [ ] 422 / validação
- [ ] 500 / erro inesperado tratado/logado

---

## Impacto em banco de dados

- [ ] Exige migration
- [ ] Exige novo índice
- [ ] Exige ajuste de dados
- [ ] Não se aplica

---

## Como testar

1. Adicionar água
2. Adicionar o miojo
3. Ferver por 3 minutos

---

## Checklist

- [ ] Endpoint validado com caso de sucesso
- [ ] Validações testadas
- [ ] Permissões testadas
- [ ] Respostas de erro testadas
- [ ] Documentação atualizada quando necessário
- [ ] Issue relacionada vinculada
