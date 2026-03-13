# Cyberster

This repository contains the reports and findings from my Pentesting Internship.

## Weekly Overview

### [Week 1: Subdomain Enumeration & Reconnaissance](./week-1/)
Focused on passive information gathering and mapping the target's digital footprint.
- **Passive OSINT:** Utilized tools like `Subfinder`, `Assetfinder`, and `Amass` for subdomain discovery.
- **Infrastructure Profiling:** Performed technology fingerprinting using `WhatWeb`, `Wappalyzer`, and deep DNS/WHOIS analysis.
- **Dorking:** Executed Google and GitHub dorking to identify sensitive information leaks and exposed configuration files.
- **Asset Validation:** Filtered live assets using `httprobe`/`httpx` and conducted visual reconnaissance with `Aquatone`.

### [Week 2: Network Enumeration & Service Vulnerability Discovery](./week-2/)
Transitioned to active scanning to identify open ports, services, and potential vulnerabilities.
- **Advanced Nmap Scanning:** Performed various scan types including TCP Connect, SYN Stealth, and UDP scans with timing optimization.
- **Service Fingerprinting:** Identified exact service versions and performed aggressive scanning for OS detection.
- **Nmap Scripting Engine (NSE):** Leveraged automated scripts (Discovery, Safe, and Vuln categories) to detect misconfigurations and map findings to CVE IDs.
- **Firewall Evasion:** Practiced stealth techniques such as packet fragmentation, MTU manipulation, decoy scanning, and source port spoofing.

