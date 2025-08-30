FROM public.ecr.aws/lambda/python:3.12
COPY requirements.txt .
RUN python -m pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["app.handler"]
