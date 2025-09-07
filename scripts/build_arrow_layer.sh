#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT/layer_build_arrow/python"

echo "[INFO] Limpando (arrow)..."
rm -rf "$ROOT/layer_build_arrow" "$ROOT/arrow_layer.zip"
mkdir -p "$BUILD_DIR"

echo "[INFO] Instalando pyarrow no layer..."
python -m pip install --upgrade pip
pip install -t "$BUILD_DIR" --no-cache-dir --no-compile --only-binary=:all: -r "$ROOT/requirements-layer-arrow.txt"

echo "[INFO] Removendo __pycache__ e metadados..."
find "$BUILD_DIR" -type d -name "__pycache__" -exec rm -rf {} +
find "$BUILD_DIR" -type d \( -name "*.dist-info" -o -name "*.egg-info" -o -name "tests" \) -exec rm -rf {} +

echo "[INFO] Gerando arrow_layer.zip..."
( cd "$ROOT/layer_build_arrow" && zip -r ../arrow_layer.zip python >/dev/null )
echo "[OK] arrow_layer.zip pronto."
