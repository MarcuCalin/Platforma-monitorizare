# Script Python pentru efectuarea backup-ului logurilor de sistem.

import os
import time
import shutil
from datetime import datetime

INTERVAL = int(os.getenv("BACKUP_INTERVAL", 5))
BACKUP_DIR = os.getenv("BACKUP_DIR", "backup")
LOG_FILE = "system-state.log"

os.makedirs(BACKUP_DIR, exist_ok=True)

last_modified = None

while True:
    try:
        if os.path.exists(LOG_FILE):
            current_modified = os.path.getmtime(LOG_FILE)

            if last_modified is None or current_modified != last_modified:
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                backup_file = os.path.join(BACKUP_DIR, f"system-state_{timestamp}.log")

                shutil.copy2(LOG_FILE, backup_file)
                print(f"[INFO] Backup created: {backup_file}")

                last_modified = current_modified
            else:
                print("[INFO] No changes detected, skipping backup.")
        else:
            print(f"[WARNING] Log file {LOG_FILE} does not exist yet.")

    except Exception as e:
        print(f"[ERROR] {e}")

    time.sleep(INTERVAL)
