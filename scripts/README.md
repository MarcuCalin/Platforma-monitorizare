1.Monitoring (Shell Script)

Scriptul monitoring.sh:

Scrie la fiecare N secunde informații despre CPU, memorie, procese active, disk usage etc. în system-state.log.

Intervalul este configurabil cu variabila de mediu MONITOR_INTERVAL (default 5 secunde).

Suprascrie fișierul la fiecare rulare.

===================== SYSTEM STATE =====================
Timestamp      : 2025-09-28 09:33:45
Hostname       : Ubuntu2204
Uptime         : up 15 minutes
Load Average   :  1.16, 1.69, 1.35

--- CPU ---
CPU Usage     : 18.26%

--- MEMORY ---
Used/Total    : 2.3Gi/5.3Gi (43.40%)

--- PROCESSES ---
Total processes: 266
Top 5 CPU consuming processes:
    PID COMMAND         %CPU %MEM
  18207 code            39.4  5.2
  18457 code            38.1  6.0
   1907 java            24.0 10.9
  18169 code            13.3  2.7
  18244 code            12.7  3.8

--- DISK USAGE ---
Filesystem           Size       Used       Use%     Mounted   
tmpfs                547M       1.7M       1%       /run      
/dev/sda3            24G        22G        93%      /         
tmpfs                2.7G       32M        2%       /dev/shm  
tmpfs                5.0M       4.0K       1%       /run/lock 
/dev/sda2            512M       6.1M       2%       /boot/efi 
shared-with-host     953G       394G       42%      /home/eu/shared-with-host
tmpfs                547M       112K       1%       /run/user/1000
/dev/sr0             59M        59M        100%     /media/eu/VBox_GAs_7.1.8

--- NETWORK ---
IP Address    : 127.0.0.1/8 (lo)
IP Address    : 10.0.2.15/24 (enp0s3)
IP Address    : 192.168.1.133/24 (enp0s8)
IP Address    : 192.168.49.1/24 (br-046171c048bb)
IP Address    : 172.18.0.1/16 (br-1f32ccedd969)
IP Address    : 172.17.0.1/16 (docker0)
========================================================

2. Backup (Python Script)

Scriptul backup_script.py:

Verifică dacă system-state.log s-a modificat.

Dacă da, creează un fișier de backup în directorul configurat.

Numele fișierului de backup conține data și ora la care a fost creat.

Intervalul este configurabil cu variabila de mediu BACKUP_INTERVAL (default 5 secunde).

Directorul backup-urilor este configurabil cu variabila BACKUP_DIR (default backup).

Exemplu fișier backup:
