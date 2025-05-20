#!/sd/usr/bin/python3
import sys
sys.path.append('/sd/usr/lib/python3')

import requests
import time

# Use a fallback URL if none provided
url = sys.argv[1] if len(sys.argv) > 1 else "https://ifconfig.me"

# SOCKS5 proxy through Tor, with DNS tunneling enabled
proxies = {
    "http": "socks5h://127.0.0.1:9050",
    "https": "socks5h://127.0.0.1:9050"
}

headers = {
    "User-Agent": "Mozilla/5.0 (PineappleOS) Gecko/2025 TorStealth/1.0"
}

try:
    print(f"[+] Connecting to: {url}")
    start = time.time()
    response = requests.get(url, headers=headers, proxies=proxies, timeout=15)
    duration = round(time.time() - start, 2)

    # Exit if unexpected HTTP status
    if response.status_code != 200:
        print(f"[!] Unexpected HTTP status: {response.status_code}")
        sys.exit(1)

    print(f"[+] Status Code: {response.status_code}")
    print(f"[+] IP via Tor: {response.text.strip()}")
    print(f"[+] Response Time: {duration}s")

except requests.exceptions.RequestException as e:
    print(f"[!] Request error: {e}")
    sys.exit(1)

except Exception as e:
    print(f"[!] General error: {e}")
    sys.exit(1)

