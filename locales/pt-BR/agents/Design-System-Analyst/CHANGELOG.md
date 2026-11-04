# Changelog do agente Design System Analyst

Todas as mudanças relevantes do agente Design System Analyst serão documentadas
neste arquivo.

O formato segue a estratégia de versionamento do LF Engineering System.

---

# Não lançado

## Alterado

- Especificação e perfil de execução do agente tornados independentes de fornecedor e
  harness; a seleção de modelo fica a cargo do ambiente consumidor.

## Adicionado

- Adicionado roteamento condicional do conhecimento de motion design para o
  contrato de design, alternativas de movimento reduzido e evidências de revisão
  visual.

---

# Versão 1.2.0

Data de release
2026-10-31

Status
Estável

## Adicionado

* Propostas opcionais de direção visual inicial, quando solicitadas
  explicitamente para um produto visual sem referências.
* Classificação de evidências e salvaguardas de aprovação para separar propostas
  de observações baseadas em referências.
* Orientação para preservar tokens existentes como fonte da verdade e limitar
  overrides ao escopo das páginas necessárias.

## Alterado

* Workflow condicional atualizado para permitir uma solicitação explícita de
  proposta sem referências, sem tornar propostas de design automáticas.

---

# Versão 1.1.0

Data de release

2026-10-18

Status

Estável

## Adicionado

* Handoff condicional de design e performance para projetos web e visuais.
* Orientação de composição mobile/desktop, estados de carregamento, LCP
  candidato, assets/fontes e acessibilidade na análise de design.
* Integração com `ENGINEERING_DESIGN_PERFORMANCE` e o protocolo de validação de
  performance.

---

# Versão 1.0.0

Data de release

2026-07-04

Status

Estável

---

## Adicionado

* Especificação inicial de comportamento do agente criada.
* Metodologia de análise de referências visuais.
* Workflow de identificação de padrões de design.
* Processo de geração do DESIGN.md.
* Metodologia de extração da paleta de cores.
* Workflow de análise de tipografia.
* Processo de catalogação de componentes.
* Documentação de padrões de interação.
* Especificação de tokens de design.
* Análise de acessibilidade.
* Saída estruturada em Markdown.
* Integração de execução condicional com o workflow de engenharia.

---

## Alterado

* Baseline inicial estabelecido a partir do LF Engineering Framework v1.1.
* Agente documentado oficialmente dentro do LF Engineering System.

---

## Melhorado

* Documentação de engenharia padronizada.
* Contexto operacional definido.
* Integração com a arquitetura do LF Engineering Knowledge.
* Responsabilidades formais estabelecidas.
* Documentação de configuração padronizada.
* Integração entre design visual e engenharia de software.

---

## Removido

Nenhum.

---

## Notas

Esta versão estabelece o agente Design System Analyst como parte do LF
Engineering System v1.1.

O agente opera como etapa condicional entre Product Owner e Software Architect,
acionada somente quando existem referências visuais.

O agente documenta características de engenharia de interfaces visuais. Ele não
redesenha nem gera código.

---

# Versões futuras

## Versão 2.x

Melhorias esperadas:

* integração completa com Knowledge;
* reconhecimento ampliado de padrões de design;
* metodologia aprimorada de especificação de componentes;
* colaboração ampliada com os agentes Software Architect e Sprint Planner;
* workflow refinado de extração de tokens de design.

---

## Versão 3.x

Reservada para futuras melhorias arquiteturais maiores.
