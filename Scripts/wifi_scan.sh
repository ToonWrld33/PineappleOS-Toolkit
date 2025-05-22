#!/bin/bash

### PineappleOS WiFi Recon — Multi-Channel WiFi Scanner
### Replaces PineAP GUI functionality via Terminal Interface

LOG_FILE="/sd/pineappleos/logs/wifi_scan.log"
RAW_FILE="/tmp/wifi_scan.raw"
CLEAN_FILE="/sd/pineappleos/logs/wifi_clients.list"

# Automatically detect first active wireless interface
iface=$(iw dev | awk '/Interface/ {print $2}' | head -n 1)

if [[ -z "$iface" ]]; then
  echo "[-] No active wireless interfaces detected. Please check your connections."
  exit 1
fi

show_banner() {
  clear
  echo "╔════════════════════════════════════════════════════╗"
  echo "║         PineappleOS Terminal WiFi Recon Tool       ║"
  echo "╠════════════════════════════════════════════════════╣"
  echo "║ Multi-channel scanning | Signal & Security details ║"
  echo "║ Results logged and parsed directly in Terminal     ║"
  echo "╚════════════════════════════════════════════════════╝"
}

scan_wifi() {
  echo ""
  echo "[*] Initiating WiFi scan on interface: $iface"
  echo "[*] Results will be stored at: $LOG_FILE"
  echo ""

  rm -f "$LOG_FILE" "$RAW_FILE" "$CLEAN_FILE"

  for sweep in 1 2 3; do
    echo "[*] Performing sweep #$sweep..."
    iw dev "$iface" scan >> "$RAW_FILE" 2>/dev/null
    sleep 1
  done

  awk '
  BEGIN {
    print "╭───────────────────────────────────────────────────────────────────────╮"
    printf "│ %-20s %-17s %-4s %-6s %-7s %-7s │\n", "SSID", "BSSID", "CH", "BAND", "SEC", "SIGNAL"
    print "├───────────────────────────────────────────────────────────────────────┤"
  }

  function freq_to_channel(freq) {
    if (freq >= 2412 && freq <= 2472) return (freq - 2407)/5
    if (freq == 2484) return 14
    if (freq >= 5180 && freq <= 5825) return (freq - 5000)/5
    return "?"
  }

  function freq_band(freq) {
    if (freq >= 2400 && freq < 2500) return "2.4GHz"
    if (freq >= 5000 && freq < 6000) return "5GHz"
    return "UNK"
  }

  /BSS / { mac=$2; gsub(/\(.*$|[(),]/, "", mac); ssid="[HIDDEN]" }
  /freq:/ { ch=freq_to_channel($2); band=freq_band($2) }
  /signal:/ { sig=$2 " dBm" }
  /RSN:/ || /WPA:/ { sec="WPA" }
  /WEP/ { sec="WEP" }
  /SSID:/ {
    if ($2 != "") ssid = substr($0, index($0,$2))
    if (sec == "") sec="OPEN"
    printf "│ %-20s %-17s %-4s %-6s %-7s %-7s │\n", ssid, mac, ch, band, sec, sig
    printf "%s,%s,%s\n", ssid, mac, ch > "'$CLEAN_FILE'"
    sec=""
  }

  END { print "╰───────────────────────────────────────────────────────────────────────╯" }
  ' "$RAW_FILE" | tee "$LOG_FILE"
}

main_menu() {
  show_banner

  echo ""
  echo "╔════════════════════════════════════════════╗"
  echo "║              Select Scan Option            ║"
  echo "╠════════════════════════════════════════════╣"
  echo "║ [1] Single Scan                            ║"
  echo "║ [2] Continuous Scan (Ctrl+C to stop)       ║"
  echo "║ [0] Exit                                   ║"
  echo "╚════════════════════════════════════════════╝"
  echo ""
  read -p "Selection: " choice

  case "$choice" in
    1)
      scan_wifi
      pause_return
      ;;
    2)
      while true; do
        show_banner
        scan_wifi
        sleep 5
      done
      ;;
    0)
      echo "Exiting WiFi Recon Tool..."
      sleep 1
      clear
      ;;
    *)
      echo "Invalid selection. Please try again." && sleep 1
      main_menu
      ;;
  esac
}

pause_return() {
  echo ""
  read -p "Press enter to return to the main menu..."
  main_menu
}

main_menu

