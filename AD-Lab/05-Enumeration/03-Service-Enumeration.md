# Service Enumeration

## Objective

After identifying the open TCP ports on `DC1`, the next step is to determine which services are running on those ports and collect useful metadata.

Target:

```text
IP Address: 192.168.56.10
Hostname:   DC1
Domain:     evil.corp
OS:         Windows
```

The service-enumeration scan used was:

```bash
nmap -Pn -sC -sV -p53,80,88,135,139,445,464,593,636,3268,3269,6985,9389,49964,49667,49668,49674,49675,49685,49692 192.168.56.10
```

---

## 1. Command Breakdown

### `-Pn`

```bash
-Pn
```

Disables Nmap host discovery and treats the target as online.

We already established during host discovery that:

```text
192.168.56.10 → Host is up
```

Using `-Pn` therefore allows the scan to proceed directly to the requested ports.

### `-sC`

```bash
-sC
```

Runs Nmap's default NSE scripts.

These scripts can retrieve additional protocol information beyond basic port detection.

For example, this scan provided information about:

- SMB security configuration
- SMB time
- NetBIOS identity
- HTTP methods
- HTTP server headers
- LDAP domain information

### `-sV`

```bash
-sV
```

Enables service/version detection.

Instead of simply reporting:

```text
445/tcp open
```

Nmap attempts to determine what is actually listening on the port.

### `-p`

The `-p` option restricts the scan to the ports discovered during the previous full TCP scan.

This avoids unnecessarily repeating the complete `1-65535` TCP scan while allowing deeper enumeration of known services.

---

# 2. Service Enumeration Results

The scan identified the following services:

| Port | State | Service | Detection |
|---:|---|---|---|
| `53/tcp` | open | DNS | Simple DNS Plus |
| `80/tcp` | open | HTTP | Microsoft IIS 10.0 |
| `88/tcp` | open | Kerberos | Microsoft Windows Kerberos |
| `135/tcp` | open | MSRPC | Microsoft Windows RPC |
| `139/tcp` | open | NetBIOS-SSN | Microsoft Windows NetBIOS |
| `445/tcp` | open | Microsoft-DS | SMB |
| `464/tcp` | open | kpasswd5 | Kerberos password change |
| `593/tcp` | open | ncacn_http | Microsoft Windows RPC over HTTP 1.0 |
| `636/tcp` | open | tcpwrapped | LDAPS |
| `3268/tcp` | open | LDAP | Microsoft Active Directory LDAP |
| `3269/tcp` | open | tcpwrapped | Global Catalog LDAPS |
| `9389/tcp` | open | mc-nmf | .NET Message Framing / ADWS |
| `49667/tcp` | open | MSRPC | Microsoft Windows RPC |
| `49668/tcp` | open | MSRPC | Microsoft Windows RPC |
| `49674/tcp` | open | ncacn_http | Microsoft Windows RPC over HTTP 1.0 |
| `49675/tcp` | open | MSRPC | Microsoft Windows RPC |
| `49685/tcp` | open | MSRPC | Microsoft Windows RPC |
| `49692/tcp` | open | MSRPC | Microsoft Windows RPC |

The scan also showed:

```text
6985/tcp   filtered
49964/tcp  filtered
```

A `filtered` state means Nmap could not determine whether the port is open because packet filtering prevented a definitive response.

---

# 3. DNS — TCP/53

```text
53/tcp open domain Simple DNS Plus
```

DNS is exposed on the Domain Controller.

This is expected in an Active Directory environment because DNS is a fundamental component of AD name resolution and service discovery.

The service was identified as:

```text
Simple DNS Plus
```

### Enumeration significance

DNS should be investigated separately for:

```text
Domain names
Host records
Name resolution
Service records
AD-related records
Potentially exposed internal information
```

For this lab, the known domain is:

```text
evil.corp
```

---

# 4. HTTP — TCP/80

```text
80/tcp open http Microsoft IIS httpd 10.0
```

Nmap also reported:

```text
http-server-header: Microsoft-IIS/10.0
```

and:

```text
http-title: IIS Windows Server
```

The scan additionally identified:

```text
Potentially risky methods: TRACE
```

### Interpretation

