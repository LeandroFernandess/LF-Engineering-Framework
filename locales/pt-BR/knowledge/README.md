# Knowledge de engenharia LF

Versão: 0.1.0
Status: Rascunho
Responsável: Leandro Fernandes

---

# Objetivo

O LF Engineering Knowledge é a camada oficial de conhecimento orientada a IA
do LF Engineering System.

Seu objetivo é transformar os conceitos, princípios, padrões e processos
definidos no LF Engineering Framework em conhecimento estruturado, modular e
reutilizável, otimizado para agentes de IA.

O Framework permanece como fonte única da verdade.

O Knowledge nunca substitui o Framework.

Em vez disso, reorganiza e estrutura seu conteúdo para consumo eficiente por IA.

---

# Filosofia

O Framework ensina.

O Knowledge instrui.

Os Agents executam.

---

# Objetivos

O LF Engineering Knowledge tem cinco objetivos principais:

- Padronizar o conhecimento consumido pelos agentes de IA.
- Garantir consistência em todas as decisões de engenharia.
- Eliminar instruções duplicadas entre agentes.
- Simplificar a manutenção do conhecimento de IA.
- Manter cada agente alinhado ao LF Engineering Framework.

---

# Arquitetura

O LF Engineering Knowledge é organizado em módulos independentes.

Cada módulo representa um único domínio de engenharia.

Cada módulo tem uma responsabilidade e pode ser consumido por um ou mais
agentes de IA.

Nenhum módulo deve duplicar conhecimento de outro módulo.

O Framework é sempre a fonte autorizada.

---

# Fluxo do conhecimento

```text
LF Engineering Framework
            │
            ▼
LF Engineering Knowledge
            │
            ▼
Agentes de engenharia de IA
            │
            ▼
Entregáveis do projeto
```

---

# Princípios de design

Todo módulo de conhecimento deve seguir estes princípios:

## Responsabilidade única

Cada módulo deve tratar apenas um domínio de engenharia.

---

## Sem duplicação

O conhecimento deve existir em apenas um módulo.

Outros módulos devem referenciá-lo em vez de duplicá-lo.

---

## Informação estruturada

Os módulos priorizam informação estruturada em vez de explicações longas.

O conhecimento deve ser otimizado para recuperação.

---

## Consistência

Todo módulo deve seguir o mesmo template e estilo de escrita.

---

## Modularidade

Os módulos devem ser independentes sempre que possível.

Os agentes de IA devem consumir somente os módulos necessários para suas
responsabilidades.

---

# Ciclo de vida do módulo

Todo módulo segue o mesmo ciclo de vida:

1. Criado
2. Revisado
3. Aprovado
4. Publicado
5. Atualizado
6. Depreciado (quando aplicável)

---

# Fonte da verdade

O LF Engineering Framework é a única fonte oficial de conhecimento de
engenharia.

Os módulos de Knowledge derivam do Framework.

Nenhuma decisão de engenharia deve se originar exclusivamente dentro do
Knowledge.

---

# Consumo pelos agentes

Os agentes de IA devem consumir somente os módulos necessários para sua
especialização.

Isso minimiza sobrecarga de contexto e melhora a qualidade das respostas.

Os módulos necessários para cada agente estão documentados no diretório
`agents/`.

---

# Versionamento

Os módulos de Knowledge evoluem independentemente do Framework.

Toda atualização significativa deve incluir:

- Incremento de versão
- Changelog
- Data atualizada
- Referência à versão do Framework de origem

---

# Diretrizes de contribuição

Antes de modificar qualquer módulo:

- verifique a seção correspondente do Framework;
- confira os módulos relacionados;
- evite informação duplicada;
- preserve a consistência;
- atualize o Histórico de versões quando aplicável.

---

# Estrutura de diretórios

```text
knowledge/

├── INDEX.md
├── README.md
├── ENGINEERING_FOUNDATIONS.md
├── ENGINEERING_WORKFLOW.md
├── ENGINEERING_ARTIFACTS.md
├── ENGINEERING_DECISIONS.md
├── ENGINEERING_STANDARDS.md
├── ENGINEERING_QUALITY.md
├── ENGINEERING_MOTION_DESIGN.md
├── ENGINEERING_AI_COLLABORATION.md
├── ENGINEERING_AGENT_GUIDELINES.md
├── ENGINEERING_TEMPLATES.md
├── ENGINEERING_FIELD_GUIDE.md
├── ENGINEERING_CONTINUOUS_IMPROVEMENT.md
├── ENGINEERING_ELEPHANT_GOLDFISH.md (módulo suplementar opcional aprovado)
├── ENGINEERING_AGENT_GRAPH_FLOW.md (módulo suplementar opcional aprovado)
├── ENGINEERING_RTK.md (módulo suplementar opcional aprovado)
└── ENGINEERING_GRAPHIFY.md (módulo suplementar opcional aprovado)
```

---

## Módulos suplementares opcionais aprovados

`ENGINEERING_ELEPHANT_GOLDFISH.md` foi aprovado para uso opcional por tarefa.
Não faz parte do grafo obrigatório de dependências nem cria um gate universal de
design ou artefato exigido.

`ENGINEERING_AGENT_GRAPH_FLOW.md` foi aprovado como orientação opcional de
execução e evidências. Não faz parte do grafo obrigatório de dependências.
Instalar ou integrar `agf` exige aprovação específica e separada do proprietário.

`ENGINEERING_RTK.md` foi aprovado como orientação opcional de filtragem de saída
de comandos e otimização de contexto. Não faz parte do grafo obrigatório de
dependências. Instalar ou integrar RTK exige aprovação específica e separada do
proprietário.

`ENGINEERING_GRAPHIFY.md` foi aprovado como orientação opcional sobre grafo de
conhecimento de código local-first e contexto estrutural. Não faz parte do grafo
obrigatório de dependências. A lacuna documentada de proveniência permanece sem
solução; novas instalações ou integrações exigem aprovação específica e separada
do proprietário.

# Declaração final

O LF Engineering Knowledge não pretende substituir o julgamento de engenharia.

Seu objetivo é fornecer uma camada de conhecimento consistente, estruturada e
manutenível que permita aos agentes de IA operar sob a mesma filosofia de
engenharia definida pelo LF Engineering Framework.
