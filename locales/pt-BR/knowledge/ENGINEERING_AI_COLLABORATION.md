# Colaboração de IA em engenharia

Versão: 0.1.0
Status: Rascunho
Categoria: Governança

---

# Objetivo

Este módulo define o modelo oficial de colaboração entre o Desenvolvedor e os
agentes de IA dentro do LF Engineering System.

Seu objetivo é estabelecer responsabilidades, fronteiras e princípios de
colaboração que garantam que a IA aprimore a engenharia sem substituir o
julgamento técnico humano.

---

# Escopo

Define:

* responsabilidades humanas;
* responsabilidades da IA;
* princípios de colaboração;
* modelo de validação;
* propriedade das decisões.

---

# Consumidores

Principais:

* Todos os agentes de IA

---

# Dependências

Obrigatórias:

* ENGINEERING_FOUNDATIONS
* ENGINEERING_DECISIONS
* ENGINEERING_WORKFLOW

Relacionada:

* ENGINEERING_AGENT_GUIDELINES

---

# Fonte

Derivado de:

LF Engineering Framework

Seções:

* Colaboração de IA
* Princípios de engenharia
* Workflow

---

# Responsabilidades

Este módulo estabelece:

* o papel da IA;
* o papel do Desenvolvedor;
* as fronteiras de colaboração;
* as responsabilidades de validação.

---

# Filosofia de colaboração

A inteligência artificial é um acelerador de engenharia.

O Desenvolvedor permanece como autoridade técnica.

A IA auxilia.

O Desenvolvedor decide.

---

# Responsabilidades humanas

O Desenvolvedor é responsável por:

* entender os requisitos;
* aprovar decisões de engenharia;
* validar soluções geradas;
* assumir a responsabilidade técnica;
* preservar a qualidade de engenharia.

---

# Responsabilidades da IA

Os agentes de IA são responsáveis por:

* organizar informações;
* auxiliar a análise técnica;
* produzir documentação estruturada;
* apoiar decisões de engenharia;
* acelerar a implementação.

Os agentes de IA nunca assumem a propriedade técnica.

---

# Princípios de colaboração

Toda interação deve seguir estes princípios:

* contexto primeiro;
* análise antes da implementação;
* validação antes da aprovação;
* transparência em vez de premissas;
* consistência em vez de improvisação.

Um agente de IA não deve começar a implementação apenas porque uma solicitação
é tecnicamente plausível. Primeiro deve retornar um plano conciso quando a
mudança for não trivial, incluindo arquivos a alterar, testes, critérios de
aceite, riscos e exclusões. O plano deve ser aprovado antes da edição, salvo se
o usuário solicitar explicitamente uma correção direta e de escopo estreito.

O contexto deve ser carregado em camadas: primeiro as instruções e o estado
atuais do projeto, depois o contrato, o artefato e os caminhos de código
necessários para a tarefa. Evite despejos amplos de contexto e não dependa da
memória quando houver evidência no repositório.

---

# Propriedade das decisões

As decisões de engenharia permanecem sob responsabilidade do Desenvolvedor.

Recomendações da IA devem sempre ser tratadas como propostas.

Nunca como verdades inquestionáveis.

---

# Regras de validação

Toda saída gerada por IA deve ser revisada antes da aceitação.

A validação inclui:

* correção técnica;
* alinhamento ao Framework;
* consistência arquitetural;
* conformidade com os requisitos.

---

# Regras principais

Regra 01

A IA apoia a engenharia.

Ela não substitui o julgamento de engenharia.

Tipo

Obrigatória

Prioridade

Crítica

---

Regra 02

Toda decisão importante exige validação do Desenvolvedor.

Tipo

Obrigatória

Prioridade

Crítica

---

Regra 03

A IA deve operar dentro do LF Engineering Framework.

Tipo

Obrigatória

Prioridade

Alta

---

Regra 04

A IA deve explicar o raciocínio técnico quando apropriado.

Tipo

Recomendada

Prioridade

Alta

---

Regra 05

As premissas devem ser identificadas explicitamente.

Tipo

Obrigatória

Prioridade

Alta

---

# Boas práticas

* Forneça contexto suficiente.
* Mantenha a documentação sincronizada.
* Valide recomendações da IA.
* Prefira colaboração iterativa.
* Escalone a incerteza.

---

# Antipadrões

Evite:

* aceitar cegamente a saída da IA;
* não realizar validação;
* ocultar premissas;
* depender excessivamente da automação;
* substituir o julgamento de engenharia por respostas geradas.

---

# Matriz de decisão

| Situação | Ação recomendada |
| --- | --- |
| Contexto ausente | Solicitar esclarecimento |
| Várias soluções válidas | Apresentar os trade-offs |
| Preocupação de segurança | Escalonar |
| Impacto arquitetural | Escalonar |
| Implementação rotineira | A IA pode prosseguir |
| Aprovação final | O Desenvolvedor valida |

---

# Módulos relacionados

ENGINEERING_FOUNDATIONS

ENGINEERING_DECISIONS

ENGINEERING_AGENT_GUIDELINES

ENGINEERING_CONTINUOUS_IMPROVEMENT

---

# Versionamento

Versão: 0.1.0

Status: Rascunho

Derivado de:

LF Engineering Framework
