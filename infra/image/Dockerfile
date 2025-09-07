FROM public.ecr.aws/lambda/python:3.12
WORKDIR /var/task

COPY requirements.txt .
RUN python -m pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# copia o handler e, se quiser, parte da lib
COPY src/ ./

CMD ["app.handler"]
