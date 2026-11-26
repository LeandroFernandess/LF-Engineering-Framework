# Status da tradução PT-BR

- **Idioma-fonte:** EN-US
- **Versão da fonte:** 1.6.0 (baseline pública atual).
- **Última revisão:** 2026-11-15
- **Escopo:** registrar a cobertura PT-BR até a release `v1.6.0`,
  incluindo a primeira release pública `v1.5.0`, e distinguir os
  registros de versões anteriores do repositório privado predecessor.
- **Histórico predecessor:** os registros de `v1.3.0` e `v1.4.0` descrevem
  versões lançadas no repositório privado anterior; nenhuma tag ou arquivo de
  release foi migrado para este repositório público.
- **Organização:** os documentos públicos traduzidos ficam em
  `locales/pt-BR/public-docs/`; o espelho do ADR fica em
  `locales/pt-BR/docs/ADR.md`. Os caminhos PT-BR de compatibilidade na raiz
  foram removidos; `README.pt-BR.md` continua como página inicial.
- **Revisão semântica:** os 149 pares ativos do inventário EN-US/PT-BR têm
  registros com escopo explícito e fingerprints atuais em
  `locales/translation-review.json`. A revisão compara conteúdo e termos no
  escopo descrito por par; a automação detecta mudanças posteriores, mas não
  certifica a qualidade semântica.
- **Cobertura publicada em `v1.5.0`:** inclui templates EN-US/PT-BR, espelhos
  PT-BR dos documentos públicos ativos, as quatro correções posteriores à
  `v1.4.0` do predecessor e a regra padrão para manter `.ai/state/` local.
- **Cobertura atual dos módulos suplementares opcionais aprovados:** os quatro
  módulos têm espelhos PT-BR no checkout e são verificados separadamente quanto
  a presença, correspondência de versões, status opcional aprovado e paridade
  estrutural. Eles permanecem
  fora do grafo obrigatório de dependências.
- **Validação remota:** a release `v1.6.0` foi publicada após o commit exato
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
| Manutenção após `v1.5.0` | Fora da baseline publicada `v1.5.0` | Incluída na release `v1.6.0` | A extensão opcional de simulação interativa não adiciona dependências. |
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

O release mantém arquivos completos de código-fonte e inclui seis pacotes
menores: macOS, Linux e Windows, cada sistema em `en-US` e `pt-BR`. O usuário
seleciona um pacote correspondente ao sistema e idioma escolhidos.

Quando uma tradução for publicada, mantenha o caminho equivalente, registre o
baseline correto da fonte e revise conteúdo e paridade estrutural. Os módulos
suplementares são opcionais e permanecem fora do grafo obrigatório de
dependências; a tradução PT-BR não altera essa fronteira. EN-US continua sendo o
idioma-fonte técnico; os espelhos PT-BR preservam o status opcional aprovado,
sem tornar obrigatória a adoção de qualquer módulo.

## Revisão de manutenção de 2026-11-15

Fonte de partida: checkout `0c2d31a`; alterações desta manutenção são posteriores
à baseline publicada. As onze especificações `agents/*/SPECS.md` foram traduzidas
para EN-US e comparadas à prosa dos espelhos PT-BR. Regras condicionais, limites de
responsabilidade e identificadores foram preservados. Os rótulos descritivos
iniciais dos espelhos passaram a usar português.

READMEs, guias de início, índice e README do Knowledge, textos novos do changelog,
ADR-022 e instruções novas de testes foram alinhados nos dois idiomas. O glossário
bilíngue está em `docs/GLOSSARY.md`. Os registros em
`locales/translation-review.json` informam o escopo comparado para cada par e
seus hashes sinalizam alterações posteriores; eles não substituem a revisão
humana nem certificam automaticamente a semântica.

Os onze pares públicos de `scripts/public-document-pairs.tsv` agora participam da
validação estrutural nativa. READMEs são exceção estrutural intencional: possuem
navegação diferente, mas são revisados e têm links verificados. Todos os 143
pares ativos têm revisão registrada; módulos extensos indicam no registro quais
seções foram comparadas. A checagem automatizada verifica presença, links,
estrutura e fingerprints, não a qualidade linguística por conta própria.

Os dois assistentes localizam mensagens e documentos novos. A saída dos comandos
nativos de automação e as chaves técnicas do registro permanecem em inglês por
compatibilidade. Arquivos existentes não são traduzidos nem migrados. O fluxo
de instalação oferece arquivos completos do código-fonte e seis pacotes menores
por sistema operacional e idioma, escolhidos após as respostas do usuário. Os
pacotes incluem o prompt de início e os guias no idioma selecionado.
