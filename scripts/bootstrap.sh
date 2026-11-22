#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [options]

Options:
  --framework-path PATH  LF Engineering System root (default: script parent)
  --target PATH          Client project directory (default: current directory)
  --language LANG        en-US or pt-BR (default: en-US)
  --adapter ADAPTER      required: codex, claude, gemini or opencode
  --dry-run              Report files without writing them (default)
  --apply                Copy missing files and selected adapter
  --help                 Show this help
EOF
}

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
FRAMEWORK_PATH=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)
FRAMEWORK_REPOSITORY='https://github.com/LeandroFernandess/LF-Engineering-Framework'
FRAMEWORK_REF=main
TARGET_PATH=.
LANGUAGE=en-US
ADAPTER=
APPLY=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --framework-path)
      [ "$#" -ge 2 ] || { echo "Missing value for --framework-path." >&2; exit 1; }
      FRAMEWORK_PATH=$2
      shift 2
      ;;
    --target)
      [ "$#" -ge 2 ] || { echo "Missing value for --target." >&2; exit 1; }
      TARGET_PATH=$2
      shift 2
      ;;
    --language)
      [ "$#" -ge 2 ] || { echo "Missing value for --language." >&2; exit 1; }
      LANGUAGE=$2
      shift 2
      ;;
    --adapter)
      [ "$#" -ge 2 ] || { echo "Missing value for --adapter." >&2; exit 1; }
      ADAPTER=$2
      shift 2
      ;;
    --dry-run)
      APPLY=0
      shift
      ;;
    --apply)
      APPLY=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

case "$LANGUAGE" in
  en-US|pt-BR) ;;
  *) echo "Language must be en-US or pt-BR." >&2; exit 1 ;;
esac

[ -n "$ADAPTER" ] || { echo "The --adapter option is required. Choose codex, claude, gemini or opencode." >&2; exit 1; }
case "$ADAPTER" in
  codex|claude|gemini|opencode) ;;
  *) echo "Adapter is not supported: $ADAPTER" >&2; exit 1 ;;
esac

FRAMEWORK_PATH=$(CDPATH= cd "$FRAMEWORK_PATH" && pwd -P)
FRAMEWORK_MANIFEST="$FRAMEWORK_PATH/framework-manifest.json"
if [ -f "$FRAMEWORK_MANIFEST" ]; then
  manifest_ref=$(sed -n 's/^  "framework_version": "\([^"]*\)",$/\1/p' "$FRAMEWORK_MANIFEST")
  if ! printf '%s\n' "$manifest_ref" | grep -Eq '^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'; then
    echo "Framework package manifest version is invalid." >&2
    exit 1
  fi
  FRAMEWORK_REF=$manifest_ref
fi

if [ -e "$TARGET_PATH" ] && [ ! -d "$TARGET_PATH" ]; then
  echo "The target path must be a directory: $TARGET_PATH" >&2
  exit 1
fi

# Resolve existing components physically before interpreting '..'. Missing
# components are normalized without creating anything, including in apply mode.
case "$TARGET_PATH" in /*) ;; *) TARGET_PATH="$PWD/$TARGET_PATH" ;; esac
remaining=$TARGET_PATH
resolved=/
while [ -n "$remaining" ]; do
  part=${remaining%%/*}
  case "$remaining" in */*) remaining=${remaining#*/} ;; *) remaining= ;; esac
  case "$part" in
    ''|.) continue ;;
    ..) resolved=$(dirname "$resolved"); continue ;;
  esac
  candidate="${resolved%/}/$part"
  if [ -d "$candidate" ]; then
    resolved=$(CDPATH= cd "$candidate" && pwd -P)
  elif [ -e "$candidate" ] || [ -L "$candidate" ]; then
    echo "The target path must be a directory: $candidate" >&2
    exit 1
  else
    resolved=$candidate
  fi
done
TARGET_PATH=$resolved

case "$TARGET_PATH/" in
  "$FRAMEWORK_PATH/"*)
    echo "The target project must be outside the Framework directory." >&2
    exit 1
    ;;
esac

