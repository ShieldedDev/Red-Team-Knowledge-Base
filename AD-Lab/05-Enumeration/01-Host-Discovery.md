# Host Discovery

## Objective

The first step of enumeration is to determine which hosts are alive on the target network.

For this lab, the network is:

```text
192.168.56.0/24
```

The goal at this stage is **not** to identify vulnerabilities or enumerate services. It is simply to establish the live attack surface and identify the IP addresses that should be investigated in later phases.

---

## 1. Network Range

A `/24` network contains 256 IPv4 addresses:

```text
Network:    192.168.56.0/24
Range:      192.168.56.0 - 192.168.56.255
```

For normal host addressing, the usable host range is:

```text
192.168.56.1 - 192.168.56.254
```

The network address (`192.168.56.0`) and broadcast address (`192.168.56.255`) are not normally assigned to individual hosts.

---

## 2. Nmap Host Discovery

### Command

```bash
nmap -sn 192.168.56.1/24
```

### What does `-sn` mean?

`-sn` tells Nmap to perform **host discovery without performing a port scan**.

In other words:

```text
Target range
     │
     ▼
Host discovery
     │
     ├── Host responds → Mark as UP
     │
     └── No response   → Usually considered DOWN
```

This is useful as the first reconnaissance step because scanning an entire subnet for services before knowing which hosts are alive is unnecessary.

> Important: "No response" does not always prove that a host is down. Firewalls and host-based filtering can suppress discovery probes.

---

## 3. Scan Results

The scan reported:

```text
Nmap scan report for 192.168.56.1
Host is up (0.00093s latency)
MAC Address: 0A:00:27:00:00:00 (Unknown)

Nmap scan report for 192.168.56.10
Host is up (0.0031s latency)
MAC Address: 08:00:27:C2:10:93 (Oracle VirtualBox virtual NIC)

Nmap scan report for 192.168.56.30
Host is up (0.0028s latency)
MAC Address: 08:00:27:0A:B7:78 (Oracle VirtualBox virtual NIC)

Nmap scan report for 192.168.56.50
Host is up (0.0020s latency)
MAC Address: 08:00:27:60:CD:54 (Oracle VirtualBox virtual NIC)

Nmap scan report for 192.168.56.100
Host is up
MAC Address: 08:00:27:60:CD:54 (Oracle VirtualBox virtual NIC)

Nmap done: 256 IP addresses (5 hosts up) scanned in 14.16 seconds
```

### Discovered hosts

| IP Address | Status | Observed Information |
|---|---|---|
| `192.168.56.1` | Up | VirtualBox/local network endpoint |
| `192.168.56.10` | Up | VirtualBox NIC; later identified as `DC1` |
| `192.168.56.30` | Up | VirtualBox NIC |
| `192.168.56.50` | Up | VirtualBox NIC |
| `192.168.56.100` | Up | VirtualBox NIC |

At this point, **do not assign roles to `.30`, `.50`, or `.100` solely from host discovery**. Their purpose should be established through subsequent enumeration.

---

## 4. Why `192.168.56.10` Matters

`192.168.56.10` is the primary system we have already identified as:

```text
Hostname: DC1
Domain:   evil.corp
```

This is our Domain Controller.

The host-discovery phase therefore gives us the initial target inventory:

```text
192.168.56.0/24
        │
        ├── 192.168.56.1
        ├── 192.168.56.10  ← DC1
        ├── 192.168.56.30
        ├── 192.168.56.50
        └── 192.168.56.100
```

The next enumeration phases will determine what each host actually exposes.

---

## 5. Validate the DC with ICMP

After discovering `192.168.56.10`, we manually verified connectivity with:

```bash
ping 192.168.56.10
```

The response was:

```text
PING 192.168.56.10 (192.168.56.10) 56(84) bytes of data.
64 bytes from 192.168.56.10: icmp_seq=1 ttl=128 time=0.959 ms
64 bytes from 192.168.56.10: icmp_seq=2 ttl=128 time=1.60 ms
64 bytes from 192.168.56.10: icmp_seq=3 ttl=128 time=1.34 ms
64 bytes from 192.168.56.10: icmp_seq=4 ttl=128 time=0.937 ms
64 bytes from 192.168.56.10: icmp_seq=5 ttl=128 time=1.01 ms
64 bytes from 192.168.56.10: icmp_seq=6 ttl=128 ms
64 bytes from 192.168.56.10: icmp_seq=7 ttl=128 time=1.28 ms
64 bytes from 192.168.56.10: icmp_seq=8 ttl=128 time=1.50 ms
64 bytes from 192.168.56.10: icmp_seq=9 ttl=128 time=1.43 ms
```

The exact timing is not particularly important for this lab. The important observation is that the host responds consistently to ICMP echo requests.

### TTL observation

The responses show:

```text
ttl=128
```

A TTL of 128 is consistent with a Windows host using the common initial IPv4 TTL of 128.

However, TTL-based OS identification is only an **indicator**, not proof of the operating system. Routing and network devices can modify TTL values.

---

## 6. Nmap Discovery vs Ping

These two commands serve related but different purposes.

### Nmap

```bash
nmap -sn 192.168.56.1/24
```

Answers:

> **Which hosts appear to be alive on this subnet?**

Output:

```text
5 hosts up
```

### Ping

```bash
ping 192.168.56.10
```

Answers:

> **Can I currently reach this particular host using ICMP echo?**

This distinction matters during real enumeration.

A host can be:

```text
Alive
  │
  ├── ICMP blocked
  │
  └── TCP services accessible
```

Therefore, failed ICMP does **not** automatically mean that a target is dead.

---

## 7. Evidence Collected

### Host discovery

![Nmap host discovery](../Images/Enumeration/Host-Discovery/host-discovery.png)

### ICMP connectivity test

![Ping DC1](../Images/Enumeration/Host-Discovery/ping.png)

> Adjust the image paths if the images are stored in a different directory in the repository.

---

## 8. Enumeration Notes

At the end of this phase we know:

- The lab subnet is `192.168.56.0/24`.
- Nmap identified **5 live hosts**.
- `192.168.56.10` is reachable.
- `192.168.56.10` is our Domain Controller (`DC1`).
- The DC responds to ICMP.
- The observed TTL is `128`.
- Several systems use VirtualBox virtual NICs.
- We have **not yet determined the services, operating systems, roles, shares, or vulnerabilities of the other discovered hosts**.

This is the correct stopping point for host discovery.

---

## Next Step

Move from **host discovery** to **service enumeration**.

For the identified hosts, begin with:

```bash
nmap -Pn -sC -sV <TARGET>
```

For the Domain Controller specifically:

```bash
nmap -Pn -sC -sV -p- 192.168.56.10
```

The objective of the next phase is to answer:

```text
Which services are exposed?
Which ports are open?
What software is running?
What protocols are being used?
What information can those services disclose?
```

For an Active Directory environment, this will lead into enumeration of:

```text
DNS
Kerberos
LDAP
SMB
RPC
WinRM
HTTP/IIS
Active Directory
Users
Groups
Shares
SPNs
```

Only after collecting this information should we start correlating services and identities to identify attack paths.
