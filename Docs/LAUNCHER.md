# 📖 PineappleOS Launcher Setup

This guide walks you through setting up and using the PineappleOS launcher, a central menu to easily manage and execute your PineappleOS scripts.

---

## 📌 Prerequisites

Before setting up the launcher, ensure you have:

* Configured your Pineapple device according to [SETUP.md](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/SETUP.md).
* Installed and configured all required scripts:

  * [TOR\_SETUP.md](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/TOR_SETUP.md)
  * [SYSTEM\_STATUS.md](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/SYSTEM_STATUS.md)
  * [NETWORK\_MANAGER.md](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/NETWORK_MANAGER.md)
  * [WIFI\_SCAN.md](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/WIFI_SCAN.md)
  * [WIFI\_DEAUTH.md](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/WIFI_DEAUTH.md)
  * [PURGE\_LOGS.md](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/PURGE_LOGS.md)

---

## 🔧 Installation Steps

1. **Create Launcher Script:**

```bash
nano /sd/usr/bin/pineappleos
# Paste the contents of the script from
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/pineappleos
chmod +x /sd/usr/bin/pineappleos
```

Ensure the launcher script (`pineappleos.sh`) is copied exactly as provided from your repository.

---

## 🚀 Running the Launcher

You can now run the launcher from anywhere by typing:

```bash
pineappleos
```

This will display the launcher menu with options:

* `1) Tor Setup & Management`
* `2) System Status Check`
* `3) Network Management`
* `4) WiFi Network Scan`
* `5) WiFi Deauthentication Attack`
* `6) Log Purge Utility`
* `0) Exit Launcher`

---

## 📚 Additional Information

* Ensure all scripts (`tor-launcher.sh`, `system-status.sh`, `network-manager.sh`, `wifi_scan.sh`, `deauth.sh`, and `purge-logs.sh`) are installed exactly as documented for optimal functionality.

---

🎯 Your PineappleOS launcher is ready for streamlined access and efficient management of your toolkit!
