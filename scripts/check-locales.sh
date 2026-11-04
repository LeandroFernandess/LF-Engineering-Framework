#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
FRAMEWORK_PATH=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)
SOURCE_TEMPLATE="$FRAMEWORK_PATH/PROJECT_TEMPLATE"
PT_TEMPLATE="$FRAMEWORK_PATH/locales/pt-BR/PROJECT_TEMPLATE"
STATUS_FILE="$FRAMEWORK_PATH/locales/pt-BR/TRANSLATION_STATUS.md"
TEMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/lf-locale-check.XXXXXX")

cleanup() {
  rm -rf "$TEMP_ROOT"
}
trap cleanup EXIT HUP INT TERM

source_files="$TEMP_ROOT/source.txt"
pt_files="$TEMP_ROOT/pt.txt"

find "$SOURCE_TEMPLATE" -type f ! -name .gitignore -print |
  sed "s#^$SOURCE_TEMPLATE/##" | sort > "$source_files"
find "$PT_TEMPLATE" -type f -print |
  sed "s#^$PT_TEMPLATE/##" | sort > "$pt_files"

if ! diff -u "$source_files" "$pt_files"; then
  echo "PT-BR template file parity check failed." >&2
  exit 1
fi

while IFS= read -r relative_path; do
  source_path="$SOURCE_TEMPLATE/$relative_path"
  pt_path="$PT_TEMPLATE/$relative_path"

  source_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$source_path" || true)
  source_heading_levels=$(printf '%s\n' "$source_heading_levels" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
  pt_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$pt_path" || true)
  pt_heading_levels=$(printf '%s\n' "$pt_heading_levels" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
  if [ "$source_heading_levels" != "$pt_heading_levels" ]; then
    echo "PT-BR heading structure parity check failed: $relative_path." >&2
    exit 1
  fi

  source_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$source_path" || true)
  pt_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$pt_path" || true)
  if [ "$source_table_separators" != "$pt_table_separators" ]; then
    echo "PT-BR table structure parity check failed: $relative_path." >&2
    exit 1
  fi

  source_code_fences=$(grep -E -c '^```' "$source_path" || true)
  pt_code_fences=$(grep -E -c '^```' "$pt_path" || true)
  if [ "$source_code_fences" != "$pt_code_fences" ]; then
    echo "PT-BR code block parity check failed: $relative_path." >&2
    exit 1
  fi

  source_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$source_path")
  pt_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$pt_path")
  if [ "$source_comments" != "$pt_comments" ]; then
    echo "PT-BR comment parity check failed: $relative_path." >&2
    exit 1
  fi
done < "$source_files"

for canonical_root in agents workflows protocols schemas knowledge; do
  source_root="$FRAMEWORK_PATH/$canonical_root"
  pt_root="$FRAMEWORK_PATH/locales/pt-BR/$canonical_root"
  canonical_source_files="$TEMP_ROOT/$canonical_root-source.txt"
  canonical_pt_files="$TEMP_ROOT/$canonical_root-pt.txt"

  if [ "$canonical_root" = "knowledge" ]; then
    find "$source_root" -type f \
      ! -name ENGINEERING_ELEPHANT_GOLDFISH.md \
      ! -name ENGINEERING_AGENT_GRAPH_FLOW.md \
      ! -name ENGINEERING_RTK.md \
      ! -name ENGINEERING_GRAPHIFY.md -print |
      sed "s#^$source_root/##" | sort > "$canonical_source_files"
    find "$pt_root" -type f \
      ! -name ENGINEERING_ELEPHANT_GOLDFISH.md \
      ! -name ENGINEERING_AGENT_GRAPH_FLOW.md \
      ! -name ENGINEERING_RTK.md \
      ! -name ENGINEERING_GRAPHIFY.md -print |
      sed "s#^$pt_root/##" | sort > "$canonical_pt_files"
  else
    find "$source_root" -type f -print |
      sed "s#^$source_root/##" | sort > "$canonical_source_files"
    find "$pt_root" -type f -print |
      sed "s#^$pt_root/##" | sort > "$canonical_pt_files"
  fi

  if ! diff -u "$canonical_source_files" "$canonical_pt_files"; then
    echo "PT-BR $canonical_root file parity check failed." >&2
    exit 1
  fi

  while IFS= read -r relative_path; do
    source_path="$source_root/$relative_path"
    pt_path="$pt_root/$relative_path"

    source_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$source_path" || true)
    source_heading_levels=$(printf '%s\n' "$source_heading_levels" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
    pt_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$pt_path" || true)
    pt_heading_levels=$(printf '%s\n' "$pt_heading_levels" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
    if [ "$source_heading_levels" != "$pt_heading_levels" ]; then
      echo "PT-BR $canonical_root heading structure parity check failed: $relative_path." >&2
      exit 1
    fi

    source_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$source_path" || true)
    pt_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$pt_path" || true)
    if [ "$source_table_separators" != "$pt_table_separators" ]; then
      echo "PT-BR $canonical_root table structure parity check failed: $relative_path." >&2
      exit 1
    fi

    source_code_fences=$(grep -E -c '^```' "$source_path" || true)
    pt_code_fences=$(grep -E -c '^```' "$pt_path" || true)
    if [ "$source_code_fences" != "$pt_code_fences" ]; then
      echo "PT-BR $canonical_root code block parity check failed: $relative_path." >&2
      exit 1
    fi

    source_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$source_path")
    pt_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$pt_path")
    if [ "$source_comments" != "$pt_comments" ]; then
      echo "PT-BR $canonical_root comment parity check failed: $relative_path." >&2
      exit 1
    fi
  done < "$canonical_source_files"
done

for relative_path in \
  "OVERVIEW.md|locales/pt-BR/public-docs/OVERVIEW.md" \
  "ROADMAP.md|locales/pt-BR/public-docs/ROADMAP.md" \
  "CHANGELOG.md|locales/pt-BR/public-docs/CHANGELOG.md" \
  "docs/security-audit/README.md|locales/pt-BR/public-docs/SECURITY_AUDIT.md" \
  "docs/ADR.md|locales/pt-BR/docs/ADR.md"; do
  source_relative=${relative_path%%|*}
  pt_relative=${relative_path#*|}
  source_path="$FRAMEWORK_PATH/$source_relative"
  pt_path="$FRAMEWORK_PATH/$pt_relative"
  [ -f "$source_path" ] || { echo "Missing public source document: $source_relative" >&2; exit 1; }
  [ -f "$pt_path" ] || { echo "Missing PT-BR public document mirror: $pt_relative" >&2; exit 1; }

  source_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$source_path" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
  pt_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$pt_path" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
  [ "$source_heading_levels" = "$pt_heading_levels" ] || { echo "PT-BR public document heading parity failed: $pt_relative" >&2; exit 1; }

  source_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$source_path" || true)
  pt_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$pt_path" || true)
  [ "$source_table_separators" = "$pt_table_separators" ] || { echo "PT-BR public document table parity failed: $pt_relative" >&2; exit 1; }

  source_code_fences=$(grep -E -c '^```' "$source_path" || true)
  pt_code_fences=$(grep -E -c '^```' "$pt_path" || true)
  [ "$source_code_fences" = "$pt_code_fences" ] || { echo "PT-BR public document code block parity failed: $pt_relative" >&2; exit 1; }

  source_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$source_path")
  pt_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$pt_path")
  [ "$source_comments" = "$pt_comments" ] || { echo "PT-BR public document comment parity failed: $pt_relative" >&2; exit 1; }
done

for module_name in \
  ENGINEERING_ELEPHANT_GOLDFISH \
  ENGINEERING_AGENT_GRAPH_FLOW \
  ENGINEERING_RTK \
  ENGINEERING_GRAPHIFY; do
  source_relative="knowledge/$module_name.md"
  pt_relative="locales/pt-BR/knowledge/$module_name.md"
  source_path="$FRAMEWORK_PATH/$source_relative"
  pt_path="$FRAMEWORK_PATH/$pt_relative"
  [ -f "$source_path" ] || { echo "Missing approved optional source module: $source_relative" >&2; exit 1; }
  [ -f "$pt_path" ] || { echo "Missing PT-BR mirror for approved optional module: $pt_relative" >&2; exit 1; }
  source_version=$(sed -n 's/^Version: //p' "$source_path" | sed -n '1p')
  pt_version=$(sed -n 's/^Versão: //p' "$pt_path" | sed -n '1p')
  [ -n "$source_version" ] && [ "$source_version" = "$pt_version" ] || { echo "Approved optional PT-BR version mismatch: $pt_relative" >&2; exit 1; }
  grep -Fq 'Status: Approved Optional' "$source_path" || { echo "Source module must retain approved optional status: $source_relative" >&2; exit 1; }
  grep -Fq 'Status: Opcional aprovado' "$pt_path" || { echo "PT-BR mirror must retain approved optional status: $pt_relative" >&2; exit 1; }

  source_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$source_path" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
  pt_heading_levels=$(grep -E '^#{1,6}[[:space:]]' "$pt_path" | sed -E 's/^([#]+).*/\1/' | awk '{ printf "%s ", length($0) }')
  [ "$source_heading_levels" = "$pt_heading_levels" ] || { echo "Approved optional PT-BR heading parity failed: $pt_relative" >&2; exit 1; }

  source_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$source_path" || true)
  pt_table_separators=$(grep -E -c '^\|[[:space:]:|0-9-]+\|[[:space:]]*$' "$pt_path" || true)
  [ "$source_table_separators" = "$pt_table_separators" ] || { echo "Approved optional PT-BR table parity failed: $pt_relative" >&2; exit 1; }

  source_code_fences=$(grep -E -c '^```' "$source_path" || true)
  pt_code_fences=$(grep -E -c '^```' "$pt_path" || true)
  [ "$source_code_fences" = "$pt_code_fences" ] || { echo "Approved optional PT-BR code block parity failed: $pt_relative" >&2; exit 1; }

  source_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$source_path")
  pt_comments=$(awk '{ openings += gsub(/<!--/, ""); closings += gsub(/-->/, "") } END { printf "%d %d", openings, closings }' "$pt_path")
  [ "$source_comments" = "$pt_comments" ] || { echo "Approved optional PT-BR comment parity failed: $pt_relative" >&2; exit 1; }
done

if ! grep -Fq '**Versão da fonte:** 1.5.0' "$STATUS_FILE"; then
  echo "PT-BR translation source version is missing or stale." >&2
  exit 1
fi

pt_placeholder_files=$(grep -R -l -F '__LF_ENGINEERING_SYSTEM_PATH__' "$PT_TEMPLATE" | sort || true)
if [ "$pt_placeholder_files" != "$PT_TEMPLATE/LF_ENGINEERING.md" ]; then
  echo "PT-BR template contains an unexpected operational placeholder." >&2
  exit 1
fi

printf 'PT-BR locale structure and template file parity: passed\n'
