FROM public.ecr.aws/lambda/python:3.11

# Só as libs que realmente precisa
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Código da lib
COPY src/ ./artifact_lib
# Handler
COPY handler.py .

CMD ["handler.lambda_handler"]