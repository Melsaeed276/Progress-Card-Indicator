#!/bin/bash
# Launches the progress_card example app on the first available iOS Simulator.
# Double-click this file in Finder to run.

set -e

# Try common Flutter locations
for p in \
  "$HOME/fvm/default/bin" \
  "$HOME/.pub-cache/bin" \
  "/opt/homebrew/bin" \
  "/usr/local/bin" \
  "$HOME/flutter/bin" \
  "/usr/local/flutter/bin"; do
  if [ -x "$p/flutter" ]; then
    export PATH="$p:$PATH"
    break
  fi
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/example"

echo "=== progress_card example ==="
echo "Working dir: $(pwd)"
echo "Flutter:     $(which flutter)"
echo "Running on iOS Simulator..."
echo ""

flutter run -d iPhone
