# Padrões de engenharia

Versão: 0.1.0
Status: Rascunho
Categoria: Operacional

---

# Objetivo

Este módulo define os padrões de engenharia adotados pelo LF Engineering
System.

Seu objetivo é garantir consistência, legibilidade, manutenibilidade e evolução
de longo prazo em todos os projetos.

Os padrões se aplicam à arquitetura, implementação, documentação e aos artefatos
de engenharia.

---

# Escopo

Define:

* convenções de engenharia;
* padrões de organização;
* padrões de documentação;
* princípios de nomenclatura;
* modularização;
* regras de consistência.

---

# Consumidores

Principais:

* Software Architect Agent
* Code Reviewer Agent
* QA & Security Agent
* Documentation Agent
* Tech Lead Agent

Secundários:

* Prompt Architect Agent
* Product Owner Agent

---

# Dependências

Obrigatórias:

* ENGINEERING_FOUNDATIONS
* ENGINEERING_DECISIONS

Relacionadas:

* ENGINEERING_QUALITY
* ENGINEERING_TEMPLATES

---

# Fonte

Derivado de:

LF Engineering Framework

Seções:

* Princípios de engenharia
* Filosofia de código
* Padrões de documentação

---

# Responsabilidades

Este módulo estabelece os padrões mínimos de engenharia esperados para todo
projeto desenvolvido sob o LF Engineering System.

---

# Padrões centrais

## Organização

Os projetos devem ter uma estrutura clara e previsível.

Cada diretório deve ter uma única responsabilidade.

Os arquivos devem permanecer coesos e focados.

---

## Separação de responsabilidades

Funções, classes, módulos e diretórios devem ter finalidades claramente
definidas.

Evite combinar responsabilidades não relacionadas.

---

## Nomenclatura

Os nomes devem ser:

* claros;
* explícitos;
* consistentes.

Prefira legibilidade a brevidade.

Evite abreviações, salvo quando forem universalmente reconhecidas.

---

## Documentação

A documentação é obrigatória.

Toda decisão importante de engenharia deve ser explicável.

Os projetos devem incluir documentação atualizada que reflita a implementação
atual.

---

## Modularidade

O código deve ser organizado em módulos independentes sempre que houver
justificativa.

Os módulos devem expor responsabilidades claras.

---

## Legibilidade

Código legível é preferível a código engenhoso.

Otimize para entendimento.

---

## Consistência

Siga os padrões existentes do projeto sempre que possível.

Evite introduzir vários estilos dentro do mesmo projeto.

---

# Regras principais

Regra 01

A organização é obrigatória.

Prioridade:
Crítica

---

Regra 02

A documentação evolui junto com a implementação.

Prioridade:
Crítica

---

Regra 03

A nomenclatura deve priorizar clareza.

Prioridade:
Alta

---

Regra 04

Todo módulo deve ter uma única responsabilidade.

Prioridade:
Alta

---

Regra 05

Consistência é preferível ao estilo individual.

Prioridade:
Alta

---

# Boas práticas

* Mantenha os módulos coesos.
* Escreva código autoexplicativo.
* Use documentação para explicar intenção, não sintaxe óbvia.
* Prefira explicitude.
* Mantenha os artefatos de engenharia sincronizados.

---

# Antipadrões

Evite:

* código morto;
* soluções temporárias que se tornam permanentes;
* responsabilidades misturadas;
* dependências ocultas;
* nomenclatura inconsistente;
* documentação desatualizada;
* engenharia excessiva.

---

# Matriz de decisão

| Situação | Ação recomendada |
| --- | --- |
| Novo módulo | Definir uma única responsabilidade |
| Novo arquivo | Usar nomenclatura explícita |
| Mudança arquitetural | Atualizar a documentação |
| Lógica repetida | Avaliar a modularização |
| Projeto existente | Preservar a consistência |

---

# Módulos relacionados

ENGINEERING_FOUNDATIONS

ENGINEERING_DECISIONS

ENGINEERING_QUALITY

ENGINEERING_TEMPLATES

---

# Versionamento

Versão: 0.1.0

Status: Rascunho

Derivado de:

LF Engineering Framework
