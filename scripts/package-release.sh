#!/bin/sh

set -eu

fail() {
  echo "Release packaging failed: $*" >&2
  exit 1
}

VERSION=${1:-}
OUTPUT_DIR=${2:-dist}

[ -n "$VERSION" ] || fail "usage: package-release.sh VERSION [OUTPUT_DIR]"

case "$VERSION" in
  v*) VERSION=${VERSION#v} ;;
esac

case "$VERSION" in
  *[!0-9A-Za-z.-]*|"") fail "VERSION must contain only letters, numbers, dots and hyphens" ;;
esac

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
REPOSITORY_ROOT=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)
case "$OUTPUT_DIR" in
  /*) ;;
  *) OUTPUT_DIR="$REPOSITORY_ROOT/$OUTPUT_DIR" ;;
esac
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR=$(CDPATH= cd "$OUTPUT_DIR" && pwd -P)

if [ -n "$(git -C "$REPOSITORY_ROOT" status --porcelain)" ]; then
  fail "the repository must be clean before packaging a release"
fi

archive_base="lf-engineering-framework-v$VERSION"
prefix="$archive_base/"
tar_archive="$OUTPUT_DIR/$archive_base.tar.gz"
zip_archive="$OUTPUT_DIR/$archive_base.zip"
checksums="$OUTPUT_DIR/SHA256SUMS"

rm -f "$tar_archive" "$zip_archive" "$checksums"

git -C "$REPOSITORY_ROOT" archive \
  --format=tar.gz \
  --prefix="$prefix" \
  --output="$tar_archive" \
  HEAD

git -C "$REPOSITORY_ROOT" archive \
  --format=zip \
  --prefix="$prefix" \
  --output="$zip_archive" \
  HEAD

case "$(command -v sha256sum 2>/dev/null || true)" in
  "")
    command -v shasum >/dev/null 2>&1 || fail "sha256sum or shasum is required"
    (
      cd "$OUTPUT_DIR"
      shasum -a 256 "$(basename "$tar_archive")" "$(basename "$zip_archive")" > "$(basename "$checksums")"
    )
    ;;
  *)
    (
      cd "$OUTPUT_DIR"
      sha256sum "$(basename "$tar_archive")" "$(basename "$zip_archive")" > "$(basename "$checksums")"
    )
    ;;
esac

echo "Created: $tar_archive"
echo "Created: $zip_archive"
echo "Created: $checksums"
