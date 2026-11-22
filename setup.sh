#!/bin/sh
# Interactive first-run installer; scripts/bootstrap.sh remains the automation interface.
set -eu

REPOSITORY_URL='https://github.com/LeandroFernandess/LF-Engineering-Framework'
RELEASE_DOWNLOAD_URL="$REPOSITORY_URL/releases/latest/download"
AUTHOR='Leandro Fernandes'
AUTHOR_EMAIL='leandrofernandes1600@gmail.com'
GITHUB_URL='https://github.com/LeandroFernandess'
LINKEDIN_URL='https://www.linkedin.com/in/leandro-fernandes-951ab3189'
ROOT=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
local_bundle=1
if [ -d "$ROOT/PROJECT_TEMPLATE" ] && [ -f "$ROOT/scripts/bootstrap.sh" ] && [ -d "$ROOT/adapters" ]; then local_bundle=0; fi
package_platform=
package_language=
if [ "$local_bundle" -eq 0 ] && [ -f "$ROOT/framework-manifest.json" ]; then
  package_platform=$(sed -n 's/^  "target_platform": "\([^"]*\)",$/\1/p' "$ROOT/framework-manifest.json")
  package_language=$(sed -n 's/^  "language": "\([^"]*\)",$/\1/p' "$ROOT/framework-manifest.json")
  case "$package_platform:$package_language" in macos:en-US|macos:pt-BR|linux:en-US|linux:pt-BR) ;; *) printf '%s\n' 'The Framework package manifest is invalid.' >&2; exit 1 ;; esac
fi
animated=1
colored=1
work_dir=
install_stage=
worker=
animator=
work_indicator_drawn=0
language=en-US

for option in "$@"; do
  case "$option" in
    --no-animation) animated=0 ;;
    --no-color) colored=0 ;;
    --help|-h)
      printf '%s\n' 'sh setup.sh [--no-animation] [--no-color]' \
        "Author: $AUTHOR <$AUTHOR_EMAIL>" "GitHub: $GITHUB_URL" "LinkedIn: $LINKEDIN_URL" \
        'Automation: sh scripts/bootstrap.sh --help'
      exit 0
      ;;
    *) printf 'Unknown option: %s\n' "$option" >&2; exit 1 ;;
  esac
done

if [ ! -t 0 ] || [ ! -t 1 ] || [ -n "${CI:-}" ]; then
  printf '%s\n' 'Interactive terminal required. Automation: sh scripts/bootstrap.sh --help' >&2
  exit 1
fi
case "${TERM:-dumb}" in
  dumb|'') animated=0; colored=0 ;;
  xterm*|screen*|tmux*|vt100*|ansi*|rxvt*|linux|cygwin*|msys*) ;;
  *) animated=0; colored=0 ;;
esac
if [ -n "${NO_COLOR:-}" ]; then colored=0; fi
terminal_size=$(stty size 2>/dev/null || :)
terminal_width=${COLUMNS:-${terminal_size#* }}
case "$terminal_width" in ''|0|*[!0-9]*) terminal_width=80 ;; esac
if [ "$terminal_width" -lt 78 ]; then animated=0; fi

host_platform=$(uname -s 2>/dev/null || printf unknown)
case "$host_platform" in
  Darwin) host_platform=macos ;;
  Linux) host_platform=linux ;;
  *) host_platform=unsupported ;;
esac
if [ "$host_platform" = unsupported ]; then
  printf '%s\n' 'This script supports macOS and Linux. On Windows, use setup.ps1 from PowerShell.' >&2
  exit 1
fi

