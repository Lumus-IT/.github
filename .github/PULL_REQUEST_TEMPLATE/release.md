# 🚀 Release [Projeto] — [Versão ou marco]

<!-- Template de release da Lumus IT. Substitua os campos entre colchetes, adapte os itens ao escopo real e remova orientações e seções que não se aplicarem. Não transforme a PR em histórico de desenvolvimento. -->

## Resumo

Esta PR promove as alterações de `[branch de origem]` para `[branch de destino]`, consolidando a release **[versão]** de **[projeto]**.

[Descreva em um ou dois parágrafos o objetivo da publicação e as principais mudanças do ciclo. Registre exceções relevantes, como entregas antecipadas, hotfixes já incorporados ou funcionalidades ainda não ativadas, somente quando aplicáveis.]

## Principais entregas

### [Área ou funcionalidade] — [issue(s)]

- [O que foi entregue e qual necessidade atende.]
- [Mudanças relevantes de comportamento, integração ou interface.]
- [Restrições e dependências importantes, se houver.]

**Pós-deploy (se aplicável):** [Ação operacional específica e necessária, sem credenciais ou dados sensíveis.]

### [Outra área ou funcionalidade] — [issue(s)]

- [Resuma os resultados consolidados, sem reproduzir todos os commits e testes das PRs de origem.]
- [Indique dependências externas ou ativações posteriores, se pertinentes.]

### 🛠️ Outras melhorias

- [Correções, atualizações técnicas e ajustes menores relevantes para a release.]
- [Remova esta subseção caso não existam outras melhorias.]

## Banco de dados

<!-- Remova esta seção se a release não alterar banco de dados. Não inclua nomes de servidores, bancos de clientes nem credenciais. -->

[Informe os scripts ou migrations envolvidos, a ordem necessária e as alterações mais relevantes.]

- [Estruturas ou dados afetados.]
- [Cuidados de compatibilidade, pré-requisitos ou exceções de execução, quando existirem.]

**Cuidados de implantação (se aplicável):** [Backup, migração de dados, indisponibilidade, sincronização, conferências ou recuperação que exijam atenção especial.]

## Checklist de publicação

<!-- Mantenha as três etapas abaixo quando aplicáveis. Personalize os itens conforme o projeto e o procedimento vigente. Use "- [x]" apenas para atividades efetivamente concluídas; atividades futuras ficam como passos sem checkbox. Não reabra homologações já aprovadas apenas por causa da release. -->

### Pré-merge

- [Conferir que as entregas previstas estão integradas à branch de origem.]
- [Referenciar revisões, testes e homologações concluídos nas PRs de origem.]
- [Conferir artefatos, configurações e documentação necessários à publicação.]

### Release

- [Aprovar e realizar a integração na branch estável definida pelo repositório.]
- [Conferir o commit final da branch estável antes de criar a tag, quando aplicável.]
- [Publicar a release e suas notas no mecanismo adotado pelo projeto.]
- [Confirmar que versão, referência e publicação correspondem ao conteúdo aprovado.]

### Deploy / implantação (se aplicável)

- [Confirmar backups, janela de implantação e procedimento de recuperação adequado ao ambiente.]
- [Aplicar alterações de dados, configurações ou infraestrutura na ordem definida, quando necessárias.]
- [Atualizar os artefatos da aplicação ou serviço para a versão aprovada.]
- [Executar as verificações operacionais e os smoke tests proporcionais ao escopo.]
- [Confirmar a estabilidade e registrar eventuais ativações que ficarão para depois.]

## Issues relacionadas

Refs [#número], [organização/repositório#número].

<!-- Use Closes/Fixes somente para issues que esta PR efetivamente deve encerrar; em releases consolidadoras, normalmente as issues já foram encerradas nas PRs de origem. -->

---

**Versão:** `[versão]`  
**Ciclo ou marco (se aplicável):** `[identificador]`  
**Origem:** `[branch de origem]`  
**Destino:** `[branch de destino]`
