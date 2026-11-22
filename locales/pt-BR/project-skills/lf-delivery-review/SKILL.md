---
name: lf-delivery-review
description: Use após a implementação para revisar alinhamento ao plano, evidências de qualidade, documentação e prontidão da entrega.
---

# Revisão de entrega LF

1. Compare a implementação e o diff com o plano aprovado, os critérios de
   aceite, os contratos do projeto e o estado atual em `.ai/state/`.
2. Use a fonte oficial do Framework identificada em `LF_ENGINEERING.md`.
   Quando o repositório canônico estiver disponível, consulte
   `knowledge/INDEX.md`, `knowledge/REGISTRY.md`, o workflow aplicável e as
   definições canônicas de Code Reviewer, QA-Security, Documentation e Tech Lead.
3. Confira correção, regressões, limites de confiança, comportamento visível,
   artefatos exigidos e evidências de verificação. Aplique revisões condicionais
   apenas quando as condições correspondentes forem atendidas.
4. Registre achados, evidências, riscos não resolvidos e prontidão da entrega
   nos artefatos definidos pelo projeto. Mantenha o Framework externo somente para leitura.

Não declare um gate aprovado sem evidências nem substitua a validação manual do
usuário quando o workflow a exigir.
