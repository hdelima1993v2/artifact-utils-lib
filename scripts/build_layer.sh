#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT/layer_build/python"

echo "[INFO] Limpando..."
rm -rf "$ROOT/layer_build" "$ROOT/layer.zip"
mkdir -p "$BUILD_DIR"

echo "[INFO] Copiando artifact_lib..."
cp -r "$ROOT/src/artifact_lib" "$BUILD_DIR/artifact_lib"

REQ="$ROOT/requirements-layer.txt"
if [ -f "$REQ" ] && [ -s "$REQ" ]; then
  echo "[INFO] Instalando deps leves layer..."
  pip install --no-cache-dir -r "$REQ" -t "$BUILD_DIR"
fi

echo "[INFO] Removendo __pycache__..."
find "$BUILD_DIR" -type d -name "__pycache__" -exec rm -rf {} +

echo "[INFO] Validando..."
test -f "$BUILD_DIR/artifact_lib/__init__.py" || { echo "Faltou __init__.py"; exit 1; }

echo "[INFO] Gerando zip..."
cd "$ROOT/layer_build"
zip -r ../layer.zip . >/dev/null
cd "$ROOT"

echo "[OK] layer.zip pronto."
unzip -l layer.zip | head -30
