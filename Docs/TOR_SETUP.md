# 📡 Tor Installation & SOCKS5 Proxy Setup

This guide walks you through setting up the Tor service and verifying a secure SOCKS5 proxy connection explicitly on your WiFi Pineapple Clone.

---

## 📌 Prerequisites

Ensure your Pineapple clone is configured according to the Mangoapple guide by [SHUR1K-N](https://github.com/SHUR1K-N/WiFi-Mangoapple-Resources).

---

## 🔧 Step 1: Install Required Packages

Run these commands on your Pineapple terminal:

```bash
opkg update
opkg -d sd install python3 python3-pip tor
```

---

## 🛠 Step 2: Configure Tor

Edit the Tor configuration file:

```bash
nano /sd/etc/tor/torrc
```

Locate and comment out the following line by adding two hashes (`##`):

```
##User tor
```

Save (`Ctrl + O`) and exit (`Ctrl + X`).

---

## 🐍 Step 3: Install Python Dependencies

Run the following command to install Python dependencies for SOCKS support:

```bash
/sd/usr/bin/pip3 install --target=/sd/usr/lib/python3 requests[socks]
```

---

## 📜 Step 4: Add the Tor Verification Script

Create the verification script:

```bash
nano /sd/usr/bin/tor_socks5.py
# Paste the contents of the script from:
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/tor_socks5.py
chmod +x /sd/usr/bin/tor_socks5.py
```

---

## 🚀 Step 5: Add the Tor Launcher Script

Create the Tor launcher Bash script:

```bash
nano /sd/usr/bin/tor-launcher.sh
# Paste the contents of the script from:
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/tor-launcher.sh
chmod +x /sd/usr/bin/tor-launcher.sh
```

---

## ✅ Step 6: Launch Tor and Verify SOCKS5 Proxy

Execute the launcher script:

```bash
/sd/usr/bin/tor-launcher.sh
```

The script will:

* Start Tor service.
* Verify Tor is fully bootstrapped.
* Confirm your external IP address via SOCKS5 through Tor.

---

## 📌 Final Check

To manually verify Tor is running and the SOCKS5 proxy is operational, run:

```bash
netstat -an | grep 9050
```

You should see Tor listening on `127.0.0.1:9050`.

To manually test the SOCKS5 connection and see your exit IP, run:

```bash
/sd/usr/bin/python3 /sd/usr/bin/tor_socks5.py https://httpbin.org/ip
```

---

## 📚 Additional Information

* All logs and timestamps are stored in `/sd/pineappleos/logs`.

You're now set with a secure Tor setup using SOCKS5 on your WiFi Pineapple!
