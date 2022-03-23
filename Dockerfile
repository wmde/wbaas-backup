
FROM ubuntu:bionic

ENV GCSFUSE_REPO gcsfuse-stretch

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mkdir /backups && mkdir -p /mnt/backup-bucket && \
    apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates=20210119~18.04.2 \
    curl=7.58.0-2ubuntu3.16 \
    gnupg=2.2.4-1ubuntu1.4 \
    mydumper=0.9.1-5 \
  && echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" \
    | tee /etc/apt/sources.list.d/gcsfuse.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && apt-get update \
  && apt-get install --yes gcsfuse=0.40.0 --no-install-recommends \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

WORKDIR /app
COPY src/ /app 

ENV DB_PORT=3306 \
    DB_HOST="localhost" \
    DB_PASSWORD="" \
    DB_USER="" \
    DO_UPLOAD="1" \
    GCS_BUCKET_NAME="" \
    BACKUP_KEY=""

ENTRYPOINT [ "/app/entrypoint.sh" ]