#!/bin/sh
# Interactive frontend; scripts/bootstrap.sh remains the automation interface.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
animated=1
colored=1
author_email='leandorfernandes1600@gmail.com'
for option in "$@"; do
  case "$option" in
    --no-animation) animated=0 ;;
    --no-color) colored=0 ;;
    --help|-h) printf '%s\n' 'sh setup.sh [--no-animation] [--no-color]' 'Author / Autor: Leandro Fernandes <leandorfernandes1600@gmail.com>' 'Automation / Automação: sh scripts/bootstrap.sh --help'; exit 0 ;;
    *) printf 'Unknown option / Opção desconhecida: %s\n' "$option" >&2; exit 1 ;;
  esac
done
if [ ! -t 0 ] || [ ! -t 1 ] || [ -n "${CI:-}" ]; then
  printf '%s\n' 'Interactive terminal required / É necessário um terminal interativo.' 'Automation / Automação: sh scripts/bootstrap.sh --help' >&2
  exit 1
fi
case "${TERM:-dumb}" in dumb|'') animated=0; colored=0 ;; esac
[ -z "${NO_COLOR+x}" ] || colored=0
terminal_width=${COLUMNS:-80}
case "$terminal_width" in ''|*[!0-9]*) terminal_width=80 ;; esac
if [ "$terminal_width" -lt 44 ]; then animated=0; fi
language=en-US
log=
worker=
animator=
work_frame_drawn=0
cleanup() {
  if [ -n "$worker" ]; then kill "$worker" 2>/dev/null || :; wait "$worker" 2>/dev/null || :; fi
  if [ -n "$animator" ]; then kill "$animator" 2>/dev/null || :; wait "$animator" 2>/dev/null || :; animator=; fi
  if [ "$work_frame_drawn" -eq 1 ]; then clear_work_frame; fi
  [ -z "$log" ] || rm -f "$log"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP
say() { if [ "$language" = pt-BR ]; then printf '%s\n' "$2"; else printf '%s\n' "$1"; fi; }
heading() {
  [ "$colored" -eq 0 ] || printf '\033[1;36m'
  say "$1" "$2"
  [ "$colored" -eq 0 ] || printf '\033[0m'
}
answer() {
  say "$1" "$2"
  printf '> '
  if ! IFS= read -r reply; then say 'Cancelled.' 'Cancelado.'; exit 0; fi
}
brand_frame() {
  frame=$1
  redraw=${2:-}
  case "$frame" in
    0) set -- '+*-------------------------------------+' '|   LF  /  LF ENGINEERING FRAMEWORK    |' '|       Leandro Fernandes              |' "|  $author_email      |" '+--------------------------------------+' ;;
    1) set -- '+--------------------------------------+' '|*  LF  /  LF ENGINEERING FRAMEWORK    |' '|       Leandro Fernandes              |' "|  $author_email      |" '+--------------------------------------+' ;;
    2) set -- '+--------------------------------------+' '|   LF  /  LF ENGINEERING FRAMEWORK    |' '|*      Leandro Fernandes              |' "|  $author_email      |" '+--------------------------------------+' ;;
    3) set -- '+--------------------------------------+' '|   LF  /  LF ENGINEERING FRAMEWORK    |' '|       Leandro Fernandes              |' "|* $author_email      |" '+--------------------------------------+' ;;
    4) set -- '+--------------------------------------+' '|   LF  /  LF ENGINEERING FRAMEWORK    |' '|       Leandro Fernandes              |' "|  $author_email      |" '+-------------------------------------*+' ;;
    *) set -- '+--------------------------------------+' '|   LF  /  LF ENGINEERING FRAMEWORK    |' '|       Leandro Fernandes              |' "|  $author_email      |" '+--------------------------------------+' ;;
  esac
  if [ "$terminal_width" -lt 40 ]; then
    printf '%s\n' 'LF Engineering Framework' 'Leandro Fernandes' "$author_email"
    return
  fi
  if [ "$redraw" = redraw ]; then
    printf '\033[5A\033[K%s\n\033[K%s\n\033[K%s\n\033[K%s\n\033[K%s\n' "$@"
  else
    printf '%s\n' "$@"
  fi
}
show_intro() {
  if [ "$animated" -eq 1 ]; then
    brand_frame 0
    sleep 0.12
    brand_frame 1 redraw
    sleep 0.12
    brand_frame 2 redraw
    sleep 0.12
    brand_frame 3 redraw
    sleep 0.12
    brand_frame 4 redraw
    sleep 0.12
  else
    brand_frame static
  fi
}
clear_work_frame() {
  printf '\033[5A\033[K\n\033[K\n\033[K\n\033[K\n\033[K\n'
  work_frame_drawn=0
}
show_intro
while :; do
  answer 'Language / Idioma: 1) Português (Brasil)  2) English' 'Language / Idioma: 1) Português (Brasil)  2) English'
  case "$reply" in 1) language=pt-BR; break ;; 2) language=en-US; break ;; *) say 'Choose 1 or 2.' 'Escolha 1 ou 2.' ;; esac
