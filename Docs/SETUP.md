# 📡 Device & Firmware Setup

This guide outlines the initial setup required for your WiFi Pineapple Clone. Follow these instructions carefully to ensure compatibility with the provided scripts.

---

## 📌 Recommended Preparation

Before proceeding, it's highly recommended you follow ShurkenHacks' comprehensive tutorials and videos on GitHub:

* [WiFi Mangoapple Resources by SHUR1K-N](https://github.com/SHUR1K-N/WiFi-Mangoapple-Resources)

If you've already completed this setup, proceed to the next section.

---

## 🔧 Initial Device Configuration (if not already configured)

### 🌐 Step 1: Connect Device to Internet

Use the WiFi Pineapple GUI to explicitly connect your device to the internet via Network settings.

---

### 🔑 Step 2: SSH into Pineapple

SSH into your device explicitly with:

```bash
ssh root@172.16.42.1
```

---

### 💾 Step 3: Format and Prepare SD Card

Format your SD card explicitly with:

```bash
wpc-tools format_sd
```

If the SD card is not detected, install required packages explicitly:

```bash
opkg update
opkg install kmod-usb-storage-uas
wpc-tools format_sd
```

Check the contents of `/sd`:

```bash
cd /sd
ls -l
```

If there are existing files, clear them explicitly:

```bash
rm -rf *
ls -l
```

Ensure explicitly that `/sd` is empty before proceeding.

---

### 📦 Step 4: Verify Missing Packages

Explicitly verify missing packages with:

```bash
cd ../
wpc-tools missing_packages
```

---

## ✅ Setup Complete!

Your WiFi Pineapple is now properly configured and ready for script installations.

Proceed with the individual script setups in the following order for optimal results:

1. [**Tor Setup & SOCKS5 Proxy**](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/TOR_SETUP.md)
2. [**System Status Script**](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/SYSTEM_STATUS.md)
3. [**Network Manager**](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/NETWORK_MANAGER.md)
4. [**WiFi Scanner**](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/WIFI_SCAN.md) *(prerequisite for Deauth script)*
5. [**WiFi Deauthentication Tool**](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/WIFI_DEAUTH.md)
6. [**Logs Purge Utility**](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/PURGE_LOGS.md)
7. [**PineappleOS Launcher**](https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Docs/LAUNCHER.md) *(requires all previous scripts)*
