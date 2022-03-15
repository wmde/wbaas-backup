
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y mydumper

WORKDIR /app
COPY src/ /app 

ENV DB_PORT=3306 \
    DB_HOST="localhost" \
    DB_PASSWORD="" \
    DB_USER="" \
    BACKUP_DIR="/backup/"

ENTRYPOINT [ "/app/entrypoint.sh" ]