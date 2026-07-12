#!/usr/bin/env bash
# Run on macOS with Xcode 26 to download depth models for Spatial3D Converter.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RES="$ROOT/Spatial3DConverter/Resources"
mkdir -p "$RES"

if ! command -v huggingface-cli >/dev/null 2>&1; then
  echo "Install huggingface-cli: pip install huggingface_hub"
  exit 1
fi

echo "Downloading Depth Anything V2 Small..."
huggingface-cli download apple/coreml-depth-anything-v2-small \
  --local-dir "$ROOT/models/DepthV2Small" \
  --include "DepthAnythingV2SmallF16.mlpackage/*"

if command -v coreai-build >/dev/null 2>&1; then
  echo "Building Spatial3DDepthV2Small.coreai..."
  coreai-build --input "$ROOT/models/DepthV2Small" \
    --output "$RES/Spatial3DDepthV2Small.coreai"
else
  echo "coreai-build not found. Copy .mlpackage manually until Core AI toolchain is installed."
fi

echo "Done. Add Resources/*.coreai to the Spatial3DConverter Xcode target."
