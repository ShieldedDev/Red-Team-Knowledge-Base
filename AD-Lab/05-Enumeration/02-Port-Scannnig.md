# Port Scanning and Service Enumeration

## Objective

After discovering the live hosts, the next step is to determine which network services are exposed by the target.

For this lab, the primary target is:

```text
Target: 192.168.56.10
Hostname: DC1
Domain: evil.corp
```

Port scanning answers:

> **Which TCP ports are reachable on the target?**

Service enumeration then answers:

> **What service and software are associated with those ports?**

These are separate stages. A port being open tells us that something is listening; service/version detection gives us additional information about what is listening.

---

# 1. Full TCP Port Scan

## Command

The first scan used:

```bash
nmap -Pn -p- --min-rate 2000 -oN dc1-allports.txt 192.168.56.10
```

### Breakdown

| Option | Meaning |
|---|---|
| `-Pn` | Skip host discovery and treat the target as online |
| `-p-` | Scan all TCP ports from `1` through `65535` |
| `--min-rate 2000` | Ask Nmap to send at least approximately 2000 probes/second |
| `-oN dc1-allports.txt` | Save the normal-format output to a file |
| `192.168.56.10` | Target DC1 |

### Why `-Pn`?

We had already established that `192.168.56.10` is alive during host discovery.

Using:

```bash
-Pn
```

prevents Nmap from first performing host-discovery checks and allows us to go directly into the port scan.

This is particularly useful when:

- ICMP is blocked.
- Host discovery probes are filtered.
- We already know the target is alive.
- We want consistent scanning behavior.

---

# 2. Why Scan All 65,535 Ports?

A common mistake during enumeration is to scan only the "common" ports.

For example:

```bash
nmap 192.168.56.10
```

does not represent a complete TCP attack-surface assessment.

Using:

```bash
-p-
```

checks every TCP port:

```text
1
2
3
...
80
88
135
...
445
...
5985
...
65535
```

This matters because Windows services can expose dynamically allocated RPC ports in the high-port range.

Our DC demonstrates exactly why this matters:

```text
49664/tcp
49667/tcp
49668/tcp
49674/tcp
49675/tcp
49685/tcp
49692/tcp
```

These ports were identified as open during the full TCP scan.

---

# 3. Full Port Scan Results

The scan identified the following open TCP ports:

```text
53/tcp       open
80/tcp       open
88/tcp       open
135/tcp      open
139/tcp      open
389/tcp      open
445/tcp      open
464/tcp      open
593/tcp      open
636/tcp      open
3268/tcp     open
3269/tcp     open
5985/tcp     open
9389/tcp     open
49664/tcp    open
49667/tcp    open
49668/tcp    open
49674/tcp    open
49675/tcp    open
49685/tcp    open
49692/tcp    open
```

The scan reported:

```text
Not shown: 65514 filtered tcp ports (no-response)
```

This is significant because the vast majority of TCP ports did not respond to the scan, while the ports above were reachable.

---

## Full Port Scan Evidence

![Nmap full TCP port scan](../Images/Port-Scanning/nmap-all-ports.png)

---

# 4. What We Learn From the Port List

The port numbers immediately provide useful clues.

| Port | Nmap Service | Likely Role in This Lab |
|---:|---|---|
| `53` | DNS | Active Directory DNS |
| `80` | HTTP | IIS web server |
| `88` | Kerberos | Active Directory authentication |
| `135` | MSRPC | Windows RPC endpoint mapper |
| `139` | NetBIOS-SSN | Legacy Windows/SMB transport |
| `389` | LDAP | Active Directory LDAP |
| `445` | Microsoft-DS | SMB |
| `464` | kpasswd5 | Kerberos password change |
| `593` | HTTP-RPC-EPMap | RPC over HTTP |
| `636` | LDAPS | LDAP over TLS |
| `3268` | Global Catalog LDAP | AD Global Catalog |
| `3269` | Global Catalog LDAPS | AD Global Catalog over TLS |
| `5985` | WSMAN | WinRM over HTTP |
| `9389` | ADWS | Active Directory Web Services |
| `49664+` | Dynamic/unknown | Windows dynamic RPC ports |

The combination is a strong indicator that `192.168.56.10` is not simply a Windows workstation.

The exposed services are characteristic of an **Active Directory Domain Controller**.

---

# 5. Why Dynamic RPC Ports Matter

The high-numbered ports:

```text
49664
49667
49668
49674
49675
49685
49692
```

are associated with Windows services using dynamically assigned RPC endpoints.

This is an important enumeration lesson:

