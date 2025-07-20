#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="$ROOT/layer_build/python"

echo "[INFO] Limpando..."
rm -rf "$ROOT/layer_build" "$ROOT/layer.zip"
mkdir -p "$BUILD"

echo "[INFO] Copiando código..."
cp -r "$ROOT/src/artifact_lib" "$BUILD/artifact_lib"

echo "[DEBUG] Conteúdo do comando ls -R src/:"
ls -R src/

if [ -f "$ROOT/requirements.txt" ] && [ -s "$ROOT/requirements.txt" ]; then
  echo "[INFO] Instalando dependências..."
  pip install --upgrade pip
  pip install -r "$ROOT/requirements.txt" -t "$BUILD"
fi

echo "[INFO] Removendo __pycache__..."
find "$BUILD" -type d -name "__pycache__" -exec rm -rf {} +

echo "[DEBUG] Conteúdo de $BUILD:"
find "$BUILD" -maxdepth 3 -type f -print

if [ -z "$(find "$BUILD" -type f -maxdepth 3)" ]; then
  echo "[ERRO] Nenhum arquivo encontrado dentro de $BUILD. Abortando para evitar zip vazio."
  exit 1
fi

echo "[INFO] Zipando..."
cd "$ROOT/layer_build"
zip -r ../layer.zip .
cd "$ROOT"
echo "[SUCCESS] layer.zip pronto."

echo "[DEBUG] Conteúdo do zip:"
unzip -l "$ROOT/layer.zip" || true

