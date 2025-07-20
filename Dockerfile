FROM public.ecr.aws/lambda/python:3.11

# Dependências completas (pesadas)
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copia somente sua lib
COPY src/ ./artifact_lib

# Gera handler dinâmico (NÃO versionado / não muda repo)
RUN set -euo pipefail; \
    echo '"""Handler gerado automaticamente. Usa artifact_lib.*"""' > handler_generated.py; \
    echo 'from artifact_lib import datamesh, utils' >> handler_generated.py; \
    echo 'def lambda_handler(event, context):' >> handler_generated.py; \
    echo '    # Router simples baseado em event["action"]' >> handler_generated.py; \
    echo '    if isinstance(event, dict):' >> handler_generated.py; \
    echo '        act = event.get("action")' >> handler_generated.py; \
    echo '        if act == "funcao_1":' >> handler_generated.py; \
    echo '            return {"ok": True, "result": datamesh.funcao_1(event.get("domain","dom"), event.get("name","data"))}' >> handler_generated.py; \
    echo '        if act == "funcao_2":' >> handler_generated.py; \
    echo '            return {"ok": True, "result": utils.funcao_2(event.get("x",1), event.get("y",2))}' >> handler_generated.py; \
    echo '    return {"ok": True, "message": "Use action=funcao_1|funcao_2"}' >> handler_generated.py;

CMD ["handler_generated.lambda_handler"]
