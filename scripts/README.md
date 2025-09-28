1.Monitoring (Shell Script)

Scriptul monitoring.sh:

Scrie la fiecare N secunde informații despre CPU, memorie, procese active, disk usage etc. în system-state.log.

Intervalul este configurabil cu variabila de mediu MONITOR_INTERVAL (default 5 secunde).

Suprascrie fișierul la fiecare rulare.

Excemplu de log : 

===== System State - Thu Aug 28 12:00:00 UTC 2025 =====
Hostname: monitor-container
Uptime: up 1 hour, 23 minutes
CPU Usage:
all  2.00  0.00  1.00 97.00  0.00  0.00
Memory Usage:
              total        used        free      shared  buff/cache   available
Mem:           992M        240M        500M         12M        252M        700M
Active Processes: 87
Disk Usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        30G   15G   15G  50% /
Top 5 Processes by CPU:
  PID COMMAND %CPU %MEM
  123 python   40.0  3.5
=================================
