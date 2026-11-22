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

if [ -n "$(git -C "$REPOSITORY_ROOT" status --porcelain)" ]; then
  fail "the repository must be clean before packaging a release"
fi

command -v python3 >/dev/null 2>&1 || fail "python3 is required to build the platform/language packages"
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR=$(CDPATH= cd "$OUTPUT_DIR" && pwd -P)

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

python3 "$SCRIPT_DIR/package_installers.py" \
  --root "$REPOSITORY_ROOT" \
  --output "$OUTPUT_DIR" \
  --version "v$VERSION"

case "$(command -v sha256sum 2>/dev/null || true)" in
  "")
    command -v shasum >/dev/null 2>&1 || fail "sha256sum or shasum is required"
    (
      cd "$OUTPUT_DIR"
      set -- "$archive_base.tar.gz" "$archive_base.zip"
      for platform in macos linux windows; do
        for language in en-US pt-BR; do
          extension=tar.gz
          [ "$platform" = windows ] && extension=zip
          set -- "$@" "lf-engineering-framework-v$VERSION-$platform-$language.$extension"
        done
      done
      shasum -a 256 "$@" > "$(basename "$checksums")"
    )
    ;;
  *)
    (
      cd "$OUTPUT_DIR"
      set -- "$archive_base.tar.gz" "$archive_base.zip"
      for platform in macos linux windows; do
        for language in en-US pt-BR; do
          extension=tar.gz
          [ "$platform" = windows ] && extension=zip
          set -- "$@" "lf-engineering-framework-v$VERSION-$platform-$language.$extension"
        done
      done
      sha256sum "$@" > "$(basename "$checksums")"
    )
    ;;
esac

echo "Created: $tar_archive"
echo "Created: $zip_archive"
echo "Created platform and language packages for macOS, Linux and Windows"
echo "Created: $checksums"
