
FROM ubuntu:latest

ENV GCSFUSE_REPO gcsfuse-stretch

RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    mydumper \
  && echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" \
    | tee /etc/apt/sources.list.d/gcsfuse.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && apt-get update \
  && apt-get install --yes gcsfuse \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN mkdir /backups && mkdir -p /mnt/backup-bucket

WORKDIR /app
COPY src/ /app 

ENV DB_PORT=3306 \
    DB_HOST="localhost" \
    DB_PASSWORD="" \
    DB_USER="" \
    BACKUP_DIR="/backup/"

ENTRYPOINT [ "/app/entrypoint.sh" ]