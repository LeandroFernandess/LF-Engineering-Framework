# Inspetor dinâmico de auditoria de segurança

O inspetor lê um projeto local e gera um PDF preliminar usando as categorias
QA-Security do LF Engineering System. Ele coleta evidências; não é um scanner
completo nem uma aprovação de QA.

## Execução

Na raiz do projeto que será inspecionado:

```sh
python3 /caminho/para/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py
```

Substitua o caminho de exemplo pela localização real do checkout do Framework.
O diretório pode se chamar `LF-Engineering-Framework` ou qualquer outro nome; o
inspetor não depende do nome da pasta.

O diretório atual é o alvo padrão. Para indicar outro diretório:

```sh
python3 /caminho/para/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py \
  --project /caminho/para/projeto
```

Por padrão, o relatório é gravado em
`<projeto>/docs/security-audit/relatorio-auditoria-seguranca.pdf`. Cada execução
sobrescreve essa saída. Use `--output CAMINHO` para selecionar outra; caminhos
relativos são resolvidos dentro do projeto selecionado. O PDF contém caminhos de
evidência relativos e o nome do diretório, não a raiz absoluta.

O inspetor usa somente a biblioteca padrão do Python. Não executa código ou
comandos do projeto, não usa rede, não altera permissões e não apaga arquivos.
Ignora diretórios comuns de dependências/build e não segue links simbólicos.
Correspondências de formatos de credenciais são reportadas somente por tipo,
caminho e linha; o valor encontrado nunca é copiado para o PDF.

## Interpretação

O relatório inventaria arquivos, manifestos, indicadores de web/backend/configuração
e candidatos a estado local. Ele verifica poucos formatos de credencial e aponta
permissões potencialmente amplas em arquivos que parecem conter estado. A ausência
de um indicador heurístico não prova que a superfície esteja ausente. Autenticação/
autorização, fluxos de injeção, vulnerabilidades de dependências, deploy,
performance, acessibilidade, observabilidade e comportamento contra prompt
injection ainda exigem revisão humana e testes específicos do projeto.

O PDF de 19/10/2026 está incluído como evidência histórica neste primeiro
snapshot público; ele não é uma auditoria atual. Nenhuma tag do repositório
predecessor foi importada. Uma execução local gera um relatório dinâmico atual.