cleanup() {
  if [ -n "$worker" ]; then kill "$worker" 2>/dev/null || :; wait "$worker" 2>/dev/null || :; fi
  if [ -n "$animator" ]; then kill "$animator" 2>/dev/null || :; wait "$animator" 2>/dev/null || :; animator=; fi
  if [ "$work_indicator_drawn" -eq 1 ]; then clear_work_indicator; fi
  [ -z "$work_dir" ] || rm -rf "$work_dir"
  [ -z "$install_stage" ] || rm -rf "$install_stage"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP

prompt_english() {
  printf '%b\n' "$1"
  printf '> '
  if ! IFS= read -r reply; then printf '%s\n' 'Cancelled.'; exit 0; fi
}
say() { if [ "$language" = pt-BR ]; then printf '%s\n' "$2"; else printf '%s\n' "$1"; fi; }
heading() {
  if [ "$colored" -eq 1 ]; then printf '\033[1;36m'; fi
  say "$1" "$2"
  if [ "$colored" -eq 1 ]; then printf '\033[0m'; fi
}
section_divider() {
  rule_width=$((terminal_width - 4))
  [ "$rule_width" -gt 72 ] && rule_width=72
  [ "$rule_width" -lt 1 ] && rule_width=1
  rule_line=
  rule_index=0
  while [ "$rule_index" -lt "$rule_width" ]; do
    rule_line="$rule_line-"
    rule_index=$((rule_index + 1))
  done
  printf '%s\n' "$rule_line"
}
answer() {
  say "$1" "$2"
  printf '> '
  if ! IFS= read -r reply; then say 'Cancelled.' 'Cancelado.'; exit 0; fi
}
if [ "$colored" -eq 1 ]; then
  back_hint_en="$(printf '\033[1;33mb: back\033[0m')"
  back_hint_pt="$(printf '\033[1;33mb: voltar\033[0m')"
  back_menu_en="$(printf '\033[1;33mb) Back\033[0m')"
  back_menu_pt="$(printf '\033[1;33mb) Voltar\033[0m')"
else
  back_hint_en='>>> b: back <<<'
  back_hint_pt='>>> b: voltar <<<'
  back_menu_en='>>> b) Back <<<'
  back_menu_pt='>>> b) Voltar <<<'
fi
selection() {
  if [ "$colored" -eq 1 ]; then printf '\033[1;32m'; fi
  printf '✓ %s: %s\n' "$1" "$2"
  if [ "$colored" -eq 1 ]; then printf '\033[0m'; fi
}
select_platform() {
  section_divider
  while :; do
    prompt_english "Select operating system:\n  1) macOS\n  2) Linux\n  3) Windows\n  $back_menu_en (no previous step)\nPress Enter for the detected host: $host_platform"
    case "$reply" in
      b|B) printf '%s\n' 'There is no previous step.'; continue ;;
      '') selected_platform=$host_platform ;;
      1) selected_platform=macos ;;
      2) selected_platform=linux ;;
      3) selected_platform=windows ;;
      *) printf '%s\n' 'Choose 1, 2 or 3, or press b.'; continue ;;
    esac
    if [ "$selected_platform" != "$host_platform" ]; then
      printf 'This terminal is running on %s. Run the matching native installer for the selected operating system.\n' "$host_platform"
      continue
    fi
    if [ -n "$package_platform" ] && [ "$selected_platform" != "$package_platform" ]; then
      printf 'This Framework library package is for %s.\n' "$package_platform"
      continue
    fi
    selection 'System' "$selected_platform"
    return
  done
}
select_language() {
  section_divider
  while :; do
    if [ -n "$package_language" ]; then prompt_english "Select language:\n  1) English\n  2) Português (Brasil)\n  $back_menu_en\nPackage language: $package_language"
    else prompt_english "Select language:\n  1) English (default)\n  2) Português (Brasil)\n  $back_menu_en"; fi
    case "$reply" in
      b|B) select_platform; continue ;;
      ''|1) language=en-US ;;
      2) language=pt-BR ;;
      *) printf '%s\n' 'Choose 1 or 2, or press b.'; continue ;;
    esac
    if [ -n "$package_language" ] && [ "$language" != "$package_language" ]; then
      printf 'This Framework library contains the %s language package. Choose that language to continue.\n' "$package_language"
      continue
    fi
    if [ "$language" = pt-BR ]; then selection 'Idioma' 'Português (Brasil)'; else selection 'Language' 'English'; fi
    return
  done
}

