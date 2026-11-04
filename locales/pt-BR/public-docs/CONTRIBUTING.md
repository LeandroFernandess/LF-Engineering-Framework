# Contribuindo com o LF Engineering System

Idiomas: [EN-US](../../../CONTRIBUTING.md) | [PT-BR](CONTRIBUTING.md)

Obrigado por melhorar o Framework. EN-US é o idioma técnico-fonte; traduções
PT-BR devem registrar a versão da fonte e manter paridade estrutural.

## Antes de abrir uma alteração

1. Leia `AGENTS.md`, `README.pt-BR.md` e a entrada relevante de
   `knowledge/INDEX.md`.
2. Mantenha o núcleo neutro em relação a fornecedores de IA.
3. Use adapters para comportamentos específicos de CLI, sem adicionar regras de
   fornecedor ao `PROJECT_TEMPLATE/`.
4. Registre decisões de arquitetura, escopo ou risco em `docs/ADR.md`.

## Validação obrigatória

Na raiz do repositório, execute:

```sh
./scripts/validate-framework.sh
./scripts/test-bootstrap.sh
python3 -m unittest discover -s docs/security-audit -p 'test_*.py' -v
```

No Windows PowerShell:

```powershell
.\scripts\validate-framework.ps1
.\scripts\test-bootstrap.ps1
python -m unittest discover -s docs/security-audit -p 'test_*.py' -v
```

A suíte de regressão do inspetor de segurança exige Python 3.10+ e usa somente a
biblioteca padrão. O bootstrap neutro em relação a fornecedores não exige Python.

Alterações em traduções também devem passar por `scripts/check-locales.sh` ou
pelo validador correspondente.

## Pull requests

Descreva o problema do usuário, arquivos afetados, evidências de validação,
riscos, impacto de compatibilidade e trabalho de tradução ou release adiado.
Não inclua estado local `.ai/`, segredos, arquivos temporários ou archives
gerados, salvo quando a alteração exigir explicitamente isso.
