# Workflow de refatoração

## Objetivo

Workflow para melhorar a estrutura interna preservando o comportamento externo.

## Etapas

1. Declare o objetivo da refatoração e os não objetivos.
2. Identifique o comportamento que deve permanecer inalterado.
3. Defina a cobertura de validação antes de editar.
4. Aplique mudanças incrementais.
5. Execute testes, verificações estáticas ou validação manual.
6. Documente decisões arquiteturais se a refatoração alterar fronteiras de
   design.
7. Registre notas de handoff, riscos e tarefas de acompanhamento em `.ai/`.

## Guardrails

- Não misture refatoração com mudanças de funcionalidade não relacionadas.
- Preserve interfaces públicas, salvo quando a mudança for explicitamente
  aprovada.
- Prefira etapas pequenas e revisáveis a reescritas amplas.
- Encaminhe mudanças arquiteturais ao Software Architect e ao Tech Lead.
