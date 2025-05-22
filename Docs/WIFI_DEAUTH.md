# 📡 WiFi Deauthentication Tool Setup

This guide covers the setup and usage of the WiFi Deauthentication script (`deauth.sh`) on your DIY WiFi Pineapple device. It enables targeted WiFi deauthentication attacks directly from your terminal, useful for network penetration testing and security auditing.

---

## 📌 Prerequisites

Before running the script, ensure your device meets these requirements:

- Pineapple device flashed and configured according to [ShurkenHacks’ Guide](https://github.com/SHUR1K-N/WiFi-Mangoapple-Resources).
- An SD card mounted at `/sd`.
- The `mdk4` package installed:
  ```bash
  opkg update
  opkg -d sd install mdk4
  ```
- A WiFi adapter supporting monitor mode and packet injection (e.g., Hak5 MK7AC, Alfa adapters, or similar).
- Successful execution of the [`wifi_scan.sh`](./wifi_scan.sh) script (required for target selection).

---

## 🔧 Installation Steps

### Copy Deauthentication Script

Create and configure the script on your Pineapple device:

```bash
nano /sd/usr/bin/deauth.sh
# Paste the contents of the script from:
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/deauth.sh
chmod +x /sd/usr/bin/deauth.sh
```

---

## 🚀 Running the Script

Execute the script by typing:

```bash
/sd/usr/bin/deauth.sh
```

This will:

- Display networks from your latest WiFi scan (`wifi_scan.sh`).
- Allow selection of a target network for the deauth attack.
- Automatically set your chosen WiFi interface into monitor mode.
- Perform a targeted deauthentication attack against the selected network.

---

## ✅ Testing & Validation

- Run the WiFi scan first:
  ```bash
  /sd/usr/bin/wifi_scan.sh
  ```
- Verify listed networks and select the target network within the Deauth tool.

---

## 🛠 Troubleshooting

- **No interfaces shown**: Ensure your WiFi adapter supports packet injection.
- **Monitor mode fails**: Ensure no other interface is already in monitor mode.

---

## ⚠️ Important Notes

- **Dependency**: This script relies explicitly on successful scans performed by the included `wifi_scan.sh` script. Always run a fresh scan before initiating a deauthentication attack.
- Running this script will temporarily disable your Pineapple’s PineAP (typically `wlan1mon`) as only one interface can operate in monitor mode simultaneously. Your management AP remains unaffected.

---

🎯 You're now ready to test WiFi network resilience and security effectively with your Pineapple device!
