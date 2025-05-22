📡 **PineappleOS System Status Script**

This document covers the setup and usage of the System Status script for PineappleOS, designed explicitly for your DIY WiFi Pineapple device. It provides an overview of critical system information, Tor status, storage, memory usage, and network details.

⸻

📌 **Prerequisites**

Before running the script, ensure your Pineapple device meets these requirements:

* Pineapple device flashed and configured according to [ShurkenHacks' Guide](https://github.com/SHUR1K-N/WiFi-Mangoapple-Resources).
* An SD card mounted at `/sd`.
* Tor setup completed following the Tor Installation & SOCKS5 Proxy Setup guide.

⸻

🔧 **Installation Steps**

**1. Install Coreutils Paste (Required)**

The script depends on the `paste` utility provided by coreutils. Install it via:

```bash
opkg update
opkg -d sd install coreutils-paste
cp /sd/usr/bin/gnu-paste /bin/paste
```

**2. Copy System Status Script**

Create and configure the script directly on your Pineapple:

```bash
nano /sd/usr/bin/system-status.sh
# Paste the contents of the script from:
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/system-status.sh
chmod +x /sd/usr/bin/system-status.sh
```

⸻

🚀 **Running the Script**

Execute the script by typing:

```bash
/sd/usr/bin/system-status.sh
```

This displays:

* Current date and time
* IP Address
* Active WiFi SSID
* Default Gateway
* DNS servers
* Tor service status (with exit IP verification)
* Storage usage on `/sd`
* Memory and CPU load
* Toolkit script count
* Last backup information (if applicable)

⸻

✅ **Testing & Validation**

To validate Tor status accuracy, start and verify using:

```bash
/sd/usr/bin/tor-launcher.sh
```

Re-run the status script to confirm accurate Tor status updates.

⸻

🛠 **Troubleshooting**

* **Script permission issue:**

```bash
chmod +x /sd/usr/bin/system-status.sh
```

* **Paste command missing:**
  Ensure you’ve correctly performed the coreutils-paste installation steps.

⸻

📚 **Additional Information**

* All logs and timestamps are stored in `/sd/pineappleos/logs`
* Backups should be tarballed and stored in `/sd/pineappleos/backups`

⸻

🎯 Now, you’re all set to monitor your PineappleOS system quickly and effectively!
