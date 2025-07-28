# Imagem base Python 3.11 para AWS Lambda
FROM public.ecr.aws/lambda/python:3.11

# 1 · Instala git (pip precisa para clonar repositórios declarados no requirements)
RUN yum -y update && yum -y install git && yum clean all

# 2 · Copia o requirements.txt para a imagem
COPY requirements.txt /tmp/requirements.txt

# 3 · Instala dependências SOMENTE se houver wheel binário disponível
#    --prefer-binary      → prefere wheel em vez de sdist
#    --only-binary=:all:  → recusa instalar qualquer pacote que não tenha wheel
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir --prefer-binary --only-binary=:all: \
      -r /tmp/requirements.txt

# 4 · Copia a sua biblioteca (ajuste o caminho se for diferente)
COPY src/ /var/task/artifact_lib

# 5 · Cria o handler gerado em tempo de build (mantive seu bloco)
RUN set -euo pipefail; \
    echo '"""Handler gerado automaticamente (não versionado)."""' > handler_generated.py; \
    echo 'import json, pandas as pd' >> handler_generated.py; \
    echo 'from artifact_lib.datamesh import ingest_expenses_sor' >> handler_generated.py; \
    echo 'from artifact_lib.utils import get_dateref_yyyymm' >> handler_generated.py; \
    echo 'def lambda_handler(event, context):' >> handler_generated.py; \
    echo '    if not isinstance(event, dict):' >> handler_generated.py; \
    echo '        return {"error": "payload deve ser JSON"}' >> handler_generated.py; \
    echo '    action = event.get("action")' >> handler_generated.py; \
    echo '    if action == "ingest":' >> handler_generated.py; \
    echo '        df = pd.DataFrame(event.get("dataframe", []))' >> handler_generated.py; \
    echo '        return ingest_expenses_sor(df, event.get("user", "default"))' >> handler_generated.py; \
    echo '    if action == "dateref":' >> handler_generated.py; \
    echo '        df = pd.DataFrame(event.get("dataframe", []))' >> handler_generated.py; \
    echo '        return {"dateref": get_dateref_yyyymm(df,' >> handler_generated.py; \
    echo '                                event.get("date_column"),' >> handler_generated.py; \
    echo '                                event.get("format_field"),' >> handler_generated.py; \
    echo '                                event.get("sell_type"))}' >> handler_generated.py; \
    echo '    return {"message": "use action=ingest ou action=dateref"}' >> handler_generated.py

# 6 · Declara o entry‑point da Lambda
CMD ["handler_generated.lambda_handler"]
