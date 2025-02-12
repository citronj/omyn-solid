FROM python:3-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Installation de Jupyter
COPY requirements.txt .
RUN pip install -r requirements.txt

# Configuration de Jupyter avec un mot de passe par défaut
RUN jupyter server --generate-config && \
    python -c "from jupyter_server.auth import passwd; print(passwd('votre_mot_de_passe'))" > /tmp/passwd && \
    echo "c.ServerApp.password = open('/tmp/passwd').read().strip()" >> /root/.jupyter/jupyter_server_config.py

COPY . /app

EXPOSE 8888

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]