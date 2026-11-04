# Guia de campo de engenharia

Versão: 0.2.0
Status: Rascunho
Categoria: Decisão

---

# Objetivo

Este módulo fornece orientação prática de engenharia para situações em que
existem várias abordagens válidas ou em que o Framework não define explicitamente
uma solução.

Seu objetivo é promover julgamento de engenharia consistente, preservando os
princípios do LF Engineering Framework.

---

# Escopo

Define:

- orientação prática de engenharia;
- heurísticas de decisão;
- cenários ambíguos;
- trade-offs de engenharia;
- tratamento de exceções.

---

# Consumidores

Principais:

- Software Architect Agent
- Code Reviewer Agent
- QA & Security Agent
- Tech Lead Agent

Secundários:

- Product Owner Agent
- Prompt Architect Agent

---

# Dependências

Obrigatórias:

- ENGINEERING_FOUNDATIONS
- ENGINEERING_DECISIONS
- ENGINEERING_STANDARDS

Relacionada:

- ENGINEERING_QUALITY

---

# Fonte

Derivado de:

LF Engineering Framework 1.3.0; manutenção pós-tag

Seções:

- Filosofia de engenharia
- Decisões de engenharia
- Boas práticas

---

# Responsabilidades

Este módulo fornece orientação de engenharia para situações em que as regras
explícitas são insuficientes.

---

# Heurísticas de engenharia

Quando existirem várias soluções válidas:

- prefira simplicidade;
- prefira manutenibilidade;
- prefira consistência;
- prefira explicitude;
- prefira evolução de longo prazo.

---

# Requisitos ambíguos

Se os requisitos estiverem incompletos:

- solicite esclarecimento sempre que possível;
- declare as premissas explicitamente;
- evite implementar regras de negócio ocultas.

---

# Dívida técnica

A dívida técnica só pode ser aceita quando for:

- explicitamente documentada;
- intencionalmente aprovada;
- claramente compreendida;
- planejada para resolução futura.

---

# Trade-offs

Todo trade-off deve avaliar:

- benefícios;
- riscos;
- complexidade;
- impacto de longo prazo;
- manutenibilidade.

---

# Integrações de API

Use este checklist somente quando uma solução incluir integração com API; isso
não significa que o projeto deva adicionar uma API ou provedor externo.

- Confirme a documentação oficial do provedor, a versão da API suportada, o
  estado do ciclo de vida/descontinuação e as premissas do contrato.
- Defina autenticação, armazenamento/rotação de segredos e escopos de menor
  privilégio; aplique autorização para cada recurso e tenant quando aplicável.
- Defina timeouts explícitos e comportamento limitado de novas tentativas/backoff.
  Use idempotência para escritas repetíveis e considere limites de taxa,
  paginação e falhas parciais.
- Valide e minimize os dados trocados. Para webhooks, verifique autenticidade e
  previna replay quando houver suporte.
- Defina o comportamento diante de erros e indisponibilidade do provedor,
  mudanças de versão e recuperação; não exponha credenciais ou payloads sensíveis
  em logs.
- Escolha testes proporcionais de contrato, sandbox ou casos representativos e
  preserve evidências de ações externas relevantes e suas aprovações.

Para integrações somente de leitura, não exija confirmação para cada solicitação.
Para escritas relevantes ou outros efeitos colaterais externos, siga os
controles de autorização e aprovação de `ENGINEERING_QUALITY`.

---

# Escalonamento

Escale quando:

- a arquitetura mudar significativamente;
- a segurança for incerta;
- as metas de negócio entrarem em conflito;
- existirem várias direções estratégicas.

---

# Boas práticas

- Prefira clareza.
- Pense no longo prazo.
- Documente as premissas.
- Evite complexidade desnecessária.
- Respeite a arquitetura existente.

---

# Antipadrões

Evite:

- premissas ocultas;
- otimização prematura;
- violações do Framework;
- reescritas desnecessárias;
- mudanças grandes sem justificativa.

---

# Matriz de decisão

| Situação | Ação recomendada |
| --- | --- |
| Informação ausente | Solicitar esclarecimento |
| Várias soluções boas | Apresentar os trade-offs |
| Conflito arquitetural | Escalonar |
| Dívida técnica | Documentar |
| Conflito com o Framework | Seguir o Framework |

---

# Módulos relacionados

ENGINEERING_DECISIONS

ENGINEERING_STANDARDS

ENGINEERING_QUALITY

---

# Versionamento

Versão: 0.2.0

Status: Rascunho

Derivado de:

LF Engineering Framework 1.3.0; manutenção pós-tag

---

## Histórico de versões

- `0.2.0` — 2026-11-01: Adicionado checklist condicional de integração de APIs,
  ligado a autorização, falhas de provedores e efeitos externos.