assert_safe_target_parent() {
  destination_path=$1
  safe_parent_path=$(dirname "$destination_path")
  case "$TARGET_PATH" in
    /) target_path_prefix=/ ;;
    *) target_path_prefix="$TARGET_PATH/" ;;
  esac

  while [ "$safe_parent_path" != "$TARGET_PATH" ]; do
    case "$safe_parent_path/" in
      "$target_path_prefix"*) ;;
      *)
        echo "Destination escapes the target project directory: $destination_path" >&2
        exit 1
        ;;
    esac

    if [ -e "$safe_parent_path" ] && [ ! -d "$safe_parent_path" ]; then
      echo "The target path must be a directory: $safe_parent_path" >&2
      exit 1
    fi

    if [ -L "$safe_parent_path" ]; then
      echo "Refusing to write through a symlinked target directory: $safe_parent_path" >&2
      exit 1
    fi

    next_safe_parent=$(dirname "$safe_parent_path")
    if [ "$next_safe_parent" = "$safe_parent_path" ]; then
      echo "Destination is outside the target project directory: $destination_path" >&2
      exit 1
    fi
    safe_parent_path=$next_safe_parent
  done
}

TEMPLATE_PATH="$FRAMEWORK_PATH/PROJECT_TEMPLATE"
LOCALE_TEMPLATE_PATH="$FRAMEWORK_PATH/locales/$LANGUAGE/PROJECT_TEMPLATE"

if [ ! -d "$TEMPLATE_PATH" ]; then
  echo "PROJECT_TEMPLATE was not found under $FRAMEWORK_PATH." >&2
  exit 1
fi

if [ "$LANGUAGE" = pt-BR ] && [ ! -d "$LOCALE_TEMPLATE_PATH" ]; then
  echo "Localized template was not found: $LOCALE_TEMPLATE_PATH" >&2
  exit 1
fi

# Reuse the complete read-only walk to validate all destinations and adapter
# inputs before the first write. Apply still checks each destination again.
if [ "$APPLY" -eq 1 ]; then
  sh "$SCRIPT_DIR/bootstrap.sh" --framework-path "$FRAMEWORK_PATH" \
    --target "$TARGET_PATH" --language "$LANGUAGE" --adapter "$ADAPTER" --dry-run >/dev/null
  mkdir -p "$TARGET_PATH"
fi

copy_tree() {
  source_root=$1
  [ -d "$source_root" ] || return 0

  find "$source_root" -print | while IFS= read -r source_path; do
    [ "$source_path" = "$source_root" ] && continue
    relative_path=${source_path#"$source_root"/}
    case "$relative_path" in
      docs/DESIGN.md|docs/PERFORMANCE_VALIDATION_REPORT.md|docs/TECH_DEBT_AUDIT.md) continue ;;
    esac
    # Locale overlay owns these paths in both preview and apply.
    if [ "$source_root" = "$TEMPLATE_PATH" ] && [ -e "$LOCALE_TEMPLATE_PATH/$relative_path" ]; then
      continue
    fi
    destination="$TARGET_PATH/$relative_path"

    if [ -e "$destination" ] || [ -L "$destination" ]; then
      printf 'PRESERVE %s\n' "$relative_path"
      continue
    fi

    assert_safe_target_parent "$destination"
    if [ "$APPLY" -eq 0 ]; then
      printf 'ADD %s\n' "$relative_path"
    elif [ -d "$source_path" ]; then
      mkdir -p "$destination"
    else
      mkdir -p "$(dirname "$destination")"
      cp -p "$source_path" "$destination"
    fi
  done
}

copy_adapter_file() {
  source_path=$1
  relative_path=$2
  destination="$TARGET_PATH/$relative_path"

  if [ ! -f "$source_path" ]; then
    echo "Adapter file was not found: $source_path" >&2
    exit 1
  fi

  if [ -e "$destination" ] || [ -L "$destination" ]; then
    printf 'PRESERVE %s\n' "$relative_path"
  elif [ "$APPLY" -eq 0 ]; then
    assert_safe_target_parent "$destination"
    printf 'ADD %s\n' "$relative_path"
  else
    assert_safe_target_parent "$destination"
    mkdir -p "$(dirname "$destination")"
    cp -p "$source_path" "$destination"
  fi
}

framework_document_url() {
  printf '%s/blob/%s/%s' "$FRAMEWORK_REPOSITORY" "$FRAMEWORK_REF" "$1"
}

