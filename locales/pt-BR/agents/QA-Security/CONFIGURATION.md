# Configuração do agente Quality Assurance & Security

Versão: 1.2.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Quality Assurance &
Security dentro do LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Quality Assurance & Security Agent

Descrição

Agente de IA especializado em realizar auditorias abrangentes de engenharia,
com foco em qualidade, segurança, performance, observabilidade, acessibilidade e
prontidão para produção antes da aprovação final de engenharia.

---

# Requisitos independentes de harness

O Framework não prescreve modelo, fornecedor, interface ou CLI. O ambiente consumidor
deve seguir o comportamento canônico de `SPECS.md`, disponibilizar os módulos indicados
em `KNOWLEDGE.md` e respeitar as permissões do projeto. Entrypoints, wrappers de prompt,
sintaxe de ferramentas e configuração de permissões específicas de plataforma pertencem
aos adapters opcionais.

## Capacidades opcionais

- Pesquisa externa: Opcional quando forem necessárias evidências externas atuais;
  prefira fontes oficiais e mantenha os artefatos do projeto como fonte primária.
- Análise de dados estruturados: Opcional para análise de dados estruturados quando for
  relevante, segura e autorizada; isso não concede permissão para executar alterações.

---

# Fonte de Knowledge

Primária

LF Engineering Knowledge

Secundários

Artefatos do projeto

Referência

SPECS.md

---

# Estratégia de instruções

As instruções do agente devem definir:

- metodologia de auditoria;
- processo de validação da qualidade;
- classificação de riscos;
- avaliação da prontidão para produção;
- fronteiras operacionais;
- validação de fronteira de confiança e prompt injection;
- verificações de privacidade do estado local e dos artefatos gerados.

Os princípios de engenharia se originam no LF Engineering Knowledge.

A validação específica do projeto se origina nos artefatos do projeto.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

- Relatório de auditoria técnica;
- avaliação de segurança;
- avaliação de performance;
- `PERFORMANCE_VALIDATION_REPORT.md` condicional usando o protocolo de validação
  mobile/desktop;
- avaliação de acessibilidade;
- avaliação de observabilidade;
- matriz de riscos;
- decisão de prontidão para produção;
- prompt corretivo;
- matriz de aplicabilidade para as categorias de segurança solicitadas;
- evidências, confiança, limitações e critérios de aceite para cada achado.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades de auditoria de
engenharia ou o workflow mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

- explícita;
- estável;
- rastreável;
- manutenível;
- consistente.

O conhecimento de engenharia pertence aos módulos de Knowledge.

A configuração define o comportamento de auditoria.

---

# Versão

Versão: 1.2.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
