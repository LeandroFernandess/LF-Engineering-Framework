#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [options]

Options:
  --framework-path PATH  LF Engineering System root (default: script parent)
  --target PATH          Client project directory (default: current directory)
  --language LANG        en-US or pt-BR (default: en-US)
  --adapter ADAPTER      generic, codex, claude, gemini or opencode
  --dry-run              Report files without writing them (default)
  --apply                Copy missing files and selected adapter
  --help                 Show this help
EOF
}

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
FRAMEWORK_PATH=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)
TARGET_PATH=.
LANGUAGE=en-US
ADAPTER=generic
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

case "$ADAPTER" in
  generic|codex|claude|gemini|opencode) ;;
  *) echo "Adapter is not supported: $ADAPTER" >&2; exit 1 ;;
esac

FRAMEWORK_PATH=$(CDPATH= cd "$FRAMEWORK_PATH" && pwd -P)

if [ -e "$TARGET_PATH" ] && [ ! -d "$TARGET_PATH" ]; then
  echo "The target path must be a directory: $TARGET_PATH" >&2
  exit 1
fi

if [ -d "$TARGET_PATH" ]; then
  TARGET_PATH=$(CDPATH= cd "$TARGET_PATH" && pwd -P)
elif [ "$APPLY" -eq 1 ]; then
  mkdir -p "$TARGET_PATH"
  TARGET_PATH=$(CDPATH= cd "$TARGET_PATH" && pwd -P)
else
  target_parent=$(dirname "$TARGET_PATH")
  target_name=$(basename "$TARGET_PATH")
  while [ ! -d "$target_parent" ]; do
    target_name="$(basename "$target_parent")/$target_name"
    target_parent=$(dirname "$target_parent")
  done
  target_parent=$(CDPATH= cd "$target_parent" && pwd -P)
  TARGET_PATH="$target_parent/$target_name"
fi

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

copy_tree() {
  source_root=$1
  [ -d "$source_root" ] || return 0

  find "$source_root" -print | while IFS= read -r source_path; do
    [ "$source_path" = "$source_root" ] && continue
    relative_path=${source_path#"$source_root"/}
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
      if [ "$relative_path" = "LF_ENGINEERING.md" ]; then
        escaped_framework_path=$(printf '%s' "$FRAMEWORK_PATH" | sed 's/[\\&|]/\\&/g')
        sed "s|__LF_ENGINEERING_SYSTEM_PATH__|$escaped_framework_path|g" \
          "$source_path" > "$destination"
      else
        cp -p "$source_path" "$destination"
      fi
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
    if [ -e "$destination" ] || [ -L "$destination" ]; then
      printf 'PRESERVE opencode.jsonc\n'
    elif [ "$APPLY" -eq 0 ]; then
      assert_safe_target_parent "$destination"
      printf 'ADD opencode.jsonc\n'
    else
      assert_safe_target_parent "$destination"
      escaped_framework_path=$(printf '%s' "$FRAMEWORK_PATH" | sed 's/[\\&|]/\\&/g')
      temporary_config=$(mktemp "${TMPDIR:-/tmp}/lf-opencode.jsonc.XXXXXX")
      sed "s|__LF_ENGINEERING_SYSTEM_PATH__|$escaped_framework_path|g" \
        "$source_path" > "$temporary_config"
      if grep -Fq "__LF_ENGINEERING_SYSTEM_PATH__" "$temporary_config"; then
        rm -f "$temporary_config"
        echo "Framework placeholder was not fully replaced." >&2
        exit 1
      fi
      mv "$temporary_config" "$destination"
      echo "Generated opencode.jsonc."
    fi
    ;;
esac

secure_local_state

if [ -e "$installation_file" ] || [ -L "$installation_file" ]; then
  printf 'PRESERVE .ai/framework-installation.md\n'
elif [ "$APPLY" -eq 0 ]; then
  assert_safe_target_parent "$installation_file"
  printf 'ADD .ai/framework-installation.md\n'
else
  assert_safe_target_parent "$installation_file"
  mkdir -p "$(dirname "$installation_file")"
  cat > "$installation_file" <<EOF
# LF Engineering System Installation

- Language: $LANGUAGE
- Adapter: $ADAPTER
- Framework path: $FRAMEWORK_PATH
- Framework: external read-only library

This file records how the project base was initialized. Existing project files
were preserved by the bootstrap.
EOF
fi

if [ "$APPLY" -eq 1 ]; then
  echo "Bootstrap applied without overwriting existing files."
else
  echo "Dry run only. Re-run with --apply to write missing files."
fi
