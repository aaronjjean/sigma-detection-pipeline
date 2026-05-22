# Sigma Detection Pipeline

> Detection-as-code pipeline covering 10 MITRE ATT&CK techniques drawn from real
> incident investigations (BlackCat/ALPHV, WannaCry, and APT log correlation).
> Every push to `rules/` automatically validates Sigma YAML syntax and converts
> each rule to both SPL (Splunk) and KQL (Microsoft Sentinel) via GitHub Actions.

![CI](https://github.com/YOUR_GITHUB_USERNAME/sigma-detection-pipeline/actions/workflows/validate-and-convert.yml/badge.svg)

---

## What Makes This Different

Most Sigma rule repos are a list of YAMLs. This one documents the **gap between naive and evasion-aware detection** for each technique. Every rule ships with:
- The baseline detection and why it's insufficient
- The specific attacker bypass (with source references)
- A hardened variant that catches the evasion
- Atomic Red Team validation proving the rule fires
- True/false positive rate from lab testing

---

## Coverage Map

| # | ATT&CK ID | Technique | Sigma | SPL | KQL | ART Validated | Evasion Documented |
|---|-----------|-----------|-------|-----|-----|---------------|--------------------|
| 1 | T1059.001 | PowerShell Encoded Command | [yaml](rules/T1059.001-powershell-encoded.yml) | [spl](output/splunk/T1059.001-powershell-encoded.spl) | [kql](output/sentinel/T1059.001-powershell-encoded.kql) | ☐ | ✅ |
| 2 | T1053.005 | Scheduled Task Creation | ☐ | ☐ | ☐ | ☐ | ☐ |
| 3 | T1547.001 | Registry Run Key Persistence | ☐ | ☐ | ☐ | ☐ | ☐ |
| 4 | T1003.001 | LSASS Credential Dumping | ☐ | ☐ | ☐ | ☐ | ☐ |
| 5 | T1055.012 | Process Hollowing | ☐ | ☐ | ☐ | ☐ | ☐ |
| 6 | T1486 | Data Encrypted for Impact | ☐ | ☐ | ☐ | ☐ | ☐ |
| 7 | T1021.002 | SMB Lateral Movement | ☐ | ☐ | ☐ | ☐ | ☐ |
| 8 | T1105 | Ingress Tool Transfer | ☐ | ☐ | ☐ | ☐ | ☐ |
| 9 | T1562.001 | Disable Windows Defender | ☐ | ☐ | ☐ | ☐ | ☐ |
| 10 | T1070.004 | Indicator Removal | ☐ | ☐ | ☐ | ☐ | ☐ |

---

## Pipeline Architecture

```
Author Sigma Rule (YAML)
        │
        ▼
   git push rules/
        │
        ▼
GitHub Actions triggers
        │
        ├──► sigma check rules/          (validate YAML syntax)
        │
        ├──► sigma convert -t splunk     (output/splunk/*.spl)
        │
        └──► sigma convert -t kusto      (output/sentinel/*.kql)
                │
                ▼
        Auto-committed back to repo
```

---

## Lab Setup

| Component | Tool | Purpose |
|-----------|------|---------|
| Endpoint | Windows 10 VM | Target for Atomic Red Team tests |
| Sysmon | SwiftOnSecurity config | Enriched Windows telemetry |
| SIEM 1 | Splunk Enterprise (free dev) | SPL rule validation |
| SIEM 2 | Microsoft Sentinel (Azure trial) | KQL rule validation |
| Emulation | Atomic Red Team | Trigger each ATT&CK technique |
| Conversion | sigma-cli + pysigma backends | Sigma → SPL/KQL |

---

## Repository Structure

```
sigma-detection-pipeline/
├── .github/workflows/
│   └── validate-and-convert.yml   ← CI/CD pipeline
├── rules/                         ← Sigma YAML source (one file per technique)
├── output/
│   ├── splunk/                    ← Auto-generated SPL (do not edit manually)
│   └── sentinel/                  ← Auto-generated KQL (do not edit manually)
├── docs/rules/                    ← Per-rule documentation with evasion analysis
├── screenshots/                   ← Alert firing evidence
├── tests/
│   └── atomic_mappings.json       ← Maps each rule to its ART test ID
└── requirements.txt
```

---

## Author

**Aaron Jean** | Security Operations Engineer | [LinkedIn](https://linkedin.com) | [rootaccess.tech](https://rootaccess.tech)

Certifications: CompTIA Security+, CySA+, AWS Security Specialty, Practical SOC Analyst  
CyberDefenders Global Top 50
