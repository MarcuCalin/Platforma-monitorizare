#!/bin/bash

# Script bash pentru monitorizarea resurselor sistemului.

#Fisiserul de log

LOGFILE="system-state.log"

INTERVAL=${INTERVAL:-5} # daca e setata o sa foloseasca valoarea variabilii de mediu daca nu valoarea implicita e 5 

while true; do
    {
        echo "===================== SYSTEM STATE ====================="
        echo "Timestamp      : $(date +"%Y-%m-%d %H:%M:%S")"
        echo "Hostname       : $(hostname)"
        echo "Uptime         : $(uptime -p)"
        echo "Load Average   : $(uptime | awk -F'load average:' '{print $2}')"
        echo
        echo "--- CPU ---"
        mpstat 1 1 | awk '/Average/ && $12 ~ /[0-9.]+/ {print "CPU Usage     : " 100-$12"%"}'
        echo
        echo "--- MEMORY ---"
        free -h | awk 'NR==2{printf "Used/Total    : %s/%s (%.2f%%)\n", $3,$2,$3*100/$2 }'
        echo
        echo "--- PROCESSES ---"
        echo "Total processes: $(ps -e --no-headers | wc -l)"
        echo "Top 5 CPU consuming processes:"
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
        echo
        echo "--- DISK USAGE ---"
         df -h | awk 'NR==1{printf "%-20s %-10s %-10s %-8s %-10s\n", $1,$2,$3,$5,$6}
                      NR>1{printf "%-20s %-10s %-10s %-8s %-10s\n", $1,$2,$3,$5,$6}'
        echo
        echo "--- NETWORK ---"
        ip -4 addr show | grep inet | awk '{print "IP Address    : "$2 " (" $NF ")"}'
        echo "========================================================"
    } > "$LOGFILE"

    sleep "$INTERVAL"
done
