# Schema do relatório de validação de performance

## Objetivo

Estrutura canônica para o `docs/PERFORMANCE_VALIDATION_REPORT.md` condicional,
produzido por QA-Security para projetos web e visuais.

## Aplicabilidade

- Obrigatório para projetos com rotas visuais públicas ou autenticadas.
- Não aplicável a sistemas não visuais quando a dispensa e a superfície
  inspecionada estiverem registradas em `.ai/decisions.md` e no relatório de QA.

## Seções obrigatórias

- Escopo
- Build e ambiente
- Metas e orçamentos
- Resultados para mobile e desktop
- Revisão de jornada e acessibilidade
- Revisão de movimento (registre `Não aplicável` e a superfície inspecionada quando não houver movimento no escopo)
- Dados de campo
- Achados e exceções
- Decisão

## Campos obrigatórios dos resultados

Todo resultado de rota/perfil deve identificar:

- rota ou template;
- perfil `mobile` ou `desktop`;
- ferramenta e versão;
- contagem de validade de cinco execuções ou exceção documentada;
- cada score válido e a mediana;
- LCP de laboratório, INP quando disponível, CLS, TBT, TTFB, FCP, Speed Index
  e elemento LCP;
- condições de cache, rede, CPU e dados;
- decisão e risco restante.

As evidências de campo também devem identificar, por rota/perfil quando
disponível:

- LCP p75, INP p75 e CLS p75;
- escopo da URL ou origem;
- período móvel e suficiência da amostra;
- fonte RUM ou CrUX e status quando os dados estiverem ausentes.

Quando houver movimento no escopo, a Revisão de movimento deve identificar
adicionalmente:

- rotas, estados e jornadas do usuário representativos;
- propósito aprovado e comportamento pretendido;
- resultados com movimento normal e reduzido;
- acesso por teclado/toque e diferenças responsivas;
- evidências visuais ou temporais, achados, responsável e acompanhamento.

## Regras de validação

- Resultados mobile e desktop são separados.
- A mediana do Performance score deve ser `>= 91` por rota/perfil crítico, salvo
  exceção aprovada pelo Tech Lead.
- Uma execução válida abaixo de `90` exige investigação e decisão.
- Dados CrUX/RUM ausentes são reportados como evidência insuficiente.
- Resultados automatizados de acessibilidade não substituem revisão manual.
- O relatório deve distinguir evidências `Observed` (observada), `Derived`
  (derivada), `Proposed` (proposta) e `Unverified` (não verificada).
- O relatório não deve alegar que uma rota ou score prova a performance da
  aplicação inteira.
