#!/usr/bin/env bash
#
# Generates the PDF version of the presentation using Marp CLI.
# Usage: ./docs/generate-slides.sh
#
# Prerequisites:
#   npm install -g @marp-team/marp-cli
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="$SCRIPT_DIR/presentation.pptx"

if ! command -v marp &> /dev/null; then
  echo "Error: marp CLI is not installed."
  echo "Install it with: npm install -g @marp-team/marp-cli"
  exit 1
fi

echo "Generating PDF..."
marp "$SCRIPT_DIR/presentation.md" --pptx-editable --output "$OUTPUT" --allow-local-files

echo "Done: $OUTPUT"
