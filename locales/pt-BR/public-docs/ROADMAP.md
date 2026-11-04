# Roadmap do LF Engineering Framework

Idiomas: [EN-US](../../../ROADMAP.md) | [PT-BR](ROADMAP.md)

Versão de referência: 1.5.0<br>
Status: primeira release pública estável `v1.5.0` publicada em 2026-11-03<br>
Baseline desta tradução: conteúdo publicado em `v1.5.0`; releases anteriores são históricas no repositório predecessor privado<br>
Fonte: `ROADMAP.md`

---

# Objetivo

Este roadmap define a visão de longo prazo do LF Engineering Framework.

Ele não representa prazos fixos nem releases obrigatórias.

Em vez disso, documenta a direção pretendida para a evolução do framework.

O próprio roadmap deve evoluir ao longo do tempo.

---

# Princípio orientador

O LF Engineering Framework evolui somente quando a melhoria aumenta a qualidade, a consistência ou a capacidade de manutenção da engenharia.

Novos recursos são adicionados somente quando resolvem problemas reais de engenharia.

A simplicidade é preferida à complexidade desnecessária.

---

# Baseline atual

## Versão 1.2.0

Status

Baseline histórica; substituída por `v1.3.0`.

Principais entregas

* LF Engineering Knowledge.
* Agentes de IA especializados.
* Workflow de engenharia.
* Mapa de interação entre agentes.
* Modelo de governança.
* Padrões de documentação.
* Documentação do Engineering Framework.
* Agente Design System Analyst.
* Agente Engineering Knowledge Extractor.
* Artefato e schema `DESIGN.md`.
* Artefato e schema `PROJECT_KNOWLEDGE.md`.
* Módulo de conhecimento de design e performance e protocolo de validação mobile/desktop.
* Artefato condicional `PERFORMANCE_VALIDATION_REPORT.md` e seu schema.

---

# Tranche de distribuição

## Versão 1.3.0

Status

Release estável publicada.

Objetivo principal

Entregar uma distribuição neutra em relação a fornecedores, multilíngue e compatível com CLIs, refinando o ecossistema de engenharia com feedback de projetos reais.

Incluído na release publicada

* `generic` neutro em relação a fornecedores como padrão do bootstrap.
* Bootstraps nativos em shell para macOS/Linux e Windows PowerShell.
* Seleção explícita do template de projeto `en-US`/`pt-BR`.
* Adapters opcionais Codex, Claude, Gemini e OpenCode; `generic` permanece como padrão.
* Adoção que copia somente arquivos ausentes, com proteção de fronteira do Framework.
* Validadores nativos, testes de bootstrap e workflow GitHub Actions em três sistemas operacionais.
* Verificações estruturais de paridade PT-BR do template de projeto.
* Traduções PT-BR dos agentes canônicos e do Knowledge estável com verificações de paridade estrutural.

Gates de release concluídos antes da publicação

* Execução nativa em Windows e validação bem-sucedida de GitHub Actions em Ubuntu/macOS/Windows.
* Release autenticada do repositório GitHub para `v1.3.0`, com arquivos e checksums, publicada e verificada.

## Versão 1.4.0 — repositório privado predecessor

A release estável `v1.4.0` foi publicada no repositório privado predecessor depois que o commit exato da tag passou pela validação Ubuntu/macOS/Windows e pelo empacotamento. O job automático de publicação falhou por falta de checkout Git; o artefato validado do Actions foi publicado manualmente com autorização do responsável. Essa release incluiu a auditoria opcional de dívida técnica, orientações opcionais de direção visual, verificações condicionais de qualidade para IA/APIs, especificações de agentes neutras em relação a harnesses e modelos, configuração GitHub MCP desativada por padrão, orientações condicionais de motion design, atualizações de tradução, evidências de identidade/proveniência do Graphify e quatro módulos suplementares opcionais. Esses módulos não alteram o grafo obrigatório de dependências nem autorizam instalação de ferramentas externas. A tag e os artefatos de `v1.4.0` não foram migrados para este repositório público.

## Versão 1.5.0 — primeira release pública

A primeira release pública é um snapshot limpo na branch `main`. Inclui as quatro
mudanças de manutenção posteriores à `v1.4.0` do repositório predecessor, a regra
Git padrão para ignorar `.ai/state/` de projetos clientes, a nova nomenclatura dos
archives e os canais públicos de comunicação de segurança. O histórico, branches,
tags e artefatos do repositório predecessor não foram importados.

Melhorias futuras

* Refinar módulos de Knowledge.
* Melhorar a colaboração entre agentes.
* Aprimorar a documentação de engenharia.
* Expandir a governança de engenharia.
* Melhorar a metodologia de prompt engineering.
* Fortalecer as diretrizes de qualidade.
* Ampliar orçamentos de performance e validação em campo a partir de evidências de projetos.
* Aplicar conhecimento extraído de projetos concluídos.

---

# Evolução futura

## Versão 2.x

Iniciativas possíveis

* Templates de engenharia.
* Checklists reutilizáveis de engenharia.
* Workflows de bootstrap de projetos.
* Relatórios padronizados de engenharia.
* Melhor onboarding de projetos.

Somente iniciativas que ofereçam valor mensurável de engenharia devem ser incorporadas.

---

# Visão de longo prazo

Possibilidades futuras incluem:

* Workflows de execução local.
* Orquestração de IA.
* Dashboard de engenharia.
* Automação do Framework.
* Site público de documentação.
* Contribuições mais amplas da comunidade.

Essas ideias são exploratórias e só devem ser perseguidas se estiverem alinhadas à filosofia do framework.

---

# O que não será adicionado

O LF Engineering Framework evita intencionalmente complexidade desnecessária.

Exemplos:

* Recursos sem valor prático.
* Documentação duplicada.
* Agentes com responsabilidades sobrepostas.
* Abstrações desnecessárias.
* Dependências específicas de ferramentas.

O framework deve permanecer modular, compreensível e sustentável.

---

# Princípios de evolução

Toda melhoria futura deve atender a pelo menos um dos seguintes objetivos:

* Melhorar a qualidade do software.
* Melhorar a consistência da engenharia.
* Melhorar a capacidade de manutenção.
* Melhorar a documentação.
* Melhorar a experiência de desenvolvimento.
* Melhorar a colaboração com IA.

## Aceite da distribuição

A distribuição `v1.3.0` foi aceita após a confirmação da execução nativa em Windows, paridade de tradução da biblioteca canônica, evidências de bootstrap limpo, acesso autenticado ao repositório/Actions e arquivos/checksums da release.

Se uma melhoria não atender a nenhum desses objetivos, ela não deve se tornar parte do framework.

---

# Declaração final

O LF Engineering Framework deve evoluir gradualmente por meio de experiência prática.

Seu sucesso é medido pela qualidade do processo de engenharia que viabiliza, não pela quantidade de recursos que contém.
