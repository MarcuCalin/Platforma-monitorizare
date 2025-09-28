# Dockerfile pentru imaginea scriptului de monitorizare bash.
# Dockerfile.monitor
FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    sysstat procps && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY /scripts/monitoring.sh /app/monitoring.sh
RUN chmod +x /app/monitoring.sh

CMD ["/app/monitoring.sh"]