done
heading '1/3 · Project' '1/3 · Projeto'
while :; do
  answer 'Project directory (absolute or relative to your current directory):' 'Diretório do projeto (absoluto ou relativo ao diretório atual):'
  [ -z "$reply" ] || break
  say 'Enter a directory.' 'Informe um diretório.'
done
target=$reply
case "$target" in '~') target=$HOME ;; '~/'*) target="$HOME/${target#\~/}" ;; esac
heading '2/3 · Integration' '2/3 · Integração'
while :; do
  answer '1) Generic (default)  2) Codex  3) Claude  4) Gemini  5) OpenCode' '1) Genérica (padrão)  2) Codex  3) Claude  4) Gemini  5) OpenCode'
  case "$reply" in ''|1) adapter=generic; break ;; 2) adapter=codex; break ;; 3) adapter=claude; break ;; 4) adapter=gemini; break ;; 5) adapter=opencode; break ;; *) say 'Choose 1–5.' 'Escolha de 1 a 5.' ;; esac
done
show_output() {
  if [ "$language" = pt-BR ]; then
    awk -F '\t' 'NR==FNR {en[++n]=$1; pt[n]=$2; next} {line=$0; for(i=1;i<=n;i++) if(index(line,en[i])==1) {line=pt[i] substr(line,length(en[i])+1); break} print line}' "$ROOT/scripts/i18n/setup.tsv" "$log"
  else cat "$log"; fi
}
run_bootstrap() {
  log=$(mktemp "${TMPDIR:-/tmp}/lf-setup.XXXXXX")
  sh "$ROOT/scripts/bootstrap.sh" --framework-path "$ROOT" --target "$target" --language "$language" --adapter "$adapter" "$1" >"$log" 2>&1 &
  worker=$!
  if [ "$animated" -eq 1 ]; then
    brand_frame 0
    work_frame_drawn=1
    (frame=1; while :; do sleep 0.15; brand_frame "$frame" redraw; frame=$(( (frame + 1) % 5 )); done) &
    animator=$!
  fi
  status=0
  wait "$worker" || status=$?
  worker=
  if [ -n "$animator" ]; then kill "$animator" 2>/dev/null || :; wait "$animator" 2>/dev/null || :; animator=; fi
  if [ "$work_frame_drawn" -eq 1 ]; then clear_work_frame; fi
  show_output
  rm -f "$log"; log=
  if [ "$status" -ne 0 ]; then
    say 'Setup failed. Review the error above, correct the cause and run setup again. Existing files are preserved; an interrupted apply may leave newly added files.' 'A instalação falhou. Revise o erro acima, corrija a causa e execute novamente. Arquivos existentes são preservados; uma aplicação interrompida pode deixar arquivos novos.' >&2
    exit "$status"
  fi
}
heading '3/3 · Review' '3/3 · Revisão'
run_bootstrap --dry-run
record="$target/.ai/framework-installation.md"
if [ -f "$record" ]; then
  if ! grep -Fqx -- "- Language: $language" "$record" || ! grep -Fqx -- "- Adapter: $adapter" "$record"; then
    say 'Warning: the installation record differs. This only adds missing files; it does not migrate language or integration. The previous record is preserved.' 'Atenção: o registro de instalação difere. Esta operação apenas adiciona arquivos ausentes; não migra idioma ou integração. O registro anterior será preservado.'
  fi
fi
say 'Preserved instructions/configuration may need manual reconciliation. Existing state permissions will be restricted to the current user.' 'Instruções/configurações preservadas podem precisar de revisão manual. As permissões do estado existente serão restritas ao usuário atual.'
answer 'Apply these changes? [y/N]' 'Aplicar estas alterações? [s/N]'
case "$language:$reply" in en-US:y|en-US:Y|pt-BR:s|pt-BR:S) ;; *) say 'Cancelled. No project files changed.' 'Cancelado. Nenhum arquivo do projeto foi alterado.'; exit 0 ;; esac
run_bootstrap --apply
say 'Next: open the project, read LF_ENGINEERING.md and AGENTS.md, review preserved configuration, then use FIRST_PROMPT_TEMPLATE.md from the Framework.' 'Próximo passo: abra o projeto, leia LF_ENGINEERING.md e AGENTS.md, revise as configurações preservadas e use locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md do Framework.'