The Domain Controller is also hosting an IIS web server.

This gives us a separate web-enumeration attack surface:

```text
DC1
 │
 └── TCP/80
       │
       └── Microsoft IIS 10.0
             │
             ├── Directories
             ├── Files
             ├── Applications
             ├── HTTP methods
             └── Web configuration
```

The presence of `TRACE` is an observation, not automatically a vulnerability.

It must be investigated in the context of the actual web application and server configuration.

---

# 5. Kerberos — TCP/88

```text
88/tcp open kerberos-sec
Microsoft Windows Kerberos
```

Kerberos is a core Active Directory authentication protocol.

The scan also provided the Kerberos server time:

```text
2026-08-10 05:17:50Z
```

This confirms that Kerberos is exposed by the target.

We will investigate Kerberos separately for:

```text
Domain information
User/account enumeration
SPNs
Authentication behavior
Service accounts
Kerberos-related attack paths
```

---

# 6. RPC — TCP/135

```text
135/tcp open msrpc
Microsoft Windows RPC
```

TCP/135 is the Windows RPC Endpoint Mapper.

It helps clients determine which dynamically assigned ports are being used by RPC services.

The presence of several high-numbered RPC ports later in the scan is consistent with this architecture.

---

# 7. NetBIOS — TCP/139

```text
139/tcp open netbios-ssn
Microsoft Windows netbios-ssn
```

TCP/139 provides NetBIOS Session Service.

Although modern Windows environments commonly use SMB directly over TCP/445, NetBIOS-related functionality can still be exposed.

This should be recorded as part of the Windows network-service attack surface.

---

# 8. SMB — TCP/445

```text
445/tcp open microsoft-ds
```

TCP/445 is SMB over TCP.

This is one of the most important services for our AD enumeration.

The infrastructure we built earlier contains:

```text
NETLOGON
SYSVOL
steel_mountain
```

SMB enumeration will allow us to determine:

```text
Available shares
Share permissions
Authenticated access
File/directory contents
SMB security configuration
Potentially interesting files
```

This will be handled in the dedicated SMB enumeration phase.

---

# 9. Kerberos Password Change — TCP/464

```text
464/tcp open kpasswd5
```

TCP/464 is associated with Kerberos password-change operations.

Its presence alongside TCP/88 further supports the identification of this machine as an Active Directory infrastructure host.

---

# 10. RPC over HTTP — TCP/593

```text
593/tcp open ncacn_http
Microsoft Windows RPC over HTTP 1.0
```

This indicates RPC functionality available over HTTP.

It should be recorded because RPC is an important Windows administrative protocol and can expose additional functionality beyond the basic TCP/135 endpoint mapper.

---

# 11. LDAP / LDAPS

The scan identified:

```text
636/tcp open tcpwrapped
```

and:

```text
3268/tcp open ldap
Microsoft Windows Active Directory LDAP
Domain: evil.corp
Site: Default-First-Site-Name
```

It also identified:

```text
3269/tcp open tcpwrapped
```

These ports correspond to the Active Directory directory-service attack surface:

```text
389   → LDAP
636   → LDAPS
3268  → Global Catalog LDAP
3269  → Global Catalog LDAPS
```

The most important information obtained here is:

```text
Domain: evil.corp
Site: Default-First-Site-Name
```

This gives us concrete AD information that can be used during the next enumeration stages.

---

# 12. Active Directory Web Services — TCP/9389

```text
9389/tcp open mc-nmf
.NET Message Framing
```

TCP/9389 is associated with Active Directory Web Services (ADWS).

ADWS provides management access to Active Directory for supported management tools.

Its presence is another strong indicator that `DC1` is operating as an Active Directory Domain Controller.

---

# 13. Dynamic RPC Ports

Several high-numbered ports were identified:

```text
49667/tcp
49668/tcp
49674/tcp
49675/tcp
49685/tcp
49692/tcp
```

Nmap identified most of these as:

```text
Microsoft Windows RPC
```

and:

```text
Microsoft Windows RPC over HTTP 1.0
```

This demonstrates why a full TCP scan is important.

If we had only scanned the common ports, we could have missed part of the RPC attack surface.

---

