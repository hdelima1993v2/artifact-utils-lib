# --------------------------------------------------
# Imagem base oficial da AWS Lambda (Python 3.11)
# --------------------------------------------------
FROM public.ecr.aws/lambda/python:3.11

# --------------------------------------------------
# 1. Atualiza pacotes e instala:
#    • git                 → para pip clonar deps via HTTPS
#    • Development Tools   → gcc, g++, make, etc. (compilar C/C++)
#    • cmake / ninja       → compilar libs que exigem esses builders
#    • openssl‑devel, bzip2‑devel, libffi‑devel → headers comuns
# --------------------------------------------------
RUN yum -y update \
 && yum -y groupinstall "Development Tools" \
 && yum -y install git cmake ninja-build openssl-devel bzip2-devel libffi-devel \
 && yum clean all

# --------------------------------------------------
# 2. Copia apenas o requirements.txt
#    (mantém o cache do Docker leve)
# --------------------------------------------------
COPY requirements.txt .

# --------------------------------------------------
# 3. Instala dependências
#    • --no-cache-dir → evita cache local do pip
#    • --upgrade pip/setuptools/wheel
# --------------------------------------------------
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir -r requirements.txt
 
# -----------------------------------------------------------------
# 2. Copia APENAS a sua biblioteca (estrutura preservada)
# -----------------------------------------------------------------
COPY src/ ./artifact_lib

# -----------------------------------------------------------------
# 3. Gera dinamicamente um handler (não versionado no Git)
#    • Se quiser outra lógica, edite este bloco echo.
# -----------------------------------------------------------------
RUN set -euo pipefail; \
    echo '"""Handler gerado automaticamente (não está no repositório)."""' > handler_generated.py; \
    echo 'import json, pandas as pd, awswrangler as wr' >> handler_generated.py; \
    echo 'from artifact_lib.datamesh import ingest_expenses_sor' >> handler_generated.py; \
    echo 'from artifact_lib.utils import get_dateref_yyyymm' >> handler_generated.py; \
    echo '' >> handler_generated.py; \
    echo 'def lambda_handler(event, context):' >> handler_generated.py; \
    echo '    """Despacha pela chave \"action\": "ingest" ou "dateref"."""' >> handler_generated.py; \
    echo '    if not isinstance(event, dict):' >> handler_generated.py; \
    echo '        return {"error": "payload deve ser JSON"}' >> handler_generated.py; \
    echo '    action = event.get("action")' >> handler_generated.py; \
    echo '    if action == "ingest":' >> handler_generated.py; \
    echo '        df_json = event.get("dataframe", [])' >> handler_generated.py; \
    echo '        df = pd.DataFrame(df_json)' >> handler_generated.py; \
    echo '        user = event.get("user", "default")' >> handler_generated.py; \
    echo '        return ingest_expenses_sor(df, user)' >> handler_generated.py; \
    echo '    if action == "dateref":' >> handler_generated.py; \
    echo '        df_json = event.get("dataframe", [])' >> handler_generated.py; \
    echo '        df = pd.DataFrame(df_json)' >> handler_generated.py; \
    echo '        return {"dateref": get_dateref_yyyymm(df,' >> handler_generated.py; \
    echo '                                event.get("date_column"),' >> handler_generated.py; \
    echo '                                event.get("format_field"),' >> handler_generated.py; \
    echo '                                event.get("sell_type"))}' >> handler_generated.py; \
    echo '    return {"message": "use action=ingest ou action=dateref"}' >> handler_generated.py

# -----------------------------------------------------------------
# 4. Define o handler da Lambda
# -----------------------------------------------------------------
CMD ["handler_generated.lambda_handler"]
# ================================================================