copy_project_file() {
  source_path=$1
  relative_path=$2
  destination="$TARGET_PATH/$relative_path"

  if [ ! -f "$source_path" ]; then
    echo "Project starter file was not found: $source_path" >&2
    exit 1
  fi
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    printf 'PRESERVE %s\n' "$relative_path"
  elif [ "$APPLY" -eq 0 ]; then
    assert_safe_target_parent "$destination"
    printf 'ADD %s\n' "$relative_path"
  else
    assert_safe_target_parent "$destination"
    mkdir -p "$(dirname "$destination")"
    cp -p "$source_path" "$destination"
  fi
}

copy_project_guide() {
  source_path=$1
  relative_path=$2
  destination="$TARGET_PATH/$relative_path"

  if [ ! -f "$source_path" ]; then
    echo "Project starter guide was not found: $source_path" >&2
    exit 1
  fi
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    printf 'PRESERVE %s\n' "$relative_path"
    return
  fi
  if [ "$APPLY" -eq 0 ]; then
    assert_safe_target_parent "$destination"
    printf 'ADD %s\n' "$relative_path"
    return
  fi

  assert_safe_target_parent "$destination"
  mkdir -p "$(dirname "$destination")"
  if [ "$LANGUAGE" = pt-BR ]; then
    get_started_url=$(framework_document_url "locales/pt-BR/public-docs/GET_STARTED.md")
    other_start_guide_url=$(framework_document_url "START_PROJECTS.en-US.md")
    other_prompt_url=$(framework_document_url "FIRST_PROMPT_TEMPLATE.md")
  else
    get_started_url=$(framework_document_url "GET_STARTED.md")
    other_start_guide_url=$(framework_document_url "locales/pt-BR/public-docs/START_PROJECTS.md")
    other_prompt_url=$(framework_document_url "locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md")
  fi
  sed \
    -e "s|](GET_STARTED.md)|]($get_started_url)|g" \
    -e "s|locales/pt-BR/public-docs/START_PROJECTS.md)|$other_start_guide_url)|g" \
    -e "s|../../../START_PROJECTS.en-US.md)|$other_start_guide_url)|g" \
    -e "s|locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md)|$other_prompt_url)|g" \
    -e "s|../../../FIRST_PROMPT_TEMPLATE.md)|$other_prompt_url)|g" \
    "$source_path" > "$destination"
}

install_project_guides() {
  if [ "$LANGUAGE" = pt-BR ]; then
    guide_source="$FRAMEWORK_PATH/locales/pt-BR/public-docs/START_PROJECTS.md"
    prompt_source="$FRAMEWORK_PATH/locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md"
  else
    guide_source="$FRAMEWORK_PATH/START_PROJECTS.en-US.md"
    prompt_source="$FRAMEWORK_PATH/FIRST_PROMPT_TEMPLATE.md"
  fi
  copy_project_guide "$guide_source" START_PROJECTS.md
  copy_project_guide "$prompt_source" FIRST_PROMPT_TEMPLATE.md
}

install_project_skills() {
  case "$LANGUAGE" in
    pt-BR) source_root="$FRAMEWORK_PATH/locales/pt-BR/project-skills" ;;
    *) source_root="$FRAMEWORK_PATH/project-skills/en-US" ;;
  esac
  case "$ADAPTER" in
    claude) destination_root=.claude/skills ;;
    *) destination_root=.agents/skills ;;
  esac
  for skill in lf-project-onboarding lf-project-planning lf-approved-implementation lf-delivery-review; do
    copy_project_file "$source_root/$skill/SKILL.md" "$destination_root/$skill/SKILL.md"
  done
}

secure_local_state() {
  state_directory="$TARGET_PATH/.ai/state"
  if [ ! -d "$TEMPLATE_PATH/.ai/state" ] && \
    [ ! -d "$LOCALE_TEMPLATE_PATH/.ai/state" ] && \
    [ ! -d "$state_directory" ]; then
    return 0
  fi

  assert_safe_target_parent "$state_directory/.owner-only-permissions"
  if [ "$APPLY" -eq 0 ]; then
    printf 'RESTRICT .ai/state to owner-only permissions (0700 directories, 0600 files)\n'
    return 0
  fi

  [ -d "$state_directory" ] || {
    echo "Local state directory was not created: $state_directory" >&2
    exit 1
  }

  chmod 700 "$state_directory"
  find "$state_directory" -type d -exec chmod 700 {} \;
  find "$state_directory" -type f -exec chmod 600 {} \;
  printf 'Secured .ai/state permissions (0700 directories, 0600 files).\n'
}

