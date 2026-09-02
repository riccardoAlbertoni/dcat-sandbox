#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="${1:-"$ROOT/_site"}"
RIOT="${RIOT:-riot}"

rm -rf "$DIST"
mkdir -p "$DIST"

tar \
  --exclude='./.git' \
  --exclude='./_site' \
  --exclude='./dcat/rdf/dcat3.jsonld' \
  --exclude='./dcat/rdf/dcat3.rdf' \
  -cf - -C "$ROOT" . | tar -xf - -C "$DIST"

"$ROOT/scripts/generate-rdf.sh" \
  "$DIST/dcat/rdf/dcat3.ttl" \
  "$DIST/dcat/rdf"

echo "Publication site built at $DIST"
