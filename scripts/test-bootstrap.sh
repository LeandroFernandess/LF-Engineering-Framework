#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
FRAMEWORK_PATH=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/lf-bootstrap-test.XXXXXX")

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT HUP INT TERM

stat_mode() {
  if mode=$(stat -c '%a' "$1" 2>/dev/null); then
    printf '%s' "$mode"
  else
    stat -f '%Lp' "$1"
  fi
}

assert_mode() {
  expected_mode=$1
  path=$2
  actual_mode=$(stat_mode "$path")
  [ "$actual_mode" = "$expected_mode" ] || [ "$actual_mode" = "0$expected_mode" ] || {
    echo "Expected mode $expected_mode for $path, got $actual_mode." >&2
    exit 1
  }
}

new_project="$TEST_ROOT/new project"
sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$new_project" \
  --language pt-BR \
  --adapter generic \
  --dry-run > "$TEST_ROOT/new-dry-run.txt"

[ ! -e "$new_project" ]
grep -F 'ADD AGENTS.md' "$TEST_ROOT/new-dry-run.txt" >/dev/null

sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$new_project" \
  --language pt-BR \
  --adapter generic \
  --apply > "$TEST_ROOT/new-apply.txt"

[ -f "$new_project/.ai/contracts.md" ]
[ -f "$new_project/docs/DESIGN.md" ]
[ -f "$new_project/LF_ENGINEERING.md" ]
grep -F 'Instruções dos agentes' "$new_project/AGENTS.md" >/dev/null
grep -F "$FRAMEWORK_PATH" "$new_project/LF_ENGINEERING.md" >/dev/null
[ ! -e "$new_project/opencode.jsonc" ]
[ -f "$new_project/.ai/state/current-phase.md" ]
[ -f "$new_project/.gitignore" ]
grep -F '/.ai/state/' "$new_project/.gitignore" >/dev/null
assert_mode 700 "$new_project/.ai/state"
assert_mode 600 "$new_project/.ai/state/current-phase.md"
grep -F -- '- Language: pt-BR' "$new_project/.ai/framework-installation.md" >/dev/null
grep -F -- '- Adapter: generic' "$new_project/.ai/framework-installation.md" >/dev/null

existing_project="$TEST_ROOT/existing project"
mkdir -p "$existing_project/docs" "$existing_project/.ai/state"
mkdir -p "$existing_project/.ai/state/archive/subdir"
printf 'project-owned README\n' > "$existing_project/README.md"
printf 'project-owned AGENTS\n' > "$existing_project/AGENTS.md"
printf 'project-owned ignore\n' > "$existing_project/.gitignore"
printf 'project-owned config\n' > "$existing_project/opencode.jsonc"
printf 'project-owned marker\n' > "$existing_project/.ai/framework-installation.md"
printf 'project-owned phase\n' > "$existing_project/.ai/state/current-phase.md"
printf 'project-owned nested state\n' > "$existing_project/.ai/state/archive/subdir/old.md"
printf 'project-owned PRD\n' > "$existing_project/docs/PRD.md"
chmod 755 "$existing_project/.ai/state"
chmod 755 "$existing_project/.ai/state/archive" "$existing_project/.ai/state/archive/subdir"
chmod 644 "$existing_project/.ai/state/current-phase.md"
chmod 644 "$existing_project/.ai/state/archive/subdir/old.md"

sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$existing_project" \
  --language en-US \
  --adapter opencode \
  --dry-run > "$TEST_ROOT/existing-dry-run.txt"

grep -F 'PRESERVE README.md' "$TEST_ROOT/existing-dry-run.txt" >/dev/null
grep -F 'PRESERVE AGENTS.md' "$TEST_ROOT/existing-dry-run.txt" >/dev/null
grep -F 'PRESERVE .gitignore' "$TEST_ROOT/existing-dry-run.txt" >/dev/null
grep -F 'PRESERVE opencode.jsonc' "$TEST_ROOT/existing-dry-run.txt" >/dev/null
grep -F 'PRESERVE docs/PRD.md' "$TEST_ROOT/existing-dry-run.txt" >/dev/null
grep -F 'PRESERVE .ai/state/current-phase.md' "$TEST_ROOT/existing-dry-run.txt" >/dev/null
grep -F 'RESTRICT .ai/state to owner-only permissions' "$TEST_ROOT/existing-dry-run.txt" >/dev/null
assert_mode 755 "$existing_project/.ai/state"
assert_mode 755 "$existing_project/.ai/state/archive"
assert_mode 755 "$existing_project/.ai/state/archive/subdir"
assert_mode 644 "$existing_project/.ai/state/current-phase.md"
assert_mode 644 "$existing_project/.ai/state/archive/subdir/old.md"
[ ! -f "$existing_project/.ai/contracts.md" ]

sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$existing_project" \
  --language en-US \
  --adapter opencode \
  --apply > "$TEST_ROOT/existing-apply.txt"

