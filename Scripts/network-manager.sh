#!/bin/bash

### PineappleOS Network Management Suite
### Bash-based Networking & Interface Control Toolkit

pause_return() {
  echo ""
  read -p "Press enter to return..."
}

wifi_client_menu() {
  while true; do
    clear
    echo "╔════════════════════════════════════════════════╗"
    echo "║             WiFi Client Mode Menu              ║"
    echo "╚════════════════════════════════════════════════╝"
    
    interfaces=($(iw dev | awk '/Interface/ {print $2}'))
    for i in "${!interfaces[@]}"; do
      echo "  $((i+1))) ${interfaces[$i]}"
    done
    echo "  0) Back"
    read -p "Select interface: " iface_choice

    [[ "$iface_choice" == "0" ]] && return
    iface="${interfaces[$((iface_choice-1))]}"
    [[ -z "$iface" ]] && echo "Invalid selection." && pause_return && continue

    echo "[*] Scanning available networks..."
    iw "$iface" scan | awk -F ': ' '/SSID:/ {print $2}' | sort -u > /tmp/ssid_list

    if [[ ! -s /tmp/ssid_list ]]; then
      echo "[!] No networks detected. Enter SSID manually."
      read -p "Enter SSID: " ssid
    else
      mapfile -t ssids < /tmp/ssid_list
      for i in "${!ssids[@]}"; do
        echo "  $((i+1))) ${ssids[$i]}"
      done
      echo "  0) Enter SSID manually"
      read -p "Choose network: " net_choice

      [[ "$net_choice" == "0" ]] && read -p "Enter SSID: " ssid || ssid="${ssids[$((net_choice-1))]}"
    fi

    read -p "WiFi Password (leave blank if open): " pass

    echo "[*] Creating wpa_supplicant config..."
    if [[ -z "$pass" ]]; then
      echo -e "network={\n\tssid=\"$ssid\"\n\tkey_mgmt=NONE\n}" > /tmp/wpa.conf
    else
      echo -e "network={\n\tssid=\"$ssid\"\n\tpsk=\"$pass\"\n}" > /tmp/wpa.conf
    fi

    echo "[*] Connecting to access point..."
    ifconfig "$iface" down
    sleep 1
    ifconfig "$iface" up
    sleep 1
    /usr/sbin/wpad wpa_supplicant -B -i "$iface" -c /tmp/wpa.conf
    sleep 2

    if iw dev "$iface" link | grep -q "Connected to"; then
      echo "[*] Successfully associated."
    else
      echo "[!] Association failed. Verify password or signal."
      pause_return
      continue
    fi

    echo "[*] Requesting IP via DHCP..."
    udhcpc -i "$iface" -q
    sleep 2

    echo "╔═════════════ IP Assignment ═════════════╗"
    ip addr show "$iface" | grep -q "inet " && {
      ip addr show "$iface" | grep "inet " | awk '{print "║ Assigned IP: " $2}'
    } || echo "║ [!] No IP assigned."
    echo "╚══════════════════════════════════════════╝"

    pause_return
  done
}

interface_actions_menu() {
  while true; do
    clear
    echo "╔════════════════════════════════════════════╗"
    echo "║            Interface Actions Menu          ║"
    echo "╠════════════════════════════════════════════╣"
    echo "║ [1] Bring Interface Up                     ║"
    echo "║ [2] Bring Interface Down                   ║"
    echo "║ [3] Show All Interfaces                    ║"
    echo "║ [0] Back                                   ║"
    echo "╚════════════════════════════════════════════╝"
    read -p "Select an option: " action

    case "$action" in
      1)
        read -p "Interface to bring up: " iface
        ifconfig "$iface" up && echo "[*] $iface is now up."
        ;;
      2)
        read -p "Interface to bring down: " iface
        ifconfig "$iface" down && echo "[*] $iface is now down."
        ;;
      3)
        echo "[*] Showing all interfaces:"
        ifconfig -a
        ;;
      0)
        return
        ;;
      *)
        echo "[!] Invalid selection."
        ;;
    esac
    pause_return
  done
}

info_tools_menu() {
  while true; do
    clear
    echo "╔════════════════════════════════════════════╗"
    echo "║            Information Tools Menu          ║"
    echo "╠════════════════════════════════════════════╣"
    echo "║ [1] Show Interface Info                    ║"
    echo "║ [2] Connection Status                      ║"
    echo "║ [3] Ping a Host                            ║"
    echo "║ [4] Update OUI List                        ║"
    echo "║ [0] Back                                   ║"
    echo "╚════════════════════════════════════════════╝"
    read -p "Select an option: " info

    case "$info" in
      1)
        read -p "Interface: " iface
        echo "[*] Interface configuration for $iface:"
        ifconfig "$iface"
        iwconfig "$iface" 2>/dev/null || echo "[!] No wireless info available."
        ;;
      2)
        echo "[*] Default route and DNS:"
        ip route show default
        cat /etc/resolv.conf
        echo "[*] Checking connectivity (pinging 1.1.1.1):"
        ping -c 3 1.1.1.1
        ;;
      3)
        read -p "Enter host to ping: " host
        ping -c 4 "$host"
        ;;
      4)
        echo "[*] Updating IEEE OUI list..."
        mkdir -p /sd/usr/bin
        if wget -O /sd/usr/bin/oui_list.txt "https://standards-oui.ieee.org/oui/oui.txt"; then
          echo "[✓] OUI list updated successfully."
        else
          echo "[!] Failed to update OUI list. Checking local file..."
          if [[ -f /sd/usr/bin/oui_list.txt ]]; then
            echo "[✓] Local OUI list found."
          else
            echo "[!] No local OUI list available."
          fi
        fi
        ;;
      0)
        return
        ;;
      *)
        echo "[!] Invalid selection."
        ;;
    esac
    pause_return
  done
}

