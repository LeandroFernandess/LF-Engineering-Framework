# Agentes de engenharia LF

Versão: 1.0.0

Status: Estável

---

# Objetivo

O diretório `agents/` contém a documentação oficial de todos os agentes de IA
que fazem parte do LF Engineering System.

Esses documentos são independentes de qualquer plataforma de IA específica e
servem como referência autorizada para configurar, manter e evoluir agentes de
engenharia especializados.

As implementações criadas em interfaces de IA são aplicações desta
documentação. A documentação permanece independente de plataforma.

---

# Arquitetura

O LF Engineering System é organizado em três camadas complementares:

```text
LF Engineering Framework
            │
            ▼
LF Engineering Knowledge
            │
            ▼
LF Engineering Agents
```

Cada camada tem uma responsabilidade distinta.

O Framework define a filosofia de engenharia.

O Knowledge estrutura o conhecimento de engenharia.

Os Agents aplicam esse conhecimento por meio de responsabilidades
especializadas.

---

# Estrutura de diretórios

Cada agente segue exatamente a mesma estrutura.

```text
Agent/

├── SPECS.md
├── README.md
├── CONTEXT.md
├── KNOWLEDGE.md
├── CONFIGURATION.md
└── CHANGELOG.md
```

Essa estrutura deve permanecer consistente entre todos os agentes.

---

# Responsabilidades dos arquivos

## SPECS.md

Especificação de comportamento do agente, independente de harness ou plataforma.

Define o comportamento canônico do agente sem prescrever harness ou runtime.

Atualize este documento quando o comportamento canônico mudar e registre a alteração no
changelog do agente.

---

## README.md

Define a identidade do agente.

Responde:

* Quem é este agente?
* Qual é sua missão?
* Quais são suas responsabilidades?

---

## CONTEXT.md

Define como o agente opera dentro do LF Engineering System.

Responde:

* Quando este agente deve ser usado?
* Quais entradas são necessárias?
* Quais saídas são esperadas?
* Quais decisões ele pode tomar?

---

## KNOWLEDGE.md

Define quais módulos de Knowledge são consumidos pelo agente.

O agente nunca é proprietário do conhecimento de engenharia.

Ele consome o Knowledge oficial publicado pelo LF Engineering System.

---

## CONFIGURATION.md

Documenta a configuração do agente.

Explica:

* capacidades e ferramentas necessárias;
* capacidades opcionais independentes de harness;
* racional da configuração;
* expectativas de saída.

Este documento orienta implementações em harnesses e CLIs compatíveis.

---

## CHANGELOG.md

Registra a evolução do agente.

Documenta:

* melhorias;
* mudanças de configuração;
* atualizações de Knowledge;
* histórico de versões.

---

# Princípios de engenharia

Todo agente deve:

* respeitar o LF Engineering Framework;
* consumir os módulos oficiais de Knowledge;
* operar somente dentro de sua especialização;
* produzir saídas determinísticas e estruturadas;
* preservar a consistência de engenharia.

---

# Ciclo de vida do agente

Todo agente segue o mesmo ciclo de vida.

```text
Design

↓

Configuração

↓

Documentação

↓

Integração de Knowledge

↓

Validação

↓

Release

↓

Melhoria contínua
```

---

# Adição de um novo agente

Todo agente novo deve seguir estas etapas:

1. Definir sua especialização.
2. Configurar o agente.
3. Exportar a especificação-base.
4. Criar os arquivos de documentação.
5. Mapear os módulos de Knowledge necessários.
6. Validar a consistência com o Framework.
7. Publicar a primeira versão estável.

---

# Relação com o Knowledge

Os agentes nunca duplicam conhecimento de engenharia.

O Knowledge permanece centralizado no diretório `knowledge/`.

Cada agente apenas declara quais módulos consome.

Essa arquitetura minimiza duplicação e simplifica a manutenção futura.

---

# Versionamento

Os agentes evoluem de forma independente.

Toda mudança significativa deve ser documentada no `CHANGELOG.md` do agente
correspondente.

A documentação deve permanecer sempre sincronizada com a configuração ativa do
agente.

---

# Declaração final

O diretório `agents/` é a camada operacional do LF Engineering System.

Ele transforma conhecimento de engenharia em comportamento especializado de IA,
preservando consistência, manutenibilidade e evolução de longo prazo em todo o
ecossistema.
