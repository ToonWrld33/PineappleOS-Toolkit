#!/bin/bash

### Script: tor-launcher.sh
### Purpose: Launch Tor service, verify connection, and test SOCKS5 tunnel (PineappleOS)

TOR_BIN="/sd/usr/sbin/tor"
TOR_CONF="/sd/etc/tor/torrc"
LOG_DIR="/sd/pineappleos/logs"
PINEAPPLE_CONF="/sd/etc/pineappleos.conf"
UPTIME_FILE="$LOG_DIR/tor_active.timestamp"
SESSION_LOG="$LOG_DIR/tor_sessions.log"
IP_CACHE="$LOG_DIR/tor_exit_ip.txt"
TMP_OUTPUT="/tmp/tor_output"
TOR_LOG="/tmp/tor_boot.log"
FALLBACK="https://httpbin.org/ip"
SECONDARY="https://icanhazip.com"

mkdir -p "$LOG_DIR"

echo ""
echo "[*] Terminating existing Tor processes..."
killall tor 2>/dev/null

# Get the system name from Pineapple configuration (if exists)
if [[ -f "$PINEAPPLE_CONF" ]]; then
  SYSTEM_NAME=$(grep -x 'PINEAPPLE_NAME.*' "$PINEAPPLE_CONF" | cut -d'"' -f2)
else
  SYSTEM_NAME="PineappleOS"
fi

START_HUMAN=$(date '+%Y-%m-%d %H:%M:%S')
START_EPOCH=$(date +%s)
echo "$START_EPOCH" > "$UPTIME_FILE"
echo "[+] $START_HUMAN - Tor initiated by $SYSTEM_NAME" >> "$SESSION_LOG"

echo "[*] Launching Tor service..."
"$TOR_BIN" -f "$TOR_CONF" > "$TOR_LOG" 2>&1 &

echo -n "[*] Waiting for Tor to bootstrap..."
BOOT_TIMEOUT=30
for i in $(seq 1 $BOOT_TIMEOUT); do
  if grep -q "Bootstrapped 100%" "$TOR_LOG"; then
    echo -e "\n[+] Tor successfully bootstrapped."
    break
  fi
  echo -n "."
  sleep 1
done

if ! grep -q "Bootstrapped 100%" "$TOR_LOG"; then
  echo -e "\n[!] Warning: Tor may not be fully operational."
  echo "[!] Tor not fully bootstrapped after ${BOOT_TIMEOUT}s." >> "$SESSION_LOG"
fi

if ! ps | grep -q "[t]or"; then
  echo "[✘] Error: Tor process failed to start."
  echo "[!] Tor launch failed." >> "$SESSION_LOG"
  rm -f "$UPTIME_FILE"
  exit 1
fi

echo "[*] Testing SOCKS5 Tor tunnel..."
/sd/usr/bin/python3 /sd/usr/bin/tor_socks5.py "$FALLBACK" > "$TMP_OUTPUT" 2>&1
RESULT=$?

if [[ "$RESULT" -ne 0 ]]; then
  echo "[!] Primary test failed, attempting fallback..."
  /sd/usr/bin/python3 /sd/usr/bin/tor_socks5.py "$SECONDARY" > "$TMP_OUTPUT" 2>&1
  F_RESULT=$?

  if [[ "$F_RESULT" -eq 0 ]]; then
    echo "[+] Fallback connection succeeded." >> "$SESSION_LOG"
    grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$TMP_OUTPUT" > "$IP_CACHE"
  else
    echo "[✘] Both primary and fallback tests failed." >> "$SESSION_LOG"
  fi
else
  echo "[+] Primary connection succeeded." >> "$SESSION_LOG"
  grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$TMP_OUTPUT" > "$IP_CACHE"
fi

STOP_HUMAN=$(date '+%Y-%m-%d %H:%M:%S')
STOP_EPOCH=$(date +%s)
DURATION=$((STOP_EPOCH - START_EPOCH))
DURATION_FORMATTED=$(printf "%02d:%02d:%02d" $((DURATION/3600)) $((DURATION%3600/60)) $((DURATION%60)))

echo "[+] $STOP_HUMAN - Tor session ended (Duration: $DURATION_FORMATTED)" >> "$SESSION_LOG"

grep -F "[+]" "$SESSION_LOG" | tail -n 10 > "$SESSION_LOG.tmp" && mv "$SESSION_LOG.tmp" "$SESSION_LOG"

rm -f "$TMP_OUTPUT" "$TOR_LOG"

echo ""
echo "[✓] Tor service running. SOCKS5 tunnel ready."
exit 0

