FROM public.ecr.aws/lambda/python:3.12

COPY requirements.txt .
RUN python -m pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Copia TUDO que está em infra/image/src/ para /var/task/
COPY src/ ./

# Seu handler fica em app.py -> function handler()
CMD ["app.handler"]
