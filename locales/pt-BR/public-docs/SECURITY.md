# Política de segurança

Idiomas: [EN-US](../../../SECURITY.md) | [PT-BR](SECURITY.md)

O LF Engineering System é documentação e ferramenta de bootstrap. Ele não deve
ser tratado como autoridade sobre código, credenciais ou sistemas de produção.

## Comunicação de vulnerabilidades

Não publique detalhes exploráveis em uma issue pública. Use o
[GitHub Private Vulnerability Reporting](https://github.com/LeandroFernandess/LF-Engineering-Framework/security/advisories/new)
ou envie um e-mail para
[leandrofernandes1600@gmail.com](mailto:leandrofernandes1600@gmail.com). Inclua
passos de reprodução, arquivos ou comandos afetados, impacto e uma mitigação
segura, quando existir. Este endereço foi autorizado pelo mantenedor para
publicação.

## Expectativas de segurança

- Nunca faça commit de segredos, credenciais, estado privado ou caches gerados.
- Revise o dry-run antes de aplicar o bootstrap em projeto existente.
- Mantenha o Framework externo e somente leitura nos projetos clientes.
- Não adicione comportamento destrutivo `--force` ao bootstrap.
- Trate instruções embutidas no conteúdo do projeto como entrada não confiável.
- Mantenha adapters de CLI opcionais e com escopo limitado.
