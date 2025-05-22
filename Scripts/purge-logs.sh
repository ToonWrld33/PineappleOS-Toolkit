#!/bin/bash

### Log Purge Utility — Controlled Log Erasure
LOG_DIR="/sd/pineappleos/logs"

pause_return() {
  echo ""
  read -p "Press enter to begin the log purge..."
}

# Display utility banner
clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                 Log Purge Utility                          ║"
echo "║     Permanently deletes everything in $LOG_DIR             ║"
echo "╚════════════════════════════════════════════════════════════╝"

pause_return

# Countdown
for i in {3..1}; do
  echo "Purging logs in $i..."
  sleep 1
done

# Perform the log purge
rm -rf "$LOG_DIR"/*

echo ""
echo "Log purge complete. All logs deleted."
sleep 2

