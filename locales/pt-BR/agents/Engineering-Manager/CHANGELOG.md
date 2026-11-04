# Changelog do agente Engineering Manager

Todas as mudanças relevantes do agente Engineering Manager serão documentadas
neste arquivo.

O formato segue a estratégia de versionamento do LF Engineering System.

---

# Não lançado

## Alterado

- Especificação e perfil de execução do agente tornados independentes de fornecedor e
  harness; a seleção de modelo fica a cargo do ambiente consumidor.

---

# Versão 1.0.0

Data de release

Não registrada no histórico de origem

Status

Estável

---

## Adicionado

* Documentação inicial do agente Engineering Manager.
* Responsabilidade de intake operacional.
* Modelo de classificação do tipo de trabalho.
* Detecção de escopo, risco, ambiguidade e restrições.
* Modelo de decisão de prosseguir ou pedir esclarecimento.
* Estrutura de saída do `MANAGER_BRIEF`.
* Regras de fronteira para não execução e proteção do Framework.

---

## Alterado

* Baseline inicial estabelecido como nova camada antes do Orchestrator.

---

## Melhorado

* Separação explícita entre intake de demanda e orquestração técnica.
* Segurança do workflow antes da execução por agentes especializados.
* Padronização do briefing operacional esperado pelo Orchestrator.

---

## Removido

Nenhum.

---

## Notas

Esta versão introduz o Engineering Manager somente como camada de classificação
operacional.

Ele não substitui o Orchestrator nem qualquer agente de engenharia especializado.

---

# Versões futuras

## Versão 2.x

Melhorias esperadas:

* heurísticas de classificação aprimoradas;
* taxonomia ampliada de ambiguidades e riscos;
* integração mais forte com arquivos de estado do projeto;
* exemplos adicionais de intake.
