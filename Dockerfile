# Docker image: rasylhan-aldiyar-devops
# Author: Rasylhan Aldiyar, IT2-2309, Student ID 37838

# 1. Base image: minimal Linux + Python 3.12
FROM python:3.12-slim

LABEL maintainer="Rasylhan Aldiyar" \
      group="IT2-2309" \
      student_id="37838"

# 2. Working directory inside the image (all next commands run here)
WORKDIR /app

# 3. Copy application code and configuration into the image
COPY app/ /app/
COPY config/app.conf /app/config/app.conf

# 4. Build steps: check syntax, run unit tests, create a non-root user
RUN python -m py_compile app.py \
 && python -m unittest -v test_app \
 && useradd --create-home appuser \
 && chown -R appuser:appuser /app

# Default (non-secret) values, can be overridden with `docker run -e ...`
ENV STUDENT_NAME="Aldiyar" \
    STUDENT_SURNAME="Rasylhan" \
    STUDENT_GROUP="IT2-2309" \
    STUDENT_ID="37838" \
    APP_MODE="print" \
    APP_PORT="8080" \
    PYTHONUNBUFFERED=1

USER appuser

# 5. Port used in server mode (APP_MODE=server)
EXPOSE 8080

# 6. Command that starts when the container starts
CMD ["python", "app.py"]
