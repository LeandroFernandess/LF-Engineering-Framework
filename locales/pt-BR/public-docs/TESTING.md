# Testes do LF Engineering System

Idiomas: [EN-US](../../../TESTING.md) | [PT-BR](TESTING.md)

## Validação local

Na raiz do repositório em macOS/Linux. Se o checkout tiver um nome personalizado,
como `LF-Engineering-Framework`, entre primeiro nesse diretório; os scripts
localizam o Framework a partir da própria localização e não exigem um nome fixo:

```sh
./scripts/validate-framework.sh
./scripts/test-bootstrap.sh
```

No Windows PowerShell:

```powershell
.\scripts\validate-framework.ps1
.\scripts\test-bootstrap.ps1
```

No macOS, se o PowerShell local criar `StartupProfileData-NonInteractive` no
diretório de trabalho, inicie esses comandos em uma pasta temporária e informe
os caminhos absolutos dos scripts. O PowerShell pode criar esse arquivo antes
de os scripts começarem; remova o arquivo temporário após o processo terminar.

Execute os testes de regressão do inspetor dinâmico (Python 3.10+; somente
biblioteca padrão):

```sh
python3 -m unittest discover -s docs/security-audit -p 'test_*.py' -v
```

No Windows PowerShell, use `python` em vez de `python3` se esse for o nome do
launcher instalado.

Para inspecionar o diretório atual e sobrescrever seu relatório, execute a partir
do projeto. Para inspecionar outro projeto, use `--project`:

```sh
python3 /caminho/para/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py
python3 /caminho/para/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py --project /caminho/para/projeto
```

Por padrão, a saída fica em
`<projeto>/docs/security-audit/relatorio-auditoria-seguranca.pdf` e é sobrescrita
a cada execução. Esta é uma inspeção estática local e preliminar, não uma auditoria
QA-Security completa. O PDF de 19/10/2026 está incluído como evidência histórica
no primeiro snapshot público; não é uma auditoria atual e nenhuma tag do
repositório predecessor foi importada. Uma execução local gera um relatório atual.

## Cenários cobertos

- Os dois assistentes exibem o contato do responsável na ajuda e no
  cabeçalho de abertura. Os menus são verticais, as escolhas aceitas são destacadas e
  `b` volta uma etapa preservando as respostas anteriores. A atividade do
  bootstrap usa uma linha antes da prévia alinhada; terminais estreitos/modo
  estático não animam.
- Dry-run de projeto novo não cria o diretório-alvo.
- Aplicação de projeto novo copia o template no idioma selecionado.
- Seleção do template PT-BR, links públicos versionados ao Framework e registros
  instalados sem caminhos de máquina.
- Adapters Codex, Claude, Gemini e OpenCode nos fluxos interativo e direto do
  bootstrap. A escolha é obrigatória; valor vazio ou não suportado falha antes
  de criar o destino.
- Preservação de README, AGENTS, `.gitignore`, `.ai/`, documentação e
  configuração de CLI existentes.
- Arquivos ocultos e caminhos com espaços.
- Substituição do placeholder de referência remota, parsing JSON, fixação de
  versão e instruções canônicas do adapter OpenCode; a árvore independente e a
  configuração MCP na raiz do Framework devem permanecer ausentes.
- Rejeição de idioma e adapter inválidos.
- Recusa de operação dentro do diretório do Framework.
- Paridade estrutural de arquivos, headings, tabelas, blocos de código e
  comentários HTML do template PT-BR.
- Paridade estrutural dos espelhos PT-BR de `OVERVIEW.md`, `ROADMAP.md`,
  `CHANGELOG.md` e `docs/ADR.md`.
- Os quatro módulos suplementares de Knowledge mantêm o status opcional aprovado
  e versões correspondentes em EN-US/PT-BR; seus espelhos são obrigatórios e verificados estruturalmente
  em separado. Eles permanecem fora do grafo obrigatório de dependências, e
  esse status não autoriza instalação ou integração de ferramentas externas.
- Recusa de fronteira do Framework através de links/junctions de diretório,
  incluindo diretórios vinculados aninhados que poderiam redirecionar gravações
  dos templates para fora do alvo selecionado.
- O inspetor dinâmico usa os dados atuais do projeto, sobrescreve a saída anterior,
  oculta valores com formato de credenciais, reporta indicadores de documentação/
  estado e rejeita caminhos por links simbólicos.
- No `--apply`, o bootstrap restringe diretórios/arquivos de estado local ao
  proprietário e preserva o conteúdo existente; o dry-run não altera permissões.

A geração de archives de release não é exercitada por estes validadores locais.
O workflow de release executa `scripts/package-release.sh` somente depois que o
commit exato da tag passa pela matriz de CI multiplataforma; o script de
empacotamento exige um checkout limpo.

O GitHub Actions repete a validação em Ubuntu, macOS e Windows a cada push e
pull request. A branch pública `main` exige pull requests e as três verificações
de validação multiplataforma. O workflow de release também valida o commit exato da tag na mesma
matriz antes de empacotar. Após validação e empacotamento bem-sucedidos, o job de
publicação é executado automaticamente com `contents: write`; ele não usa um
GitHub Environment nem exige aprovação manual de revisor. Um push de tag
estável correspondente é o único gatilho de release e exige autorização
separada do responsável. A regra de pull request não exige uma aprovação de
revisor para permitir que o único mantenedor faça merge após a aprovação dos
checks. Restrinja o acesso de escrita/admin e reavalie esta política antes de
conceder acesso de escrita a outra pessoa. Esses controles são independentes dos
gates de validação do workflow.

## Verificações do assistente e da documentação

```sh
python3 scripts/check-docs.py
python3 -m unittest discover -s scripts/tests -v
```

No Windows use `python` quando esse for o launcher disponível. Python é uma
dependência de manutenção/CI, não do assistente. A matriz de CI executa os testes
nas três plataformas. As sessões com pseudoterminal são executadas em POSIX;
o Windows executa os testes nativos de bootstrap e recusa de entrada redirecionada.
Antes de uma release, valide manualmente a seleção de idioma, confirmação,
cancelamento, Ctrl+C, cabeçalho de abertura e indicador de atividade estático no Windows Terminal.
Verifique também um terminal POSIX estreito e um terminal básico sem animação.

A verificação documental cobre links locais inline e por referência, títulos e
âncoras HTML fora de blocos de código. Caminhos literais de templates não são
tratados como links: referem-se ao projeto gerado ou à biblioteca externa.
URLs externas não são acessadas. READMEs possuem estrutura diferente por idioma;
seus links e revisão são verificados, sem exigir paridade de títulos.

`locales/translation-review.json` registra hashes dos pares revisados. Após
alterar um deles, compare fonte e tradução, registre a nova revisão e atualize
os hashes SHA-256. Nunca atualize hashes apenas para silenciar uma falha.