```text
Windows RPC
    │
    ├── TCP/135
    │      │
    │      └── RPC Endpoint Mapper
    │
    └── Dynamic RPC endpoints
           │
           ├── 49664
           ├── 49667
           ├── 49668
           ├── ...
           └── 49692
```

Therefore, seeing port `135` alone is not the complete RPC attack surface.

The dynamic ports discovered by the full scan are also relevant.

---

# 6. Service Enumeration

After obtaining the complete list of open ports, we performed a more targeted scan with:

```bash
nmap -Pn -sC -sV -p53,80,88,135,139,445,464,593,636,3268,3269,6985,9389,49964,49667,49668,49674,49675,49685,49692 192.168.56.10
```

### Breakdown

| Option | Meaning |
|---|---|
| `-Pn` | Skip host discovery |
| `-sC` | Run Nmap's default NSE scripts |
| `-sV` | Perform service/version detection |
| `-p` | Scan the specified ports |
| Target | `192.168.56.10` |

This scan is different from the previous scan.

The first scan answered:

```text
Which TCP ports are open?
```

The second scan attempted to answer:

```text
What services are running?
What versions can be identified?
What information can NSE scripts disclose?
```

---

# 7. Service Enumeration Results

The scan identified:

```text
53/tcp    open  domain        Simple DNS Plus

80/tcp    open  http          Microsoft IIS httpd 10.0

88/tcp    open  kerberos-sec  Microsoft Windows Kerberos

135/tcp   open  msrpc         Microsoft Windows RPC

139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn

445/tcp   open  microsoft-ds?

464/tcp   open  kpasswd5?

593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0

636/tcp   open  tcpwrapped

3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP
                              Domain: evil.corp
                              Site: Default-First-Site-Name

3269/tcp  open  tcpwrapped

9389/tcp  open  mc-nmf        .NET Message Framing

49667/tcp open  msrpc         Microsoft Windows RPC
49668/tcp open  msrpc         Microsoft Windows RPC
49674/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49675/tcp open  msrpc         Microsoft Windows RPC
49685/tcp open  msrpc         Microsoft Windows RPC
49692/tcp open  msrpc         Microsoft Windows RPC
```

Nmap identified the host as:

```text
Host: DC1
OS:   Windows
```

---

## Service Enumeration Evidence

![Nmap service and version enumeration](../Images/Port-Scanning/service-enum.png)

---

# 8. HTTP Enumeration

Port `80` is running:

```text
Microsoft IIS httpd 10.0
```

Nmap also reported:

```text
http-server-header: Microsoft-IIS/10.0
```

The HTTP title is:

```text
IIS Windows Server
```

Nmap identified:

```text
Potentially risky methods: TRACE
```

### What this tells us

We have an IIS web server exposed on the Domain Controller.

This creates another enumeration path:

```text
DC1
 │
 └── TCP/80
       │
       └── IIS 10.0
             │
             ├── Web directories
             ├── Applications
             ├── Virtual hosts
             ├── HTTP methods
             └── Web technologies
```

The presence of `TRACE` is worth recording, but **it is not by itself proof of a vulnerability**.

We should investigate the web service separately during HTTP enumeration.

---

# 9. LDAP and Active Directory

The most important discovery in this scan is:

```text
3268/tcp open ldap
Microsoft Windows Active Directory LDAP
Domain: evil.corp
Site: Default-First-Site-Name
```

This confirms that the host is exposing Active Directory LDAP/Global Catalog functionality.

We now have:

```text
Domain:
evil.corp

Domain Controller:
DC1

IP:
192.168.56.10
```

The LDAP-related ports are:

```text
389   LDAP
636   LDAPS
3268  Global Catalog LDAP
3269  Global Catalog LDAPS
```

These services will become important when we begin authenticated and, where permitted by the lab configuration, unauthenticated AD enumeration.

---

# 10. Kerberos

Port `88` is:

```text
Microsoft Windows Kerberos
```

Kerberos is one of the core authentication protocols used by Active Directory.

The presence of:

```text
88/tcp
464/tcp
```

is consistent with an AD environment.

Port `464` is associated with Kerberos password-change functionality.

This gives us another important enumeration path:

```text
Kerberos
    │
    ├── Domain information
    ├── User/account discovery
    ├── SPNs
    ├── Authentication behavior
    └── Time synchronization
```

Later, Kerberos enumeration will be performed separately rather than mixing it into the initial port scan.

---

# 11. SMB

TCP `445` is open:

```text
445/tcp open microsoft-ds
```

This is one of the most important ports in our AD lab.

SMB will allow us to investigate:

