#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="$ROOT/layer_build/python"

echo "[INFO] Limpando..."
rm -rf "$ROOT/layer_build" "$ROOT/layer.zip"
mkdir -p "$BUILD"

echo "[INFO] Copiando código próprio..."
# Ajuste o nome da pasta se mudar
cp -r "$ROOT/src/artifact_lib" "$BUILD/artifact_lib"

# (Opcional) __init__.py se ainda não existir
[ -f "$BUILD/artifact_lib/__init__.py" ] || echo '__all__ = []' > "$BUILD/artifact_lib/__init__.py"

# -----------------------------
# 1) Instalação de dependências
# -----------------------------
if [ -f "$ROOT/requirements.txt" ] && [ -s "$ROOT/requirements.txt" ]; then
  echo "[INFO] Instalando dependências..."
  pip install --upgrade pip
  pip install --no-cache-dir -r "$ROOT/requirements.txt" -t "$BUILD"
fi

# ---------------------------------------
# 2) DIAGNÓSTICO INICIAL (COLOQUE AQUI)
# ---------------------------------------
echo "[INFO] DIAGNÓSTICO INICIAL DO BUILD"
echo "[INFO] TOP 30 maiores arquivos:"
find "$BUILD" -type f -printf '%s %p\n' | sort -nr | head -30 || true

echo "[INFO] Tamanho total (bytes):"
du -sb "$BUILD" || true

echo "[INFO] Tamanho por diretório de nível 1:"
du -h -d1 "$BUILD" || true

# ---------------------------------------
# 3) PODA / LIMPEZA (se precisar reduzir)
# ---------------------------------------
echo "[INFO] Podando itens desnecessários..."

# Remover libs que já existem no runtime da Lambda (não empacotar boto3 e amigos)
rm -rf "$BUILD/boto3" "$BUILD/botocore" "$BUILD/dateutil" "$BUILD/jmespath" \
       "$BUILD/s3transfer" "$BUILD/urllib3" "$BUILD/six.py" 2>/dev/null || true

# Remover testes/docs
find "$BUILD" -type d \( -name tests -o -name test -o -name doc -o -name docs \) -prune -exec rm -rf {} +

# Remover __pycache__
find "$BUILD" -type d -name "__pycache__" -prune -exec rm -rf {} +

# Minimizar *.dist-info (mantém só METADATA e RECORD)
find "$BUILD" -type d -name "*.dist-info" -exec bash -c '
  for d; do
    find "$d" -type f ! -name METADATA ! -name RECORD -delete
  done
' _ {} +

# ---------------------------------------
# 4) DIAGNÓSTICO APÓS PODA (opcional)
# ---------------------------------------
echo "[INFO] DIAGNÓSTICO APÓS PODA"
echo "[INFO] TOP 30 maiores arquivos (pós-poda):"
find "$BUILD" -type f -printf '%s %p\n' | sort -nr | head -30 || true

echo "[INFO] Tamanho total (bytes) pós-poda:"
du -sb "$BUILD" || true

echo "[INFO] Tamanho por diretório (pós-poda):"
du -h -d1 "$BUILD" || true

# Falhar se continuar sem arquivos
if [ -z "$(find "$BUILD" -type f -maxdepth 3)" ]; then
  echo "[ERRO] Nenhum arquivo encontrado após build."
  exit 1
fi

# ---------------------------------------
# 5) Gerar ZIP
# ---------------------------------------
echo "[INFO] Gerando zip..."
cd "$ROOT/layer_build"
zip -r ../layer.zip . >/dev/null
cd "$ROOT"

SIZE=$(stat -c%s "layer.zip")
echo "[INFO] Tamanho final layer.zip (bytes): $SIZE"

# Limite de segurança (50MB = 52428800)
if [ "$SIZE" -gt 50000000 ]; then
  echo "[ERRO] layer.zip > 50MB (limite Lambda Layer)."
  exit 1
fi

echo "[SUCCESS] layer.zip pronto."

echo "[DEBUG] Listagem do zip:"
unzip -l layer.zip | head -40 || true
