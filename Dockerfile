# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.7 AS dependencies

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install pip requirements
ADD requirements/base.txt requirements.txt

# Setup the virtualenv
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"
RUN python -m pip install --no-cache-dir -r requirements.txt

# --- Release with slim ----
FROM python:3.7-slim AS release

# Extra python env
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PATH="/venv/bin:$PATH"

# Create app directory
WORKDIR /app
COPY --from=dependencies /venv /venv
ADD . /app

EXPOSE 5000

CMD ["newrelic-admin", "run-program", "/venv/bin/gunicorn", "kube_aiohttp_test:app", "--workers", "4", "--backlog", "2048", "--keep-alive", "65", "--bind", "0.0.0.0:5000", "--worker-class", "aiohttp.worker.GunicornUVLoopWebWorker", "--max-requests", "0", "--max-requests-jitter", "0", "--graceful-timeout", "3", "--access-logfile", "-", "--chdir", "/app"]
