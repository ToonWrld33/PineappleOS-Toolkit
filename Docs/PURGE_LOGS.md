# 🗑 PineappleOS Log Purge Utility

This document covers the setup and usage of the **Log Purge Utility** for PineappleOS, designed to quickly and securely delete all logs stored on your WiFi Pineapple device at `/sd/pineappleos/logs`.

---

## 📌 Prerequisites

Ensure your Pineapple device meets the following requirements before running this utility:

- Pineapple device flashed and configured according to [ShurkenHacks' Guide](https://github.com/SHUR1K-N/WiFi-Mangoapple-Resources).
- An SD card correctly mounted at `/sd`.

---

## 🔧 Installation Steps

### Step 1: Copy the Script to Your Device

Create and configure the script directly on your Pineapple:

```bash
nano /sd/usr/bin/purge-logs.sh
# Paste the contents of the script from:
# https://github.com/ToonWrld33/PineappleOS-Toolkit/blob/main/Scripts/purge-logs.sh
chmod +x /sd/usr/bin/purge-logs.sh
```

---

## 🚀 Running the Utility

Execute the script by typing:

```bash
/sd/usr/bin/purge-logs.sh
```

The script will:

- Prompt you with a confirmation before proceeding.
- Perform a countdown prior to log deletion.
- Permanently delete all logs located at `/sd/pineappleos/logs`.

---

## 🛠 Troubleshooting

- **Permission issue**:  
  Ensure your script has executable permissions:
  ```bash
  chmod +x /sd/usr/bin/purge-logs.sh
  ```

- **Logs not deleting properly**:  
  Verify the logs path:
  ```bash
  ls -l /sd/pineappleos/logs
  ```
  Confirm the directory exists and contains logs before running the purge.

---

## ⚠️ Important

This utility permanently deletes logs. Ensure you have backed up any important logs or information before running this script.

---

🎯 **Your PineappleOS device is now equipped to quickly and securely purge logs!**