installation_file="$TARGET_PATH/.ai/framework-installation.md"

echo "LF Engineering System bootstrap"
echo "Language: $LANGUAGE"
echo "Adapter: $ADAPTER"
echo "Target: $TARGET_PATH"

# The localized overlay is copied first so it wins over the neutral template.
copy_tree "$LOCALE_TEMPLATE_PATH"
copy_tree "$TEMPLATE_PATH"

case "$ADAPTER" in
  claude)
    if [ -f "$FRAMEWORK_PATH/adapters/claude/$LANGUAGE/CLAUDE.md" ]; then
      copy_adapter_file "$FRAMEWORK_PATH/adapters/claude/$LANGUAGE/CLAUDE.md" "CLAUDE.md"
    else
      copy_adapter_file "$FRAMEWORK_PATH/adapters/claude/CLAUDE.md" "CLAUDE.md"
    fi
    ;;
  gemini)
    if [ -f "$FRAMEWORK_PATH/adapters/gemini/$LANGUAGE/GEMINI.md" ]; then
      copy_adapter_file "$FRAMEWORK_PATH/adapters/gemini/$LANGUAGE/GEMINI.md" "GEMINI.md"
    else
      copy_adapter_file "$FRAMEWORK_PATH/adapters/gemini/GEMINI.md" "GEMINI.md"
    fi
    ;;
  opencode)
    source_path="$FRAMEWORK_PATH/adapters/opencode/opencode.jsonc"
    destination="$TARGET_PATH/opencode.jsonc"
    if [ ! -f "$source_path" ]; then
      echo "OpenCode adapter configuration was not found: $source_path" >&2
      exit 1
    fi
    if [ ! -e "$destination" ] && ! grep -Fq '__LF_ENGINEERING_SYSTEM_REF__' "$source_path"; then
      echo "Framework reference placeholder was not found in the OpenCode adapter." >&2
      exit 1
    fi
    if [ -e "$destination" ] || [ -L "$destination" ]; then
      printf 'PRESERVE opencode.jsonc\n'
    elif [ "$APPLY" -eq 0 ]; then
      assert_safe_target_parent "$destination"
      printf 'ADD opencode.jsonc\n'
    else
      assert_safe_target_parent "$destination"
      temporary_config=$(mktemp "${TMPDIR:-/tmp}/lf-opencode.jsonc.XXXXXX")
      sed "s|__LF_ENGINEERING_SYSTEM_REF__|$FRAMEWORK_REF|g" \
        "$source_path" > "$temporary_config"
      if grep -Fq "__LF_ENGINEERING_SYSTEM_REF__" "$temporary_config"; then
        rm -f "$temporary_config"
        echo "Framework reference placeholder was not fully replaced." >&2
        exit 1
      fi
      mv "$temporary_config" "$destination"
      echo "Generated opencode.jsonc."
    fi
    ;;
esac

install_project_guides
install_project_skills

secure_local_state

if [ -e "$installation_file" ] || [ -L "$installation_file" ]; then
  printf 'PRESERVE .ai/framework-installation.md\n'
elif [ "$APPLY" -eq 0 ]; then
  assert_safe_target_parent "$installation_file"
  printf 'ADD .ai/framework-installation.md\n'
else
  assert_safe_target_parent "$installation_file"
  mkdir -p "$(dirname "$installation_file")"
  installation_title='LF Engineering System Installation'
  installation_description='This file records how the project base was initialized. Existing project files were preserved by the bootstrap.'
  if [ "$LANGUAGE" = pt-BR ]; then
    installation_title='Instalação do LF Engineering System'
    installation_description='Este arquivo registra como a base do projeto foi inicializada. Os arquivos existentes foram preservados pelo bootstrap.'
  fi
  cat > "$installation_file" <<EOF
# $installation_title

- Language: $LANGUAGE
- Adapter: $ADAPTER
- Framework source: $FRAMEWORK_REPOSITORY/tree/$FRAMEWORK_REF
- Framework: external read-only library

$installation_description
EOF
fi

if [ "$APPLY" -eq 1 ]; then
  echo "Bootstrap applied without overwriting existing files."
else
  echo "Dry run only. Re-run with --apply to write missing files."
fi