```text
Shares
Permissions
SMB signing
Authenticated access
SYSVOL
NETLOGON
Custom shares
File access
```

We have already created the custom share:

```text
steel_mountain
```

Therefore, SMB enumeration will connect the network-level discovery to the infrastructure we built earlier.

---

# 12. WinRM

TCP `5985` was identified during the full port scan as:

```text
5985/tcp open wsman
```

This corresponds to Windows Remote Management over HTTP.

We intentionally installed/configured WinRM in the lab.

Its presence gives us another potential authenticated management interface:

```text
Kali
  │
  │ TCP/5985
  ▼
DC1
  │
  └── WinRM
```

We will enumerate and test WinRM separately after establishing the relevant domain credentials and authorization context.

---

# 13. Active Directory Web Services

TCP `9389` was identified as:

```text
9389/tcp open adws
```

This corresponds to Active Directory Web Services.

ADWS provides management functionality for Active Directory and is another strong indicator that the target is functioning as an AD Domain Controller.

---

# 14. SMB Security Information

The NSE scripts also returned:

```text
smb2-security-mode:
  3.1.1:
    Message signing enabled and required
```

This is important.

The server is using:

```text
SMB 3.1.1
```

and SMB signing is:

```text
Enabled
Required
```

From an offensive-security perspective, this should be recorded because SMB signing affects certain network attack techniques.

For example, a finding such as:

```text
SMB signing disabled
```

cannot be claimed against this host based on the current evidence.

Our current evidence indicates the opposite:

```text
SMB signing required
```

---

# 15. Time Synchronization Observation

Nmap reported:

```text
smb2-time:
  date: 2026-08-10T05:18:38
  clock-skew: 12h29m57s
```

The scan also obtained the Kerberos server time.

Time synchronization is particularly important in Active Directory because Kerberos authentication is sensitive to clock differences.

For the lab, this observation should be recorded rather than immediately treated as a vulnerability.

---

# 16. Initial Attack Surface

At this point, our DC attack surface can be represented as:

```text
                         DC1
                   192.168.56.10
                         │
       ┌─────────────────┼──────────────────┐
       │                 │                  │
      DNS               Web                AD
       │                 │                  │
      53                80             ┌─────┴─────┐
 Simple DNS+           IIS            LDAP      Kerberos
                                      │            │
                                  389/636      88/464
                                      │
                                  Global Cat.
                                  3268/3269
       │
       ├── SMB
       │    ├── 139
       │    └── 445
       │
       ├── RPC
       │    ├── 135
       │    ├── 593
       │    └── Dynamic RPC ports
       │
       ├── WinRM
       │    └── 5985
       │
       └── AD Web Services
            └── 9389
```

This is already enough to identify the machine as a highly exposed **Domain Controller** rather than an ordinary Windows endpoint.

---

# 17. Important Enumeration Principle

Do not jump directly from:

```text
Port 445 open
```

to:

```text
SMB vulnerability
```

or from:

```text
Port 80 open
```

to:

```text
Web vulnerability
```

The correct workflow is:

```text
Host Discovery
      ↓
Port Discovery
      ↓
Service Detection
      ↓
Protocol Enumeration
      ↓
Identity / Access Enumeration
      ↓
Configuration Analysis
      ↓
Attack Path Identification
      ↓
Validation
```

Each stage reduces uncertainty.

---

# 18. Current Findings

At the end of this phase we have established:

### Target

```text
IP:       192.168.56.10
Hostname: DC1
Domain:   evil.corp
OS:       Windows
```

### Exposed services

```text
DNS
HTTP/IIS
Kerberos
RPC
NetBIOS
SMB
LDAP
LDAPS
Global Catalog
WinRM
AD Web Services
Dynamic RPC
```

### Security observations

```text
SMB 3.1.1
SMB signing: Enabled and required
HTTP TRACE: Reported by Nmap
Large number of filtered TCP ports
Active Directory LDAP identified
Domain: evil.corp
```

None of these observations should automatically be classified as vulnerabilities. They are **enumeration data** that will guide the next phases.

---

# 19. Next Enumeration Phase

The next step should be **protocol-specific enumeration**.

For this AD environment, prioritize:

```text
1. SMB enumeration
2. LDAP enumeration
3. RPC enumeration
4. DNS enumeration
5. Kerberos enumeration
6. HTTP/IIS enumeration
7. WinRM enumeration
8. Active Directory user/group enumeration
```

The objective is to move from:

```text
"These services exist."
```

to:

```text
"These services expose these identities, shares,
permissions, domain objects, configurations and relationships."
```

That information will eventually allow us to build an actual attack-path model of the lab rather than simply collecting tool output.
