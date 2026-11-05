# Status da tradução PT-BR

- **Idioma-fonte:** EN-US
- **Versão da fonte:** 1.5.0 (primeira baseline pública estável).
- **Última revisão:** 2026-11-04
- **Escopo:** registrar a cobertura PT-BR da primeira release pública `v1.5.0`,
  as atualizações de manutenção pós-tag no checkout atual e distinguir os
  registros de versões anteriores do repositório privado predecessor.
- **Histórico predecessor:** os registros de `v1.3.0` e `v1.4.0` descrevem
  versões lançadas no repositório privado anterior; nenhuma tag ou arquivo de
  release foi migrado para este repositório público.
- **Organização:** os documentos públicos traduzidos ficam em
  `locales/pt-BR/public-docs/`; o espelho do ADR fica em
  `locales/pt-BR/docs/ADR.md`. Os caminhos PT-BR de compatibilidade na raiz
  foram removidos; `README.pt-BR.md` continua como página inicial.
- **Revisão semântica:** os espelhos do overview, roadmap, changelog, testing,
  ADR e modelo de primeiro prompt foram comparados às fontes nesta atualização; a
  validação automatizada continua verificando somente presença e estrutura, não
  certificando a tradução.
- **Cobertura publicada em `v1.5.0`:** inclui templates EN-US/PT-BR, espelhos
  PT-BR dos documentos públicos ativos, as quatro correções posteriores à
  `v1.4.0` do predecessor e a regra padrão para manter `.ai/state/` local.
- **Cobertura atual dos módulos suplementares opcionais aprovados:** os quatro
  módulos têm espelhos PT-BR no checkout e são verificados separadamente quanto
  a presença, correspondência de versões, status opcional aprovado e paridade
  estrutural. Eles permanecem
  fora do grafo obrigatório de dependências.
- **Validação remota:** a release `v1.5.0` é publicada somente após o commit exato
  da tag passar pela matriz GitHub Actions em Ubuntu, macOS e Windows, seguida do
  empacotamento e conferência de checksums. A paridade estrutural não certifica,
  por si só, a qualidade semântica das traduções.

## Matriz de cobertura

| Área | Histórico do predecessor | Cobertura pública em `v1.5.0` | Observação |
| --- | --- | --- | --- |
| `PROJECT_TEMPLATE/` | Presente em versões históricas | Templates EN-US/PT-BR incluídos; paridade estrutural validada | `.ai/state/` é ignorado por padrão no `.gitignore` copiado a projetos novos. |
| Bootstrap e entrypoints públicos | Evoluíram em versões anteriores | Guias EN-US/PT-BR incluídos e sincronizados | EN-US é a fonte técnica; documentos públicos PT-BR ficam em `public-docs/`, sem aliases na raiz. |
| `workflows/` | Evoluíram em versões anteriores | Espelhos PT-BR incluídos | A paridade estrutural é validada pelos scripts nativos. |
| `protocols/` | Evoluíram em versões anteriores | Espelhos PT-BR incluídos | A paridade estrutural é validada pelos scripts nativos. |
| `schemas/` | Evoluíram em versões anteriores | Espelhos PT-BR incluídos | O schema de auditoria de dívida técnica está incluído na baseline pública. |
| `agents/` | Evoluíram em versões anteriores | Agentes canônicos espelhados | `SPECS.md` em PT-BR define comportamento, não configuração de plataforma. |
| `knowledge/` estável | Evoluiu em versões anteriores | Espelhos PT-BR incluídos | `ENGINEERING_MOTION_DESIGN` permanece condicional; módulos suplementares aprovados continuam opcionais. |
| Manutenção pós-tag | Fora da baseline publicada `v1.5.0` | Orientações e espelhos atualizados no checkout atual | A extensão opcional de simulação interativa não altera a release publicada nem adiciona dependências. |
| `knowledge/` suplementar opcional aprovado | Não fazia parte de baselines anteriores | Quatro espelhos incluídos e verificados separadamente | Permanecem fora do grafo obrigatório de dependências. |
| Documentos públicos extensos ativos | Não faziam parte das primeiras tranches históricas | Espelhos PT-BR incluídos e revisados semanticamente | `public-docs/` contém overview, roadmap, changelog, guias e o modelo de primeiro prompt; `docs/ADR.md` contém o espelho do ADR. |
| Referências legadas/de apoio | Fora do escopo de tradução ativa | Guia-fonte preservado | O guia em `docs/reference/` é detalhado e não normativo por si só. |

Nota de cobertura: as versões anteriores descritas no changelog pertencem ao
repositório privado predecessor, cujas tags não foram migradas. A coluna pública
descreve o snapshot `v1.5.0`. “Completa” indica cobertura de arquivos e paridade
estrutural, não certificação automatizada da qualidade semântica da tradução. O
playbook legado foi removido da superfície atual. O guia detalhado em
`docs/reference/` é preservado como fonte não normativa; somente requisitos
adotados nos documentos canônicos são operacionais.

O projeto mantém um único arquivo de release com os dois pacotes de idioma; não
serão criados arquivos de release separados por idioma. A seleção de idioma
continua explícita no bootstrap.

Quando uma tradução for publicada, mantenha o caminho equivalente, registre o
baseline correto da fonte e revise conteúdo e paridade estrutural. Os módulos
suplementares são opcionais e permanecem fora do grafo obrigatório de
dependências; a tradução PT-BR não altera essa fronteira. EN-US continua sendo o
idioma-fonte técnico; os espelhos PT-BR preservam o status opcional aprovado,
sem tornar obrigatória a adoção de qualquer módulo.