show_intro() {
  if [ "$terminal_width" -lt 78 ]; then
    if [ "$terminal_width" -lt 32 ]; then printf '%s\n' 'LF FRAMEWORK'; else printf '%s\n' 'LF ENGINEERING FRAMEWORK'; fi
    printf '\n%s\n%s\n%s\n%s\n' "$AUTHOR_EMAIL" 'github.com/LeandroFernandess' 'linkedin.com/in/' '  leandro-fernandes-951ab3189'
    return
  fi
  center_row() {
    text=$1
    left=$(( (70 - ${#text}) / 2 ))
    right=$(( 70 - left - ${#text} ))
    printf '│ %*s%s%*s │\n' "$left" '' "$text" "$right" ''
  }
  if [ "$colored" -eq 1 ]; then printf '\033[1;36m'; fi
  printf '%s\n' '┌────────────────────────────────────────────────────────────────────────┐'
  if [ "$colored" -eq 1 ]; then printf '\033[0m\033[1;37m'; fi
  center_row 'LF ENGINEERING FRAMEWORK'
  if [ "$colored" -eq 1 ]; then printf '\033[0m\033[36m'; fi
  printf '│ %-70s │\n' "Contact: $AUTHOR_EMAIL" "GitHub: $GITHUB_URL" "LinkedIn: $LINKEDIN_URL"
  if [ "$colored" -eq 1 ]; then printf '\033[0m\033[36m'; fi
  printf '%s\n' '└────────────────────────────────────────────────────────────────────────┘'
  if [ "$colored" -eq 1 ]; then printf '\033[0m'; fi
}
work_indicator() {
  symbol=$1
  if [ "$animated" -eq 1 ]; then printf '\r\033[K'; fi
  if [ "$colored" -eq 1 ]; then printf '\033[1;36m'; fi
  if [ "$language" = pt-BR ]; then printf '%s Trabalhando...' "$symbol"; else printf '%s Working...' "$symbol"; fi
  if [ "$colored" -eq 1 ]; then printf '\033[0m'; fi
  if [ "$animated" -eq 0 ]; then printf '\n'; fi
}
clear_work_indicator() {
  if [ "$work_indicator_drawn" -eq 1 ]; then
    printf '\r\033[K\n'
    work_indicator_drawn=0
  fi
}
framework_root=$ROOT

expand_home() {
  case "$1" in
    '~') printf '%s' "$HOME" ;;
    '~/'*) printf '%s/%s' "$HOME" "${1#\~/}" ;;
    *) printf '%s' "$1" ;;
  esac
}
normalize_path() {
  candidate=$(expand_home "$1")
  case "$candidate" in /*) ;; *) candidate="$PWD/$candidate" ;; esac
  while [ "$candidate" != / ] && [ "${candidate%/}" != "$candidate" ]; do candidate=${candidate%/}; done
  probe=$candidate
  suffix=
  while [ ! -d "$probe" ]; do
    leaf=$(basename "$probe")
    suffix="/$leaf$suffix"
    parent=$(dirname "$probe")
    if [ "$parent" = "$probe" ]; then return 1; fi
    probe=$parent
  done
  base=$(CDPATH= cd "$probe" && pwd -P)
  if [ "$base" = / ]; then printf '/%s' "${suffix#/}"; else printf '%s%s' "$base" "$suffix"; fi
}
path_is_within() { case "$1/" in "$2/"*) return 0 ;; *) return 1 ;; esac; }
paths_overlap() {
  if [ "$1" = / ] || [ "$2" = / ]; then return 0; fi
  [ "$1" = "$2" ] && return 0
  path_is_within "$1" "$2" && return 0
  path_is_within "$2" "$1" && return 0
  return 1
}


package_installed_path=
package_installed_platform=
package_installed_language=
framework_root=$ROOT
if [ "$local_bundle" -eq 1 ]; then
  step_project='2/4 · Project'; step_project_pt='2/4 · Projeto'
  step_integration='3/4 · Integration'; step_integration_pt='3/4 · Integração'
  step_review='4/4 · Review'; step_review_pt='4/4 · Revisão'
else
  step_project='1/3 · Project'; step_project_pt='1/3 · Projeto'
  step_integration='2/3 · Integration'; step_integration_pt='2/3 · Integração'
  step_review='3/3 · Review'; step_review_pt='3/3 · Revisão'
fi

prompt_framework_root() {
  section_divider
  heading '1/4 · Framework library' '1/4 · Biblioteca do Framework'
  while :; do
    answer "Framework installation directory (must not already exist; $back_hint_en):" "Diretório de instalação do Framework (ainda não pode existir; $back_hint_pt):"
    case "$reply" in b|B) select_language; continue ;; esac
    [ -n "$reply" ] || { say 'Enter a directory.' 'Informe um diretório.'; continue; }
    framework_root=$(normalize_path "$reply") || { say 'That path cannot be resolved.' 'Não foi possível resolver esse caminho.'; continue; }
    if [ -e "$framework_root" ] || [ -L "$framework_root" ]; then
      if [ "$framework_root" = "$package_installed_path" ] && [ "$selected_platform" = "$package_installed_platform" ] && [ "$language" = "$package_installed_language" ]; then
        ROOT=$framework_root
        selection 'Framework library' "$framework_root"
        return
      fi
      say 'That directory already exists; choose a new location.' 'Esse diretório já existe; escolha outro local.'
      continue
    fi
    selection 'Framework library' "$framework_root"
    return
  done
}

prompt_project() {
  section_divider
  heading "$step_project" "$step_project_pt"
  while :; do
    answer "Project directory (e.g. C:/Users/name/Projects/app or ./my-project; $back_hint_en):" "Diretório do projeto (ex.: C:/Users/nome/Projetos/app ou ./meu-projeto; $back_hint_pt):"
    case "$reply" in
      b|B) if [ "$local_bundle" -eq 1 ]; then prompt_framework_root; else select_language; fi; continue ;;
    esac
    [ -n "$reply" ] || { say 'Enter a directory.' 'Informe um diretório.'; continue; }
    target=$(normalize_path "$reply") || { say 'That path cannot be resolved.' 'Não foi possível resolver esse caminho.'; continue; }
    if paths_overlap "$target" "$framework_root"; then
      say 'The Framework library and project directories must not overlap.' 'A biblioteca do Framework e o projeto não podem se sobrepor.'
      continue
    fi
    selection 'Project' "$target"
    return
  done
}

prompt_integration() {
  section_divider
  heading "$step_integration" "$step_integration_pt"
  while :; do
    answer "Choose an integration:
  1) Codex
  2) Claude
  3) Gemini
  4) OpenCode
  $back_menu_en" "Escolha uma integração:
  1) Codex
  2) Claude
  3) Gemini
  4) OpenCode
  $back_menu_pt"
    case "$reply" in
      b|B) prompt_project; continue ;;
      1) adapter=codex; label_en=Codex; label_pt=Codex ;;
      2) adapter=claude; label_en=Claude; label_pt=Claude ;;
      3) adapter=gemini; label_en=Gemini; label_pt=Gemini ;;
      4) adapter=opencode; label_en=OpenCode; label_pt=OpenCode ;;
      *) say 'Choose 1–4, or press b. A selection is required.' 'Escolha de 1 a 4 ou pressione b. É obrigatório selecionar uma opção.'; continue ;;
    esac
    if [ "$language" = pt-BR ]; then selection 'Integração' "$label_pt"; else selection 'Integration' "$label_en"; fi
    return
  done
}

install_package() {
  [ "$local_bundle" -eq 1 ] || return 0
  if [ "$framework_root" = "$package_installed_path" ] && [ "$selected_platform" = "$package_installed_platform" ] && [ "$language" = "$package_installed_language" ]; then
    ROOT=$framework_root
    return 0
  fi
  say 'Latest release package details:' 'Detalhes do pacote da versão mais recente:'
  [ -z "$work_dir" ] || { rm -rf "$work_dir"; work_dir=; }
  work_dir=$(mktemp -d "${TMPDIR:-/tmp}/lf-framework.XXXXXX")
  checksum_url="$RELEASE_DOWNLOAD_URL/SHA256SUMS"
  if ! curl -fsSL "$checksum_url" -o "$work_dir/SHA256SUMS"; then
    say 'Could not read the latest release checksums. The release may not contain platform packages yet.' 'Não foi possível obter os checksums da versão mais recente. A release talvez ainda não inclua pacotes por plataforma.' >&2
    exit 1
  fi
  asset_match=$(awk -v platform="$selected_platform" -v language="$language" '{name=$2; sub(/^\*/, "", name); pattern="^lf-engineering-framework-v[0-9]+\\.[0-9]+\\.[0-9]+-" platform "-" language "\\.(tar\\.gz|zip)$"; if (name ~ pattern && $1 ~ /^[a-fA-F0-9]{64}$/) print $1 " " name}' "$work_dir/SHA256SUMS")
  match_count=$(printf '%s\n' "$asset_match" | awk 'NF { count++ } END { print count+0 }')
  if [ "$match_count" -ne 1 ]; then
    say 'The latest release does not contain exactly one package for this platform and language. No package was installed.' 'A versão mais recente não contém exatamente um pacote para este sistema e idioma. Nenhum pacote foi instalado.' >&2
    exit 1
  fi
  expected_hash=${asset_match%% *}
  asset=${asset_match#* }
  version=$(printf '%s\n' "$asset" | sed -n 's/^lf-engineering-framework-\(v[0-9][0-9.]*\)-.*/\1/p')
  if [ -z "$version" ]; then say 'The release package name is invalid.' 'O nome do pacote da release é inválido.' >&2; exit 1; fi
  say "Package: $asset" "Pacote: $asset"
  say "Framework version: $version" "Versão do Framework: $version"
  say "Install location: $framework_root" "Local de instalação: $framework_root"
  while :; do
    answer "Download and install this package? [y/N] ($back_hint_en)" "Baixar e instalar este pacote? [s/N] ($back_hint_pt)"
    case "$reply" in b|B) prompt_integration; continue ;; esac
    case "$language:$reply" in en-US:y|en-US:Y|pt-BR:s|pt-BR:S) break ;; *) say 'Cancelled. No package was downloaded.' 'Cancelado. Nenhum pacote foi baixado.'; exit 0 ;; esac
  done
  if [ "$language" = pt-BR ]; then selection 'Download' 'aprovado'; else selection 'Download' 'approved'; fi

  framework_parent=$(dirname "$framework_root")
  mkdir -p "$framework_parent"
  if [ -e "$framework_root" ] || [ -L "$framework_root" ]; then say 'The Framework destination now exists; refusing to overwrite it.' 'O destino do Framework passou a existir; não será sobrescrito.' >&2; exit 1; fi
  install_stage=$(mktemp -d "$framework_parent/.lf-framework-install.XXXXXX")
  package_path="$work_dir/$asset"
  if ! curl -fsSL "$RELEASE_DOWNLOAD_URL/$asset" -o "$package_path"; then
    say 'Package download failed. No project files were changed.' 'O download do pacote falhou. Nenhum arquivo do projeto foi alterado.' >&2
    exit 1
  fi
  if command -v sha256sum >/dev/null 2>&1; then actual_hash=$(sha256sum "$package_path" | awk '{print $1}')
  elif command -v shasum >/dev/null 2>&1; then actual_hash=$(shasum -a 256 "$package_path" | awk '{print $1}')
  else say 'Install sha256sum or shasum to verify the package.' 'Instale sha256sum ou shasum para verificar o pacote.' >&2; exit 1; fi
  if [ "$(printf '%s' "$actual_hash" | tr 'A-F' 'a-f')" != "$(printf '%s' "$expected_hash" | tr 'A-F' 'a-f')" ]; then
    say 'Package checksum mismatch. The archive was rejected.' 'O checksum do pacote não confere. O arquivo foi rejeitado.' >&2
    exit 1
  fi
  if [ "$selected_platform" = windows ]; then say 'A Windows package must be installed from PowerShell.' 'Um pacote Windows deve ser instalado pelo PowerShell.' >&2; exit 1; fi
  if ! tar -tzf "$package_path" > "$work_dir/archive-members" || ! tar -tvzf "$package_path" > "$work_dir/archive-details"; then
    say 'The package archive is invalid.' 'O arquivo do pacote é inválido.' >&2; exit 1
  fi
  while IFS= read -r member; do
    case "$member" in lf-engineering-framework/*) relative=${member#lf-engineering-framework/} ;; *) say 'The package contains a path outside its Framework folder.' 'O pacote contém um caminho fora da pasta do Framework.' >&2; exit 1 ;; esac
    case "/$relative/" in */../*|*/./*|*'\'*|//* ) say 'The package contains an unsafe path.' 'O pacote contém um caminho inseguro.' >&2; exit 1 ;; esac
  done < "$work_dir/archive-members"
  while IFS= read -r detail; do case "$detail" in -*) ;; *) say 'The package contains an unsupported filesystem entry.' 'O pacote contém um item de sistema de arquivos não suportado.' >&2; exit 1 ;; esac; done < "$work_dir/archive-details"
  if ! tar -xzf "$package_path" -C "$install_stage"; then say 'The package could not be extracted.' 'Não foi possível extrair o pacote.' >&2; exit 1; fi
  staged_root="$install_stage/lf-engineering-framework"
  manifest="$staged_root/framework-manifest.json"
  if [ ! -d "$staged_root" ] || [ ! -f "$manifest" ] || \
     ! grep -Fq "\"framework_version\": \"$version\"" "$manifest" || \
     ! grep -Fq "\"target_platform\": \"$selected_platform\"" "$manifest" || \
     ! grep -Fq "\"language\": \"$language\"" "$manifest" || \
     [ ! -f "$staged_root/scripts/bootstrap.sh" ] || [ ! -d "$staged_root/PROJECT_TEMPLATE" ]; then
    say 'Package manifest or required Framework files do not match the selection.' 'O manifesto ou os arquivos obrigatórios do pacote não correspondem à seleção.' >&2
    exit 1
  fi
  if [ -e "$framework_root" ] || [ -L "$framework_root" ]; then say 'The Framework destination now exists; refusing to overwrite it.' 'O destino do Framework passou a existir; não será sobrescrito.' >&2; exit 1; fi
  if ! mv "$staged_root" "$framework_root"; then say 'Could not move the verified package to the selected location.' 'Não foi possível mover o pacote verificado para o local escolhido.' >&2; exit 1; fi
  rmdir "$install_stage"; install_stage=
  ROOT=$framework_root
  package_installed_path=$framework_root
  package_installed_platform=$selected_platform
  package_installed_language=$language
  say 'Verified Framework package installed.' 'Pacote verificado do Framework instalado.'
}

show_output() {
  additions=$(awk '$1 == "ADD" { count++ } END { print count+0 }' "$log")
  preserved=$(awk '$1 == "PRESERVE" { count++ } END { print count+0 }' "$log")
  section_divider
  say "Summary: $additions files to add; $preserved existing files to preserve." "Resumo: $additions arquivos para adicionar; $preserved arquivos existentes para preservar."
  awk -F '\t' -v language="$language" -v width="$terminal_width" '
    function trim(value) { sub(/^[ \t]+/, "", value); sub(/[ \t]+$/, "", value); return value }
    function basename(path, parts, count) { count=split(path, parts, "/"); return parts[count] }
    function divider(count, i, line) { count=(width < 78 ? width-4 : 72); if (count < 1) count=1; line=""; for (i=0; i<count; i++) line=line "-"; print line }
    FILENAME == ARGV[1] { english[++translations]=$1; portuguese[translations]=trim($2); next }
    {
      line=$0
      if (!started) { divider(); started=1 }
      if (line ~ /^ADD / || line ~ /^PRESERVE /) {
        status=(line ~ /^ADD / ? "ADD" : "PRESERVE")
        path=substr(line, index(line, " ")+1)
        label=basename(path)
        if (language == "pt-BR") status=(status == "ADD" ? "ADICIONAR" : "PRESERVAR")
        max_label=(width < 78 ? width-length(status)-3 : 30)
        if (max_label < 4) max_label=4
        if (length(label) > max_label) label=substr(label, 1, max_label-3) "..."
        if (!table) {
          divider()
          if (permissions) {
            if (language == "pt-BR") print "Registro da instalação"; else print "Installation record"
          } else if (language == "pt-BR") print "Alterações previstas"; else print "Planned file changes"
          print ""
          if (width < 78) {
            if (language == "pt-BR") print "ESTADO / RÓTULO"; else print "STATE / LABEL"
          } else {
            if (language == "pt-BR") printf "%-12s %-30s %s\n", "ESTADO", "RÓTULO", "CAMINHO"
            else printf "%-12s %-30s %s\n", "STATE", "LABEL", "PATH"
          }
          table=1
        }
        if (width < 78) {
          if (language == "pt-BR") { printf "[%s] %s\n  Caminho: %s\n", status, label, path }
          else { printf "[%s] %s\n  Path: %s\n", status, label, path }
        } else printf "%-12s %-30s %s\n", status, label, path
        next
      }
      if (line ~ /^RESTRICT / || line ~ /^Secured \.ai\/state permissions/) {
        if (!permissions) {
          divider()
          if (language == "pt-BR") print "Permissões e estado da instalação"; else print "Permissions and installation state"
          permissions=1
          table=0
        }
      }
      if (language == "pt-BR") {
        for (i=1; i<=translations; i++) {
          key=english[i]; sub(/[ \t]+$/, "", key)
          if (index(line, key) == 1) {
            rest=substr(line, length(key)+1); sub(/^[ \t]+/, "", rest)
            label=portuguese[i]
            if (rest != "" && english[i] ~ /[ \t:]$/) line=label " " rest
            else line=label rest
            break
          }
        }
      }
      print line
    }
  ' "$ROOT/scripts/i18n/setup.tsv" "$log"
}
run_bootstrap() {
  log=$(mktemp "/tmp/lf-setup.XXXXXX")
  sh "$ROOT/scripts/bootstrap.sh" --framework-path "$ROOT" --target "$target" --language "$language" --adapter "$adapter" "$1" >"$log" 2>&1 &
  worker=$!
  if [ "$animated" -eq 1 ]; then
    work_indicator '·'
    work_indicator_drawn=1
    (frame=1; while :; do sleep 0.2; if [ "$frame" -eq 1 ]; then work_indicator '•'; else work_indicator '·'; fi; frame=$(( (frame % 2) + 1 )); done) &
    animator=$!
  else
    work_indicator '·'
  fi
  status=0
  wait "$worker" || status=$?
  worker=
  if [ -n "$animator" ]; then kill "$animator" 2>/dev/null || :; wait "$animator" 2>/dev/null || :; animator=; fi
  clear_work_indicator
  show_output
  rm -f "$log"; log=
  if [ "$status" -ne 0 ]; then
    say 'Setup failed. Review the diagnostic, correct the cause and run again. Existing files are preserved; an interrupted apply may leave newly added files.' 'A instalação falhou. Revise o diagnóstico, corrija a causa e execute novamente. Arquivos existentes são preservados; uma aplicação interrompida pode deixar arquivos novos.' >&2
    exit "$status"
  fi
}

review_and_apply() {
  while :; do
    section_divider
    heading "$step_review" "$step_review_pt"
    run_bootstrap --dry-run
    record="$target/.ai/framework-installation.md"
    if [ -f "$record" ]; then
      if ! grep -Fqx -- "- Language: $language" "$record" || ! grep -Fqx -- "- Adapter: $adapter" "$record"; then
        say 'Warning: the installation record differs. This adds missing files; it does not migrate language or integration. The previous record is preserved.' 'Atenção: o registro de instalação difere. Esta operação adiciona arquivos ausentes; não migra idioma ou integração. O registro anterior será preservado.'
      fi
    fi
    say 'Preserved project instructions and configuration may need manual reconciliation.' 'Instruções e configurações preservadas do projeto podem precisar de revisão manual.'
    answer "Apply these changes? [y/N] ($back_hint_en)" "Aplicar estas alterações? [s/N] ($back_hint_pt)"
    case "$reply" in
      b|B) prompt_integration; install_package; continue ;;
    esac
    case "$language:$reply" in
      en-US:y|en-US:Y|pt-BR:s|pt-BR:S)
        if [ "$language" = pt-BR ]; then selection 'Aplicação' 'aprovada'; else selection 'Apply' 'approved'; fi
        run_bootstrap --apply
        say 'Next: open the project, read LF_ENGINEERING.md and AGENTS.md, review preserved configuration, then use the local START_PROJECTS.md and FIRST_PROMPT_TEMPLATE.md guides.' 'Próximo passo: abra o projeto, leia LF_ENGINEERING.md e AGENTS.md, revise as configurações preservadas e use os guias locais START_PROJECTS.md e FIRST_PROMPT_TEMPLATE.md.'
        return
        ;;
      *) say 'Cancelled. No project files changed.' 'Cancelado. Nenhum arquivo do projeto foi alterado.'; return ;;
    esac
  done
}

select_platform
select_language
show_intro
printf '\n'
if [ "$local_bundle" -eq 1 ]; then prompt_framework_root; fi
prompt_project
prompt_integration
install_package
review_and_apply
