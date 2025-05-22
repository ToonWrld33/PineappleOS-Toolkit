#!/bin/bash

### PineappleOS System Status — System Information & Status Check

pause_return() {
  echo ""
  read -p "Press enter to return..."
}

clear

# Top Banner
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                    🌙 PineappleOS System Status 🌙                   ║"
echo "║                 System Information & Status Check                    ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
sleep 1

# SECTION I — System Information
echo ""
echo "╔═⚡ SYSTEM INFORMATION ⚡═══════════════════════════════════════════════╗"
cast_time=$(date '+%Y-%m-%d — %H:%M:%S')
echo "║ ⚡ Current Time   : $cast_time"

echo -n "║ ⚡ IP Address     : "
ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | paste -sd ", " -

echo -n "║ ⚡ WiFi SSID      : "
iw dev | awk '$1=="Interface"{print $2}' | while read iface; do 
  ssid=$(iw dev "$iface" link | grep 'SSID' | awk -F 'SSID: ' '{print $2}')
  if [[ -n "$ssid" ]]; then
    echo "$ssid"
    break
  fi
done || echo "(Not connected)"

GW=$(ip route | grep default | awk '{print $3}')
echo "║ ⚡ Gateway        : ${GW:-Unavailable}"

echo -n "║ ⚡ DNS Servers    : "
awk '/^nameserver/ { print $2 }' /etc/resolv.conf | paste -sd ", " -
echo "╚══════════════════════════════════════════════════════════════════════╝"

# SECTION II — Tor Status
echo ""
echo "╔═🔒 TOR STATUS 🔒══════════════════════════════════════════════════════╗"
LOG_DIR="/sd/pineappleos/logs"
UPTIME_FILE="$LOG_DIR/tor_active.timestamp"
SESSION_LOG="$LOG_DIR/tor_sessions.log"
IP_CACHE="$LOG_DIR/tor_exit_ip.txt"

# Explicitly verify Tor process
if pgrep -f "/sd/usr/sbin/tor -f /sd/etc/tor/torrc" > /dev/null; then
  echo "║ 🔒 Tor Status     : ACTIVE"
else
  echo "║ 🔒 Tor Status     : INACTIVE"
fi

if [[ -f "$UPTIME_FILE" ]]; then
  START_EPOCH=$(cat "$UPTIME_FILE" | tr -d '[:space:]')
  LAST_CAST=$(date -d "@$START_EPOCH" '+%Y-%m-%d %H:%M:%S')
  echo "║ 🔒 Last Started   : $LAST_CAST"
else
  echo "║ 🔒 Last Started   : Unknown"
fi

if [[ -f "$IP_CACHE" ]]; then
  EXIT_IP=$(cat "$IP_CACHE" | tr -d '[:space:]')
  echo "║ 🔒 Exit IP        : $EXIT_IP"
else
  echo "║ 🔒 Exit IP        : Unknown"
fi

echo "╚══════════════════════════════════════════════════════════════════════╝"

# SECTION III — System Pulse
echo ""
echo "╔═💻 SYSTEM PULSE 💻════════════════════════════════════════════════════╗"
if mount | grep -q "/sd"; then
  echo "║ 💻 /sd Storage    : $(df -h /sd | awk 'NR==2 {print $3 " used of " $2}')"
else
  echo "║ 💻 /sd Storage    : Not mounted"
fi

MEM_USED=$(free -h | awk '/Mem:/ {print $3}')
MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
echo "║ 💻 Memory         : $MEM_USED used of $MEM_TOTAL"

LOAD=$(cut -d ' ' -f1-3 /proc/loadavg)
echo "║ 💻 CPU Load Avg   : $LOAD"
echo "╚══════════════════════════════════════════════════════════════════════╝"

# SECTION IV — Pineapple Toolkit Information
echo ""
echo "╔═📜 TOOLKIT INFORMATION 📜════════════════════════════════════════════╗"
script_count=$(find /sd/usr/bin -type f -name '*.sh' | wc -l)
echo "║ 📜 Scripts Loaded : $script_count scripts in /sd/usr/bin"

BACKUP_DIR="/sd/pineappleos/backups"
last_backup=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -n1)
[[ -n "$last_backup" ]] && echo "║ 📜 Last Backup    : $(basename "$last_backup")" || echo "║ 📜 Last Backup    : No backups found"
echo "╚══════════════════════════════════════════════════════════════════════╝"

pause_return

