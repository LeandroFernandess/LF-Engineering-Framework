#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
FRAMEWORK_PATH=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)

fail() {
  echo "Validation failed: $*" >&2
  exit 1
}

require_file() {
  [ -f "$FRAMEWORK_PATH/$1" ] || fail "missing file: $1"
}

require_directory() {
  [ -d "$FRAMEWORK_PATH/$1" ] || fail "missing directory: $1"
}

for directory in agents knowledge workflows protocols schemas PROJECT_TEMPLATE adapters locales scripts docs .github; do
  require_directory "$directory"
done

[ ! -e "$FRAMEWORK_PATH/.opencode" ] || \
  fail "standalone Framework-root OpenCode tree must be absent; use adapters/opencode"

for file in \
  setup.sh \
  setup.ps1 \
  scripts/i18n/setup.tsv \
  scripts/public-document-pairs.tsv \
  scripts/translation-pairs.tsv \
  locales/translation-review.json \
  README.md \
  README.pt-BR.md \
  CONTRIBUTING.md \
  SECURITY.md \
  TESTING.md \
  START_PROJECTS.en-US.md \
  AGENTS.md \
  LICENSE \
  CHANGELOG.md \
  ROADMAP.md \
  OVERVIEW.md \
  .gitattributes \
  docs/ADR.md \
  docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md \
  docs/security-audit/gerar_relatorio.py \
  docs/security-audit/test_gerar_relatorio.py \
  docs/security-audit/README.md \
  docs/security-audit/relatorio-auditoria-seguranca.pdf \
  .github/workflows/validate.yml \
  .github/workflows/release.yml \
  .github/ISSUE_TEMPLATE/bug_report.md \
  .github/ISSUE_TEMPLATE/feature_request.md \
  .github/PULL_REQUEST_TEMPLATE.md \
  adapters/README.md \
  locales/README.md \
  locales/en-US/README.md \
  locales/pt-BR/README.md \
  locales/pt-BR/TRANSLATION_STATUS.md \
  locales/pt-BR/public-docs/CONTRIBUTING.md \
  locales/pt-BR/public-docs/SECURITY.md \
  locales/pt-BR/public-docs/SECURITY_AUDIT.md \
  locales/pt-BR/public-docs/TESTING.md \
  locales/pt-BR/public-docs/START_PROJECTS.md \
  locales/pt-BR/public-docs/CHANGELOG.md \
  locales/pt-BR/public-docs/ROADMAP.md \
  locales/pt-BR/public-docs/OVERVIEW.md \
  locales/pt-BR/docs/ADR.md \
  PROJECT_TEMPLATE/AGENTS.md \
  PROJECT_TEMPLATE/LF_ENGINEERING.md \
  PROJECT_TEMPLATE/README.md \
  adapters/opencode/opencode.jsonc \
  scripts/bootstrap.sh \
  scripts/bootstrap.ps1 \
  scripts/check-locales.sh \
  scripts/package-release.sh \
  scripts/validate-framework.sh \
  scripts/validate-framework.ps1 \
  scripts/test-bootstrap.sh \
  scripts/test-bootstrap.ps1; do
  require_file "$file"
done

[ ! -e "$FRAMEWORK_PATH/PROJECT_TEMPLATE/opencode.jsonc" ] || \
  fail "OpenCode configuration must be optional"

placeholder='__LF_ENGINEERING_SYSTEM_PATH__'
placeholder_files=$(cd "$FRAMEWORK_PATH" && grep -R -l -F "$placeholder" PROJECT_TEMPLATE adapters | LC_ALL=C sort || true)
expected_placeholders=$(printf '%s\n' \
  'PROJECT_TEMPLATE/LF_ENGINEERING.md' \
  'adapters/opencode/opencode.jsonc' | LC_ALL=C sort)
[ "$placeholder_files" = "$expected_placeholders" ] || \
  fail "unexpected Framework placeholders"

sh "$FRAMEWORK_PATH/scripts/check-locales.sh"
sh -n "$FRAMEWORK_PATH/setup.sh"
sh -n "$FRAMEWORK_PATH/scripts/bootstrap.sh"
sh -n "$FRAMEWORK_PATH/scripts/check-locales.sh"
sh -n "$FRAMEWORK_PATH/scripts/package-release.sh"

if command -v node >/dev/null 2>&1; then
  node -e 'const fs=require("fs"); JSON.parse(fs.readFileSync(process.argv[1], "utf8"));' \
    "$FRAMEWORK_PATH/adapters/opencode/opencode.jsonc"
  node -e '
    const fs = require("fs");
    const config = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    const required = [
      "__LF_ENGINEERING_SYSTEM_PATH__/AGENTS.md",
      "__LF_ENGINEERING_SYSTEM_PATH__/agents/Engineering-Manager/SPECS.md",
      "__LF_ENGINEERING_SYSTEM_PATH__/workflows/NEW_PROJECT.md",
      "__LF_ENGINEERING_SYSTEM_PATH__/workflows/STANDARD_DEVELOPMENT.md",
    ];
    const instructions = config.instructions || [];
    if (required.some((value) => !instructions.includes(value))) {
      throw new Error("OpenCode adapter must reference canonical Framework instructions and workflows.");
    }
    if (instructions.some((value) => value.includes("/.opencode/")) || config.mcp) {
      throw new Error("OpenCode adapter must not depend on a standalone Framework tree or MCP server.");
    }
  ' "$FRAMEWORK_PATH/adapters/opencode/opencode.jsonc"
else
  echo "Node.js not found; OpenCode JSON syntax check skipped."
fi

echo "Framework validation passed."
