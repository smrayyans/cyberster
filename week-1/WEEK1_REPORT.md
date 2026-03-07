# Cyberster Red Team Internship - Week 1 Report

## Candidate Information
- **Name:** Syed Muhammad Rayyan
- **Roll No:** CSI-BI-620
- **Program:** Cyberster Internship
- **Team:** Red Team
- **Task Title:** Advanced Recon and Attack Surface Mapping
- **Engagement Type:** Passive Reconnaissance (Training)

## 1. Executive Summary
This Week 1 submission documents a full reconnaissance workflow designed to map an organization's visible attack surface while remaining in passive or low-risk active recon boundaries. The approach is based on the internship tutorial (`task+tut.pptx`) and report inspiration (`inspo-1.pdf`).

### Key Outcomes
- Built a consolidated target asset list from multiple data sources.
- Validated why cross-tool verification is critical for accuracy.
- Documented infrastructure fingerprints (DNS, hosting clues, technology stack).
- Performed dork-based checks for common exposure patterns.
- Filtered non-responsive assets and highlighted live targets for visual recon.

## 2. Methodology Overview
The workflow was executed in four phases:

1. **Task 01 - Passive OSINT and Subdomain Enumeration**
- Tools: `subfinder`, `assetfinder`, `amass`, `DNSDumpster`, `crt.sh`
- Output: unified subdomain list (`master_subdomains.txt` / `attack_surface.txt`)

2. **Task 02 - Infrastructure and Technology Profiling**
- Tools: `whatweb`, `whois`, `nslookup`, `dig`, Google dorks
- Output: technology and infrastructure profile

3. **Task 03 - GitHub Dorking and Credential Leak Checks**
- Technique: GitHub code search + targeted secret patterns
- Output: leak validation summary with risk notes

4. **Task 04 - Live Asset Filtering and Visual Recon**
- Tools: `httpx` or `httprobe`, `aquatone` or `gowitness`
- Output: live host inventory and screenshot evidence

## 3. Task 01 - Passive OSINT and Subdomain Enumeration

### Objective
Discover target assets without intrusive scanning and build a high-confidence domain inventory.

### Commands (Reference Workflow)
```bash
subfinder -d target.com -silent -o subfinder.txt
assetfinder --subs-only target.com > assetfinder.txt
amass enum -passive -d target.com -o amass.txt
cat subfinder.txt assetfinder.txt amass.txt | sort -u > master_subdomains.txt
wc -l master_subdomains.txt
sort subfinder.txt assetfinder.txt amass.txt | uniq -c | sort -nr | head
```

### SSL and Historical Discovery
```bash
# crt.sh style extraction (example script usage from tutorial)
crt_v2.sh -d target.com > crt_target.txt

# DNSDumpster exported xlsx conversion
xlsx2csv dnsdumpster.xlsx > dnsdump.csv
grep -oE "[a-zA-Z0-9.-]+\.target\.com" dnsdump.csv | sort -u > dnsdump.txt
cat master_subdomains.txt dnsdump.txt crt_target.txt | sort -u > attack_surface.txt
```

### Why This Matters
- No single tool has complete visibility.
- Overlap count increases confidence in discovered assets.
- Historical certificate data can expose forgotten environments.

## 4. Task 02 - Infrastructure and Technology Profiling

### Objective
Identify technology stack, DNS architecture, hosting patterns, and potential weak points in exposed services.

### Commands (Reference Workflow)
```bash
whatweb https://sub.target.com > tech.txt
whois target.com > whois.txt
nslookup target.com > dns.txt
nslookup -type=A target.com >> dns.txt
nslookup -type=MX target.com >> dns.txt
nslookup -type=NS target.com >> dns.txt
nslookup -type=TXT target.com >> dns.txt
# Optional
dig target.com ANY
```

### Google Dorking Samples
```text
site:target.com inurl:phpinfo.php
site:target.com filetype:env
site:target.com inurl:robots.txt
site:target.com filetype:bak
site:target.com filetype:zip
site:target.com intitle:"index of"
```

### Expected Findings Template
- Web server fingerprint and response headers.
- Framework/CMS clues.
- CDN/reverse proxy indicators.
- DNS records (A, MX, NS, TXT).
- Potential sensitive files indexed by search engines.

## 5. Task 03 - GitHub Dorking and Credential Leak Validation

### Objective
Check public repositories for hardcoded credentials, tokens, and sensitive configuration leaks.

### GitHub Dork Queries (Examples)
```text
org:targetorg "API_KEY"
org:targetorg "PASSWORD"
org:targetorg "AWS_SECRET"
"target.com" "API_KEY"
filename:.env "target"
filename:config "DB_PASSWORD"
filename:settings.py "SECRET_KEY"
extension:json "apiKey"
```

### Commit History Checks
```bash
git log -p
git grep -i "password" $(git rev-list --all)
git log -S "API_KEY" --all
```

### Analysis Principles
- Differentiate test/demo keys from real secrets.
- Validate if values are active-looking and contextually sensitive.
- Check historical commits because deletion does not remove history.

## 6. Task 04 - Live Asset Filtering and Visual Recon

### Objective
Reduce noise by isolating active web assets and producing visual recon evidence.

### Commands (Reference Workflow)
```bash
cat attack_surface.txt | httprobe --prefer-https > live-urls.txt
# or
cat attack_surface.txt | httpx -status-code -title -tech-detect -o live-httpx.txt

cat live-urls.txt | aquatone -out ./aquatone_results
# or
gowitness file -f live-urls.txt --screenshot-path ./gowitness_screenshots
```

### Reporting Requirements
- Total assets discovered.
- Total live assets.
- Interesting login/admin/dev panels.
- Notable exposed directories or unusual responses.

## 7. Screenshot Evidence Mapping
The internship workflow accepts placeholder style references like `{1.png}`. Below is the rendered mapping.

- Placeholder: `{1.png}`
- Source file: `screenshots/1.png`

![Recon Evidence 1](screenshots/1.png)

> Add more evidence using the same pattern:
> - Placeholder: `{2.png}` -> `screenshots/2.png`
> - Placeholder: `{3.png}` -> `screenshots/3.png`

## 8. Professional Observations
- Passive recon quality depends on source diversity and normalization.
- Asset overlap ranking helps prioritize high-confidence hosts.
- Infrastructure context (ASN, MX, NS, CDN) improves threat modeling.
- Visual recon accelerates triage for high-value endpoints.

## 9. Conclusion
Week 1 established a structured recon baseline aligned with red team tradecraft: discover, validate, profile, and prioritize. The final output is a clear attack surface map that supports later phases of assessment while staying inside authorized training boundaries.

## 10. Disclaimer
This report documents educational and authorized training activities only. No exploitation steps are included.
