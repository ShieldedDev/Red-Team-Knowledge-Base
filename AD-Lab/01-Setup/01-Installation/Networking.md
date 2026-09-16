# Networking Configuration

> This document explains the networking architecture of the Active Directory lab, including the VirtualBox network configuration, IP addressing scheme, DNS configuration, workstation communication, and verification steps.

---

# Table of Contents

- Overview
- Why a Dedicated Lab Network?
- VirtualBox Networking Modes
- Why Host-Only Networking?
- Network Architecture
- IP Addressing Plan
- DNS Configuration
- Network Configuration of Each Machine
- Connectivity Verification
- Troubleshooting
- Common Mistakes
- Next Steps

---

# Overview

An Active Directory environment depends heavily on reliable networking. Every service within the domain—including authentication, DNS resolution, Group Policy, SMB file sharing, Kerberos, and LDAP—requires proper communication between hosts.

For this reason, the lab uses an isolated **Host-Only Network** provided by VirtualBox.

This design allows every virtual machine to communicate with each other while remaining isolated from the physical network and the Internet.

---

# Why a Dedicated Lab Network?

The objective of this lab is to safely simulate an enterprise environment.

Using an isolated network provides several advantages:

- Safe attack simulations
- Malware containment
- No interference with the home network
- Predictable IP addressing
- Easy troubleshooting
- Repeatable lab environment

---

# VirtualBox Networking Modes

VirtualBox provides several networking modes.

## NAT

```
VM
 │
 │
VirtualBox NAT
 │
 │
Internet
```

### Advantages

- Internet access
- Simple setup

### Limitations

- VMs cannot easily communicate with each other.
- Unsuitable for Active Directory labs.

---

## Bridged Adapter

```
Router
│
├── Physical PC
│
├── VM 1
│
└── VM 2
```

### Advantages

- VM appears as a physical device on the LAN.

### Limitations

- Visible to the home network.
- Less secure for offensive security labs.

---

## Internal Network

```
VM1
 │
 ├─────────────── VM2
 │
 └─────────────── VM3
```

### Advantages

- Completely isolated.

### Limitations

- Host machine cannot communicate with the VMs.

---

## Host-Only Network (Selected)

```
                 Host Machine
                      │
                  vboxnet0
               192.168.56.1
                      │
      ┌───────────────┼───────────────┐
      │               │               │
    DC1             CTO            CYDECK
```

### Advantages

- Communication between all VMs
- Host can access every VM
- Completely isolated from the Internet
- Ideal for Active Directory

---

# Why Host-Only Networking?

Host-Only networking was selected because it provides:

- Secure isolation
- Reliable DNS communication
- SMB connectivity
- Active Directory authentication
- PowerShell Remoting
- Kerberos communication
- BloodHound collection
- WinRM
- LDAP

without exposing the lab to external systems.

---

# Network Architecture

```
                CatchyOS Host

               192.168.56.1
                    │
             VirtualBox Host Adapter
                  (vboxnet0)
                    │
──────────────────────────────────────────────
                    │
      ┌─────────────┴─────────────┐
      │                           │
      │                           │
  DC1 (Server)                 Workstations
192.168.56.10
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                CTO                         CYDECK
           192.168.56.20               192.168.56.30
```

---

# IP Addressing Plan

| Machine | Address | Purpose |
|----------|----------|-----------------------------|
| Host Adapter | 192.168.56.1 | VirtualBox Host Interface |
| DC1 | 192.168.56.10 | Domain Controller & DNS |
| CTO | 192.168.56.20 | IT Workstation |
| CYDECK | 192.168.56.30 | HR Workstation |

Subnet

```
255.255.255.0
```

Gateway

```
Not Required
```

DNS

```
192.168.56.10
```

---

# Why No Default Gateway?

The lab is intentionally isolated.

Since there is no Internet connectivity, a default gateway is unnecessary.

All communication occurs within:

```
192.168.56.0/24
```

---

# DNS Configuration

Every workstation must use the Domain Controller as its DNS server.

```
Preferred DNS

192.168.56.10
```

Why?

Active Directory relies on DNS to locate:

- Domain Controllers
- Kerberos Services
- LDAP Services
- Global Catalog
- Authentication Services

If DNS is incorrect, domain join will fail.

---

# Machine Configuration

## DC1

| Setting | Value |
|----------|-------|
| IP | 192.168.56.10 |
| Mask | 255.255.255.0 |
| Gateway | Blank |
| DNS | Self |

---

## CTO

| Setting | Value |
|----------|-------|
| IP | 192.168.56.20 |
| Mask | 255.255.255.0 |
| Gateway | Blank |
| DNS | 192.168.56.10 |

---

## CYDECK

| Setting | Value |
|----------|-------|
| IP | 192.168.56.30 |
| Mask | 255.255.255.0 |
| Gateway | Blank |
| DNS | 192.168.56.10 |

---

# Connectivity Verification

Verify IP configuration.

```cmd
ipconfig
```

Verify hostname.

```cmd
hostname
```

Verify DNS.

```cmd
nslookup dc1.evil.corp
```

Verify Domain Controller discovery.

```cmd
nltest /dsgetdc:evil.corp
```

Ping the Domain Controller.

```cmd
ping dc1.evil.corp
```

Ping another workstation.

```cmd
ping 192.168.56.20
```

---

# Troubleshooting

## APIPA Address

```
169.254.x.x
```

Cause

- DHCP unavailable
- Static IP not configured

Solution

Configure a static IP address.

---

## Cannot Join Domain

Possible causes

- Wrong DNS server
- DC offline
- Incorrect domain name
- Firewall

---

## DNS Lookup Failure

Verify

```cmd
nslookup dc1.evil.corp
```

If resolution fails, verify the Preferred DNS Server.

---

## Domain Controller Not Found

Verify

```cmd
nltest /dsgetdc:evil.corp
```

---

## SMB Shares Unreachable

Verify

```cmd
\\dc1
```

or

```cmd
\\192.168.56.10
```

---

# Common Mistakes

- Using Windows Home edition
- Incorrect DNS server
- Using NAT instead of Host-Only
- Forgetting to assign static IP addresses
- Using duplicate IP addresses
- Joining the domain before testing connectivity
- Misconfigured VirtualBox adapters

---

# Key Takeaways

- Active Directory depends on DNS.
- Every machine requires a unique static IP.
- The Domain Controller acts as the DNS server.
- Host-Only networking provides an isolated enterprise environment.
- Proper networking is the foundation for all future Red Team exercises.

---

# Next Steps

With networking configured and verified, the environment is ready for:

- Active Directory deployment
- Domain joining
- SMB file sharing
- Group Policy
- Kerberos authentication
- LDAP enumeration
- PowerShell remoting
- Red Team attack simulations
