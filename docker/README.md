# Monitor Dockerfile

Imagine de bază: debian:bookworm

Instalează sysstat și procps

Rulează system_monitor.sh

# Backup Dockerfile

Imagine de bază: python:3.11-slim

Rulează backup_script.py

# Docker Compose

Fișierul docker-compose.yml:

Definește două servicii: monitor și backup.

Ambele folosesc un volum comun logdata pentru system-state.log.

Serviciul backup are și un volum separat backups pentru fișierele de backup.

## Instrucțiuni de rulare : 

1. Build containere - docker-compose build
2. Pornire servicii - docker-compose up
3. Verifică logurile generate - docker logs monitor
docker logs backup
4. Verifică fișierul monitoring.sh - docker exec -it monitor cat /system-state.log
5. Verifică backup-urile - docker exec -it backup ls /backup

Variabile de mediu:

Serviciu	Variabilă	      Default	      Descriere
monitor	  MONITOR_INTERVAL	5	Interval  în secunde pentru colectare date sistem
backup	  BACKUP_INTERVAL	  5	Interval  în secunde pentru verificare și backup
backup	  BACKUP_DIR	      backup	    Directorul unde sunt stocate fișierele de backup
