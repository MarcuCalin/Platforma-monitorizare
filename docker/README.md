#Comenzi Docker

cd /docker

## Build imagini

## Monitoring
docker build -t system-monitor -f Dockerfile.monitoring ..

## Backup
docker build -t system-backup -f Dockerfile.backup ..

Rulare containere individual
### Monitoring
docker run -it --rm \
  -v $(pwd)/data/logs:/data \
  -e INTERVAL=2 \
  --name monitor_test \
  system-monitor

### Backup
docker run -it --rm \
  -v $(pwd)/data/logs:/data \
  -v $(pwd)/data/backups:/backup \
  -e BACKUP_INTERVAL=3 \
  -e WATCH_FILE=/data/system-state.log \
  -e BACKUP_DIR=/backup \
  --name backup_test \
  system-backup

Rulare cu Docker Compose
docker compose up --build


Verifică loguri:

docker compose logs -f monitor
docker compose logs -f backup


Oprește containerele:

docker compose down

Volumes în Compose

logdata → /data (monitor → backup)

backups → /backup (backup container)

Compose creează automat volumele named.

7. Verificare fișiere generate
### Log-ul curent
docker compose exec monitor ls -l /data
docker compose exec monitor cat /data/system-state.log

###  Backup-uri
docker compose exec backup ls -l /backup

8. Notă

Intervalele de monitorizare și backup pot fi modificate prin variabilele de mediu:

INTERVAL → monitor
BACKUP_INTERVAL → backup
