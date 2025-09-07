#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT/layer_build/python"

echo "[INFO] Limpando..."
rm -rf "$ROOT/layer_build" "$ROOT/layer.zip"
mkdir -p "$BUILD_DIR"

echo "[INFO] Instalando deps do CORE (sem deps transitivas do wrangler)..."
python -m pip install --upgrade pip
# awswrangler sem deps pra NÃO puxar boto3/pyarrow
pip install -t "$BUILD_DIR" --no-cache-dir --no-compile --only-binary=:all: --no-deps awswrangler==3.12.1
# runtime que queremos
pip install -t "$BUILD_DIR" --no-cache-dir --no-compile --only-binary=:all: numpy==2.1.2 pandas==2.3.1

echo "[INFO] Copiando sua lib..."
# sua lib fica em src/artifact_lib
cp -R "$ROOT/src/artifact_lib" "$BUILD_DIR/"

echo "[INFO] Limpando peso inútil..."
find "$BUILD_DIR" -type d -name "__pycache__" -exec rm -rf {} +
find "$BUILD_DIR" -type d \( -name "*.dist-info" -o -name "*.egg-info" -o -name "tests" \) -exec rm -rf {} +

echo "[INFO] Gerando zip (CORE)..."
( cd "$ROOT/layer_build" && zip -r ../layer.zip python >/dev/null )
echo "[OK] layer.zip pronto (CORE)."
