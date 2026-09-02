#!/usr/bin/env bash
set -euo pipefail

RIOT="${RIOT:-riot}"
RDFCOMPARE="${RDFCOMPARE:-rdfcompare}"
SOURCE="${1:-dcat/rdf/dcat3.ttl}"
OUTPUT_DIR="${2:-dcat/rdf}"

if [[ ! -f "$SOURCE" ]]; then
  echo "Source file not found: $SOURCE" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"
"$RIOT" --validate "$SOURCE"
"$RIOT" --output=JSONLD "$SOURCE" > "$OUTPUT_DIR/dcat3.jsonld"
"$RIOT" --output=RDFXML "$SOURCE" > "$OUTPUT_DIR/dcat3.rdf"

# Parse every generated representation to catch malformed output immediately.
"$RIOT" --validate "$OUTPUT_DIR/dcat3.jsonld"
"$RIOT" --validate "$OUTPUT_DIR/dcat3.rdf"

# Compare graphs, not serialized text, so ordering and blank-node labels do
# not create false differences.
"$RDFCOMPARE" "$SOURCE" "$OUTPUT_DIR/dcat3.jsonld" TURTLE JSON-LD
"$RDFCOMPARE" "$SOURCE" "$OUTPUT_DIR/dcat3.rdf" TURTLE RDF/XML