# 14. SMB Security Information

The default NSE scripts returned:

```text
smb2-security-mode:
  3.1.1:
    Message signing enabled and required
```

This tells us:

```text
SMB version: 3.1.1
Signing:     Required
```

This is an important security observation.

We should **not** report SMB signing as disabled or optional based on this evidence.

For our lab:

```text
SMB signing enabled and required
```

will be recorded as the current configuration.

---

# 15. NetBIOS Information

Nmap also returned:

```text
NetBIOS name: DC1
```

This correlates the IP address with the hostname discovered during the Windows/AD configuration:

```text
192.168.56.10 → DC1
```

The MAC address was identified as:

```text
08:00:27:C2:10:93
```

with the vendor information:

```text
Oracle VirtualBox virtual NIC
```

---

# 16. Clock Skew

The scan reported:

```text
clock-skew: 12h29m57s
```

and the SMB time was:

```text
2026-08-10T05:18:38
```

Time synchronization is important in Active Directory because Kerberos authentication depends on reasonably synchronized system clocks.

At this stage, this is an **enumeration observation**, not automatically a vulnerability.

---

# 17. What We Have Learned

The service enumeration strongly establishes the role of the target.

We started with:

```text
192.168.56.10
```

and now have:

```text
192.168.56.10
       │
       ▼
      DC1
       │
       ▼
   evil.corp
       │
 ┌─────┼──────────────────────────────┐
 │     │                              │
DNS  Kerberos                       LDAP
53    88/464                      389/636
 │     │                              │
 │     │                         Global Catalog
 │     │                           3268/3269
 │     │
 ├─────┴──────────────────────────────┐
 │                                    │
SMB/RPC                              ADWS
139/445/135/593                    9389
 │
 ├── NETLOGON
 ├── SYSVOL
 └── steel_mountain

HTTP/IIS
TCP/80

WinRM
TCP/5985
```

This is no longer simply a generic Windows host. The exposed services form a coherent Active Directory Domain Controller profile.

---

# 18. Enumeration vs. Vulnerability Assessment

At this stage we should avoid making premature vulnerability claims.

For example:

```text
TCP/80 open
```

does **not** mean:

```text
IIS vulnerable
```

Similarly:

```text
TCP/445 open
```

does **not** mean:

```text
SMB vulnerable
```

And:

```text
TCP/88 open
```

does **not** mean:

```text
Kerberos vulnerable
```

The purpose of this stage is to build an accurate model of the target.

The workflow is:

```text
Service Discovery
       ↓
Protocol Enumeration
       ↓
Information Collection
       ↓
Configuration Analysis
       ↓
Identity / Permission Analysis
       ↓
Attack Path Identification
       ↓
Validation
```

---

# 19. Current Service Inventory

| Service | Port(s) | Next Action |
|---|---:|---|
| DNS | `53` | DNS enumeration |
| HTTP/IIS | `80` | Web enumeration |
| Kerberos | `88`, `464` | Kerberos enumeration |
| RPC | `135`, `593`, `49667+` | RPC enumeration |
| NetBIOS | `139` | SMB/NetBIOS enumeration |
| SMB | `445` | Share and permission enumeration |
| LDAP | `389`, `636` | LDAP/AD enumeration |
| Global Catalog | `3268`, `3269` | AD enumeration |
| WinRM | `5985` | WinRM enumeration |
| ADWS | `9389` | AD service identification |

---

# 20. Next Step

The next phase should move from generic service identification into **protocol-specific enumeration**.

Recommended order:

```text
01. SMB Enumeration
        ↓
02. RPC Enumeration
        ↓
03. LDAP Enumeration
        ↓
04. DNS Enumeration
        ↓
05. Kerberos Enumeration
        ↓
06. HTTP/IIS Enumeration
        ↓
07. WinRM Enumeration
        ↓
08. AD Users / Groups / SPNs
```

The important transition is:

```text
"DC1 has these services"
```

to:

```text
"These services expose these identities,
shares, permissions, domain objects and
relationships."
```

That information will form the basis for identifying realistic attack paths in the lab.

---

## Evidence

![Service enumeration with Nmap](../Images/Port-Scanning/service-enum.png)