mac_tools_menu() {
  while true; do
    clear
    echo "╔════════════════════════════════════════════╗"
    echo "║                 MAC Tools                  ║"
    echo "╠════════════════════════════════════════════╣"
    echo "║ [1] Show MAC Address                       ║"
    echo "║ [2] Randomize MAC Address                  ║"
    echo "║ [3] Restore Original MAC Address           ║"
    echo "║ [4] Lookup OUI from MAC Address            ║"
    echo "║ [0] Back                                   ║"
    echo "╚════════════════════════════════════════════╝"
    read -p "Choose an option: " macopt

    case "$macopt" in
      1)
        read -p "Interface: " iface
        echo "[*] MAC Address of $iface:"
        ifconfig "$iface" | grep ether || echo "[!] Interface not found or no MAC available."
        ;;
      2)
        read -p "Interface: " iface
        ifconfig "$iface" down
        newmac=$(hexdump -n6 -e '/1 ":%02X"' /dev/urandom | sed 's/^://')
        ifconfig "$iface" hw ether "$newmac"
        ifconfig "$iface" up
        echo "[✓] New MAC assigned: $newmac"
        ;;
      3)
        read -p "Interface: " iface
        ifconfig "$iface" down
        macchanger -p "$iface" 2>/dev/null || echo "[!] macchanger utility not installed."
        ifconfig "$iface" up
        ;;
      4)
        echo "[*] Updating IEEE OUI list..."
        mkdir -p /sd/usr/bin
        if wget -O /sd/usr/bin/oui_list.txt "https://standards-oui.ieee.org/oui/oui.txt"; then
          echo "[✓] OUI list updated successfully."
        else
          echo "[!] Failed to update OUI list. Checking local file..."
          if [[ -f /sd/usr/bin/oui_list.txt ]]; then
            echo "[✓] Local OUI list found."
          else
            echo "[!] No local OUI list available."
            pause_return
            continue
          fi
        fi

        read -p "Enter MAC prefix (e.g., 00:11:22): " macin
        grep -i "${macin//:/-}" /sd/usr/bin/oui_list.txt | head -n 5 || echo "[!] No matches found."
        ;;
      0)
        return
        ;;
      *)
        echo "[!] Invalid selection."
        ;;
    esac
    pause_return
  done
}

disconnect_wifi() {
  clear
  echo "╔════════════════════════════════════════════╗"
  echo "║             Disconnect WiFi                ║"
  echo "╚════════════════════════════════════════════╝"

  interfaces=($(iw dev | awk '/Interface/ {print $2}'))
  for i in "${!interfaces[@]}"; do
    echo "  $((i+1))) ${interfaces[$i]}"
  done

  echo "  0) Cancel"
  read -p "Select interface to disconnect: " d_choice

  [[ "$d_choice" == "0" ]] && return
  d_iface="${interfaces[$((d_choice-1))]}"

  if [[ -z "$d_iface" ]]; then
    echo "[!] Invalid selection."
    pause_return
    return
  fi

  # Targeted disconnection using wpa_cli (supported by wpad)
  wpa_cli -i "$d_iface" terminate 2>/dev/null
  kill "$(pgrep -f "udhcpc.*$d_iface")" 2>/dev/null
  ifconfig "$d_iface" down

  echo "[✓] Interface $d_iface disconnected and powered down."
  pause_return
}

while true; do
  clear
  echo "╔════════════════════════════════════════════╗"
  echo "║            PineappleOS Network Menu        ║"
  echo "╠════════════════════════════════════════════╣"
  echo "║ [1] WiFi Client Mode                       ║"
  echo "║ [2] Interface Actions                      ║"
  echo "║ [3] Information Tools                      ║"
  echo "║ [4] MAC Tools                              ║"
  echo "║ [5] Disconnect WiFi                        ║"
  echo "║ [0] Exit                                   ║"
  echo "╚════════════════════════════════════════════╝"
  read -p "Select an option: " choice

  case "$choice" in
    1) wifi_client_menu ;;
    2) interface_actions_menu ;;
    3) info_tools_menu ;;
    4) mac_tools_menu ;;
    5) disconnect_wifi ;;
    0) clear; exit ;;
    *) echo "[!] Invalid option selected." && sleep 1 ;;
  esac
done

