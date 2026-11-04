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

for directory in agents knowledge workflows protocols schemas PROJECT_TEMPLATE adapters locales scripts docs .github .opencode; do
  require_directory "$directory"
done

for file in \
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
  .opencode/README.md \
  .opencode/opencode.jsonc \
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
sh -n "$FRAMEWORK_PATH/scripts/bootstrap.sh"
sh -n "$FRAMEWORK_PATH/scripts/check-locales.sh"
sh -n "$FRAMEWORK_PATH/scripts/package-release.sh"

if command -v node >/dev/null 2>&1; then
  temporary_config=$(mktemp "${TMPDIR:-/tmp}/lf-opencode-validation.XXXXXX")
  cleanup() {
    rm -f "$temporary_config"
  }
  trap cleanup EXIT HUP INT TERM
  escaped_framework_path=$(printf '%s' "$FRAMEWORK_PATH" | sed 's/[\\&|]/\\&/g')
  sed "s|$placeholder|$escaped_framework_path|g" \
    "$FRAMEWORK_PATH/adapters/opencode/opencode.jsonc" > "$temporary_config"
  node -e 'const fs=require("fs"); JSON.parse(fs.readFileSync(process.argv[1], "utf8"));' \
    "$temporary_config"
  node -e '
    const fs = require("fs");
    const config = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    const server = config?.mcp?.servers?.github;
    if (!server || server.type !== "local" || server.disabled !== true) {
      throw new Error("GitHub MCP server must be local and disabled by default.");
    }
    const command = server.command || [];
    const required = [
      "127.0.0.1:8085:8085",
      "GITHUB_OAUTH_CALLBACK_PORT=8085",
      "GITHUB_OAUTH_SCOPES=public_repo",
      "GITHUB_TOOLSETS=repos",
      "GITHUB_READ_ONLY=true",
    ];
    if (command[0] !== "docker" || command[1] !== "run" ||
        required.some((value) => !command.includes(value))) {
      throw new Error("GitHub MCP server must use the loopback callback and read-only repository settings.");
    }
    const image = command.find((value) => value.startsWith("ghcr.io/github/github-mcp-server:"));
    if (!image || !/^ghcr\.io\/github\/github-mcp-server:v\d+\.\d+\.\d+$/.test(image)) {
      throw new Error("GitHub MCP server image must be pinned to a release version.");
    }
  ' "$FRAMEWORK_PATH/.opencode/opencode.jsonc"
else
  echo "Node.js not found; OpenCode JSON syntax check skipped."
fi

echo "Framework validation passed."
