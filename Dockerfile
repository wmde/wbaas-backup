FROM ubuntu:bionic

ARG GCLOUD_VERSION=442.0.0
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN useradd -u 1234 -m notroot && \
    mkdir -p /backups/tmp && \
    mkdir -p /backups/output && \
    chown notroot /backups -R && \
    apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates=20230311ubuntu0.18.04.1 \
    curl=7.58.0-2ubuntu3.24 \
    gnupg=2.2.4-1ubuntu1.6 \
    mydumper=0.9.1-5 \
    gettext-base=0.19.8.1-6ubuntu0.3 \
    mariadb-client=1:10.1.48-0ubuntu0.18.04.1 && \
    curl -sSL -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-$GCLOUD_VERSION-$TARGETOS-${TARGETARCH/amd64/x86_64}.tar.gz" && \
    mkdir -p /usr/local/gcloud && \
    tar -C /usr/local/gcloud -xvf "google-cloud-cli-$GCLOUD_VERSION-$TARGETOS-${TARGETARCH/amd64/x86_64}.tar.gz" && \
    /usr/local/gcloud/google-cloud-sdk/install.sh && \
    rm -rf "google-cloud-cli-$GCLOUD_VERSION-$TARGETOS--${TARGETARCH/amd64/x86_64}.tar.gz" && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

USER notroot

COPY --chown=notroot .boto.template /home/notroot/.boto.template

WORKDIR /app
COPY --chown=notroot src/ /app

ENV DB_PORT="3306" \
    DB_HOST="localhost" \
    DO_UPLOAD="1" \
    MYDUMPER_VERBOSE_LEVEL="1" \
    STORAGE_ENDPOINT="storage.googleapis.com" \
    STORAGE_SIGNATURE_VERSION="S3v2" \
    REPLICATION_THRESHOLD="60" \
    SECONDARY_HOST="sql-mariadb-secondary.default.svc.cluster.local" \
    DO_CHECK_SECONDARY="1"

ENTRYPOINT [ "/app/entrypoint.sh" ]
