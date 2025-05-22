# 🌐 PineappleOS Network Manager Script

This guide covers the installation and usage of the **Network Manager** script for your PineappleOS Toolkit, enabling efficient management of WiFi connections, network interfaces, MAC addresses, and providing valuable network-related tools directly from your terminal.

---

## 📌 Prerequisites
Ensure the following are completed before installing:
- Your WiFi Pineapple Clone is set up according to [ShurkenHacks' Guide](https://github.com/SHUR1K-N/WiFi-Mangoapple-Resources).
- SD card correctly mounted at `/sd`.

---

## 🔧 Installation Steps

**1. Copy Network Manager Script**  
Create and configure the script directly on your Pineapple:
```bash
nano /sd/usr/bin/network-manager.sh
# Paste the contents of the script from:
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/network-manager.sh
chmod +x /sd/usr/bin/network-manager.sh
```

---

## 🚀 Running the Script

Run the Network Manager from your terminal:
```bash
/sd/usr/bin/network-manager.sh
```

### Main features:
- **WiFi Client Management**
  - Scan and connect to available WiFi networks.
  - DHCP automatic IP configuration.
- **Interface Management**
  - Bring network interfaces up/down.
  - Display detailed interface information.
- **Network Diagnostics**
  - Show connection details and routing information.
  - Ping hosts to verify connectivity.
  - Update IEEE OUI lists for MAC address identification.
- **MAC Address Management**
  - Display, randomize, and restore original MAC addresses.
  - OUI lookups directly from your Pineapple.
- **Easy Disconnect**
  - Quickly disconnect WiFi interfaces individually.

---

## ✅ Validation & Testing

- **Connect to WiFi:**
  - Run the script, select `WiFi Client Mode`, and follow prompts to scan and connect.
- **Disconnect from WiFi:**
  - Choose the `Disconnect WiFi` option to terminate connection on selected interfaces.
- **Test MAC Tools:**
  - Verify MAC address randomization and restoration under `MAC Address Tools`.

---

## 🛠 Troubleshooting

- **Permission Issues:**  
Ensure script execution rights:
```bash
chmod +x /sd/usr/bin/network-manager.sh
```

- **WiFi Connection Fails:**  
Check password correctness and signal strength. Retry after moving closer to the access point or confirming credentials.

- **MAC Lookup Issues:**  
Make sure your OUI list is updated:
```bash
mkdir -p /sd/usr/bin
wget -O /sd/usr/bin/oui_list.txt "https://standards-oui.ieee.org/oui/oui.txt"
```

---

## 📚 Additional Information
- IEEE OUI lists are stored at `/sd/usr/bin/oui_list.txt`.
- Temporary WPA configurations created at `/tmp/wpa.conf` for each session.

---

🎯 Your PineappleOS now has powerful and convenient network management at your fingertips!
