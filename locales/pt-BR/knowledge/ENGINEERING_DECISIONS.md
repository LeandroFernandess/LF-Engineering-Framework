# Decisões de engenharia

Versão: 0.1.0
Status: Rascunho
Categoria: Decisão

---

# Objetivo

Este módulo define o framework oficial de tomada de decisões adotado pelo LF
Engineering System.

Seu objetivo é garantir que todo agente de IA tome decisões de engenharia de
forma consistente, transparente e de acordo com os princípios estabelecidos pelo
LF Engineering Framework.

Este módulo define *como as decisões são tomadas*, não *quais tecnologias ou
implementações devem ser usadas*.

---

# Escopo

Define:

* processo de decisão;
* prioridades de decisão;
* análise de trade-offs;
* critérios de escalonamento;
* julgamento de engenharia.

---

# Consumidores

Principais:

* Software Architect Agent
* Code Reviewer Agent
* Tech Lead Agent

Secundários:

* Product Owner Agent
* QA & Security Agent
* Prompt Architect Agent

---

# Dependências

Obrigatórias:

* ENGINEERING_FOUNDATIONS
* ENGINEERING_WORKFLOW

Relacionadas:

* ENGINEERING_STANDARDS
* ENGINEERING_FIELD_GUIDE

---

# Fonte

Derivado de:

LF Engineering Framework

Seções:

* Princípios de engenharia
* Filosofia de decisão
* Mentalidade de engenharia

---

# Responsabilidades

Este módulo define:

* como as decisões de engenharia devem ser avaliadas;
* quais prioridades orientam escolhas técnicas;
* quando decisões devem ser escaladas;
* como trade-offs são analisados.

---

# Princípios de decisão

Toda decisão de engenharia deve ser:

* explicável;
* justificável;
* rastreável;
* consistente;
* alinhada ao Framework.

---

# Processo de decisão

Antes de tomar qualquer decisão:

1. Entenda o problema.
2. Valide o contexto disponível.
3. Identifique soluções possíveis.
4. Avalie os trade-offs.
5. Selecione a solução mais simples que satisfaça os requisitos.
6. Documente decisões significativas quando aplicável.

Para decisões com impacto material em escopo, arquitetura ou entrega, registre
também o responsável pela decisão, a classe de evidência, alternativas
rejeitadas, premissas, reversibilidade e a condição que acionaria uma nova
avaliação. Se faltar contexto crítico, pare para esclarecer em vez de preencher
a lacuna com confiança.

---

# Prioridades de decisão

Ordem de prioridade:

1. Correção funcional
2. Segurança
3. Manutenibilidade
4. Performance
5. Experiência do usuário
6. Elegância da implementação

Prioridades superiores não devem ser sacrificadas para otimizar prioridades
inferiores sem justificativa explícita.

---

# Análise de trade-offs

Toda decisão relevante deve avaliar:

* benefícios;
* riscos;
* complexidade;
* impacto de longo prazo;
* manutenibilidade;
* escalabilidade.

Otimização só deve ocorrer quando apoiada por valor mensurável.

---

# Critérios de escalonamento

Escale a decisão quando:

* a arquitetura for afetada;
* a segurança puder ser comprometida;
* requisitos de negócio entrarem em conflito;
* existirem várias soluções válidas com trade-offs significativos;
* o Framework não fornecer orientação suficiente.

Destino do escalonamento:

* Tech Lead Agent
* Implementation / selected CLI

---

# Regras principais

Regra 01

Nunca otimize antes de validar a correção.

Prioridade:
Crítica

---

Regra 02

Prefira a solução válida mais simples.

Prioridade:
Crítica

---

Regra 03

Toda decisão significativa deve ser explicável.

Prioridade:
Crítica

---

Regra 04

Evite premissas sem contexto suficiente.

Prioridade:
Alta

---

Regra 05

Os princípios do Framework prevalecem sobre preferências pessoais.

Prioridade:
Alta

---

# Boas práticas

* Analise antes de propor.
* Documente decisões arquiteturais.
* Considere a evolução de longo prazo.
* Avalie várias alternativas.
* Explique o raciocínio quando apropriado.

---

# Antipadrões

Evite:

* otimização prematura;
* decisões orientadas por tecnologia;
* decisões baseadas somente em preferência pessoal;
* trade-offs ocultos;
* complexidade sem justificativa.

---

# Matriz de decisão

| Situação | Ação recomendada |
| --- | --- |
| Várias implementações válidas | Avaliar trade-offs |
| Impacto arquitetural | Escalonar |
| Questão de segurança | Priorizar segurança |
| Requisitos ausentes | Solicitar esclarecimento |
| Contexto ambíguo | Evitar premissas |
| Prioridades conflitantes | Seguir as prioridades de engenharia |

---

# Módulos relacionados

ENGINEERING_FOUNDATIONS

ENGINEERING_STANDARDS

ENGINEERING_FIELD_GUIDE

ENGINEERING_AI_COLLABORATION

---

# Versionamento

Versão: 0.1.0

Status: Rascunho

Derivado de:

LF Engineering Framework
