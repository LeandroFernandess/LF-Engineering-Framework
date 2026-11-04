# Workflow de correção de bugs

## Objetivo

Workflow para diagnosticar, corrigir e validar defeitos sem ampliar o escopo
desnecessariamente.

## Etapas

1. Reproduza ou descreva o defeito com evidências observáveis.
2. Identifique o comportamento esperado, o comportamento atual e os usuários
   afetados.
3. Localize a causa-raiz provável.
4. Defina a menor correção coerente.
5. Atualize os testes ou as etapas de validação.
6. Revise o impacto no código e o risco de regressão.
7. Registre a decisão e o resultado da validação em `.ai/`.

## Foco dos agentes

- Product Owner esclarece o impacto para o usuário quando o comportamento é
  ambíguo.
- Software Architect valida o impacto arquitetural em correções não triviais.
- Code Reviewer verifica correção, manutenibilidade e risco de regressão.
- QA Security valida reprodução, cobertura de testes e implicações de segurança.
- Tech Lead aprova a decisão de entrega quando a correção tiver risco relevante.