[ "$(cat "$existing_project/README.md")" = 'project-owned README' ]
[ "$(cat "$existing_project/AGENTS.md")" = 'project-owned AGENTS' ]
[ "$(cat "$existing_project/.gitignore")" = 'project-owned ignore' ]
[ "$(cat "$existing_project/opencode.jsonc")" = 'project-owned config' ]
[ "$(cat "$existing_project/.ai/framework-installation.md")" = 'project-owned marker' ]
[ "$(cat "$existing_project/.ai/state/current-phase.md")" = 'project-owned phase' ]
[ "$(cat "$existing_project/.ai/state/archive/subdir/old.md")" = 'project-owned nested state' ]
[ "$(cat "$existing_project/docs/PRD.md")" = 'project-owned PRD' ]
[ -f "$existing_project/.ai/contracts.md" ]
assert_mode 700 "$existing_project/.ai/state"
assert_mode 700 "$existing_project/.ai/state/archive"
assert_mode 700 "$existing_project/.ai/state/archive/subdir"
assert_mode 600 "$existing_project/.ai/state/current-phase.md"
assert_mode 600 "$existing_project/.ai/state/archive/subdir/old.md"

opencode_project="$TEST_ROOT/opencode project"
sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$opencode_project" \
  --language en-US \
  --adapter opencode \
  --apply > "$TEST_ROOT/opencode-apply.txt"

[ -f "$opencode_project/opencode.jsonc" ]
if grep -Fq '__LF_ENGINEERING_SYSTEM_PATH__' "$opencode_project/opencode.jsonc"; then
  echo "OpenCode placeholder was not replaced." >&2
  exit 1
fi
if command -v node >/dev/null 2>&1; then
  node -e 'const fs=require("fs"); JSON.parse(fs.readFileSync(process.argv[1], "utf8"));' \
    "$opencode_project/opencode.jsonc"
fi
if command -v opencode >/dev/null 2>&1; then
  (cd "$opencode_project" && opencode debug config) > "$TEST_ROOT/opencode-debug-config.txt"
  normalized_opencode_project=$(CDPATH= cd "$opencode_project" && pwd -P)
  grep -F "$normalized_opencode_project/opencode.jsonc" "$TEST_ROOT/opencode-debug-config.txt" >/dev/null
  grep -F "$FRAMEWORK_PATH" "$TEST_ROOT/opencode-debug-config.txt" >/dev/null
fi

for adapter in codex claude gemini; do
  adapter_project="$TEST_ROOT/adapter-$adapter"
  sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
    --framework-path "$FRAMEWORK_PATH" \
    --target "$adapter_project" \
    --language en-US \
    --adapter "$adapter" \
    --apply > /dev/null
  [ -f "$adapter_project/AGENTS.md" ]
  case "$adapter" in
    codex) [ ! -e "$adapter_project/CLAUDE.md" ]; [ ! -e "$adapter_project/GEMINI.md" ] ;;
    claude) [ -f "$adapter_project/CLAUDE.md" ]; [ ! -e "$adapter_project/GEMINI.md" ] ;;
    gemini) [ -f "$adapter_project/GEMINI.md" ]; [ ! -e "$adapter_project/CLAUDE.md" ] ;;
  esac
done

if sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TEST_ROOT/invalid-language" \
  --language xx-XX \
  --dry-run >/dev/null 2>&1; then
  echo "Invalid language was accepted." >&2
  exit 1
fi

if sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TEST_ROOT/invalid-adapter" \
  --adapter unknown \
  --dry-run >/dev/null 2>&1; then
  echo "Invalid adapter was accepted." >&2
  exit 1
fi

if sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$FRAMEWORK_PATH/inside" \
  --dry-run >/dev/null 2>&1; then
  echo "Framework boundary protection failed." >&2
  exit 1
fi

linked_framework="$TEST_ROOT/framework-link"
ln -s "$FRAMEWORK_PATH" "$linked_framework"
if sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$linked_framework/inside" \
  --dry-run >/dev/null 2>&1; then
  echo "Framework boundary protection failed through a directory link." >&2
  exit 1
fi

if sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$linked_framework" \
  --target "$FRAMEWORK_PATH/inside-alias" \
  --dry-run >/dev/null 2>&1; then
  echo "Framework boundary protection failed with a linked Framework path." >&2
  exit 1
fi

symlink_project="$TEST_ROOT/symlink-project"
outside_project="$TEST_ROOT/outside-project"
mkdir -p "$symlink_project" "$outside_project"
ln -s "$outside_project" "$symlink_project/docs"
if sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$symlink_project" \
  --apply > "$TEST_ROOT/symlink-apply.txt" 2>&1; then
  echo "Bootstrap followed a symlinked target directory." >&2
  exit 1
fi
if [ -n "$(find "$outside_project" -type f -print -quit)" ]; then
  echo "Bootstrap wrote template files outside the target project." >&2
  exit 1
fi

echo "Bootstrap tests passed."
