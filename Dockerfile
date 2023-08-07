FROM python:3.9-slim-buster
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . /app
ENTRYPOINT [ "python", "app.py" ]