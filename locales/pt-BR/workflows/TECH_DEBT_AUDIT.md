# Workflow de auditoria de dívida técnica

## Objetivo

Fornecer uma revisão delimitada e baseada em evidências da dívida técnica, sem
misturar avaliação com implementação.

## Aplicabilidade

- Execute somente quando solicitada explicitamente ou incluída em trabalho de
  manutenção aprovado.
- Este workflow é separado do ciclo de desenvolvimento padrão e não é artefato
  obrigatório do projeto nem gate de release.
- QA-Security conduz a auditoria; Tech Lead avalia e prioriza os achados.

## Entradas

- Solicitação explícita de auditoria ou escopo de manutenção aprovado.
- Repositório e commit ou revisão-base a inspecionar.
- PRD, arquitetura, sprint e artefatos de revisão disponíveis, quando
  relevantes.
- Restrições, trade-offs conhecidos e áreas excluídas da revisão.

## Etapas

1. Confirme objetivo, responsável, escopo, exclusões, baseline e limite de
   somente leitura. Peça esclarecimentos quando não for possível estabelecê-los.
2. Inspecione os artefatos e as evidências de origem relevantes dentro do escopo
   acordado. Registre ferramentas, comandos e limitações; preserve as mudanças
   existentes e não faça limpeza nem edições.
3. Avalie a dívida candidata em relação às evidências observadas e ao contexto
   do projeto. Idade, estilo desconhecido, documentação ausente ou uma busca
   limpa, por si só, não provam um defeito.
4. Registre cada achado acionável com classe de evidência, caminho e
   linha/intervalo exatos, impacto, severidade, confiança, esforço estimado,
   responsável, recomendação e critérios de aceite verificáveis.
5. Registre contraevidências e padrões que pareçam problemáticos, mas sejam
   intencionais ou aceitáveis. Declare quando nenhum achado acionável for
   identificado dentro do escopo inspecionado.
6. Produza `docs/TECH_DEBT_AUDIT.md` usando o schema e o template. Inclua as
   limitações de evidência e não altere o código durante a auditoria.
7. Encaminhe o relatório ao Tech Lead para priorização. Converta achados aceitos
   em trabalho do Sprint Planner somente após aprovação; a implementação segue
   seu próprio plano e workflow aprovados.

## Resultado esperado

- `docs/TECH_DEBT_AUDIT.md` opcional, com achados delimitados e evidências.
- Decisão do Tech Lead para aceitar, adiar, rejeitar ou solicitar mais evidência
  para cada achado acionável.
- Tarefas de sprint somente para achados explicitamente aprovados para correção.

## Salvaguardas

- Não execute este workflow por padrão nem crie um relatório vazio apenas para
  satisfazer um checklist.
- Não modifique arquivos-fonte, dependências, configurações ou dados do usuário
  durante a auditoria.
- Não prescreva reescritas amplas ou limpeza genérica sem impacto específico e
  baseado em evidências.
- Um achado não é automaticamente um defeito nem um compromisso de correção.
- Não generalize conclusões além do escopo e da baseline inspecionados.
