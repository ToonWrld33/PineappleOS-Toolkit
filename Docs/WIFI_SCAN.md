📶 **PineappleOS WiFi Recon Setup**

This guide covers the installation, configuration, and usage of the **WiFi Recon** script (**wifi_recon.sh**) for PineappleOS, enabling detailed wireless scanning directly from your terminal.

---

📌 **Prerequisites**

Ensure your Pineapple device is set up with:

- Pineapple device flashed and configured according to [ShurkenHacks’ Mangoapple Guide](https://github.com/SHUR1K-N/WiFi-Mangoapple-Resources).
- An SD card mounted at `/sd`.
- `iw` package installed (pre-installed on most WiFi Pineapple setups).

---

🔧 **Installation Steps**

**1. Copy WiFi Recon Script**

Create and configure the script directly on your Pineapple terminal:

```bash
nano /sd/usr/bin/wifi_recon.sh
# Paste the contents of the script from:
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/wifi_scan.sh
chmod +x /sd/usr/bin/wifi_recon.sh
```

**2. Wireless Interface Configuration**

The script automatically selects an active wireless interface (`wlan*`).  
No manual configuration is needed unless you explicitly wish to use a specific interface.

To manually set a specific interface (optional):

```bash
nano /sd/usr/bin/wifi_recon.sh
```

Change this line:

```bash
iface=$(iw dev | awk '$1=="Interface"{print $2; exit}')
```

Replace with a specific interface, e.g.:

```bash
iface="wlan1"
```

---

🚀 **Running the Script**

Run the WiFi Recon script using:

```bash
/sd/usr/bin/wifi_recon.sh
```

You’ll be presented with these options:

- `[1] Single Scan`: Conducts one-time WiFi network scan.
- `[2] Continuous Scan`: Performs repeated scans every 5 seconds (`Ctrl+C` to exit).
- `[0] Exit`: Quit the script.

---

📋 **Interpreting Scan Results**

The WiFi scan provides a detailed table:

| Column | Description                                |
|--------|--------------------------------------------|
| SSID   | Network name (or "[HIDDEN]")               |
| BSSID  | MAC address of the Access Point            |
| CH     | WiFi channel                               |
| BAND   | Frequency (2.4GHz or 5GHz)                 |
| SEC    | Security method (OPEN, WPA, WEP)           |
| SIGNAL | Signal strength (in dBm)                   |

**Output files created by the script:**

- Raw scan data: `/sd/pineappleos/logs/strix.raw`
- CSV format: `/sd/pineappleos/logs/souls.list`

---

🛠 **Troubleshooting**

- **Issue:** No WiFi networks detected:
  - Ensure a wireless interface is active (`iw dev` to check available interfaces).
  - Restart the interface:
    ```bash
    ip link set wlan0 down
    ip link set wlan0 up
    ```

- **Issue:** Script permission problems:
    ```bash
    chmod +x /sd/usr/bin/wifi_recon.sh
    ```

---

📚 **Additional Information**

- All scan logs are saved in `/sd/pineappleos/logs`.
- Ensure `iw` is installed (default with PineappleOS).

---

🎯 **You're now set for efficient WiFi recon using PineappleOS!**
