# 🌍 MioIP.info - The Frictionless Network & IP Data API

[![API Status](https://img.shields.io/badge/API-Online-success)](#) [![Pricing](https://img.shields.io/badge/Pricing-100%25%20Free-blue)](#) [![Rate Limit](https://img.shields.io/badge/Rate%20Limit-100%2Fmin-orange)](#)

MioIP is a lightning-fast, zero-friction IP and Network Data API built specifically for developers. 

**No API keys. No registration. No limits on features.** Just a simple `curl` command.

📖 **[Read the Full API Documentation](https://mioip.info/docs)**

---

## 🚀 Quickstart

Get your public IP (Plain Text):
```bash
curl mioip.info
```
Get full JSON details for your IP:
```bash 
curl mioip.info/api/
 ```
Get a specific field (e.g., your current ASN):
```bash
curl mioip.info/api/asn
 ```
Lookup any IP address:
```bash
curl mioip.info/api/8.8.8.8
 ```
## ✨ Features
- Zero Auth: No tokens or API keys required.
- Network Insights: Get IPv4/IPv6, ASN, ISP, and essential location data.
- Granular Requests: Ask only for the data you need (e.g., /api/{ip}/country).
- Smart Routing: Force IPv4 (ipv4.mioip.info) or IPv6 (ipv6.mioip.info).
- Validation: Check if an IP is private, reserved, or bogon (/api/validate/{ip}).
- Multiple Formats: Support for JSON (default), Plain Text, XML, and CSV.

## 🛠️ Usage Examples

### Bash / Shell Scripting:

```bash
# Save current country code to a variable
COUNTRY=$(curl -s mioip.info/api/country_code)
if [ "$COUNTRY" = "IT" ]; then
    echo "Benvenuto dall'Italia!"
fi
```
### Python:

```bash
python
import requests
ip_data = requests.get('https://mioip.info/api/8.8.8.8').json()
print(f"Network ISP is {ip_data['network']['isp']}")
```
## ⚖️ Rate Limits

To keep the service fast and free for everyone, we enforce a generous limit of 100 requests per minute per source IP, with a burst of 20 extra requests. Exceeding this will return HTTP 429 Too Many Requests.
 - [Visit MioIP.info](https://mioip.info)
