# Active Directory Lab - Red Team Knowledge Base

> A hands-on Active Directory home lab built from scratch for learning Windows enterprise administration, Active Directory internals, and modern Red Team operations.

---

## Overview

This repository documents the complete process of designing, deploying, administering, and attacking a realistic Windows Active Directory environment.

Unlike traditional walkthroughs that focus only on offensive tooling, this project first builds a functional enterprise infrastructure and then demonstrates how administrative configurations become attack surfaces.

The objective is to understand **how Active Directory works**, **why common attack paths exist**, and **how they can be detected and mitigated**.

---

## Learning Objectives

This lab is designed to provide practical experience with:

- Active Directory Domain Services (AD DS)
- Windows Server Administration
- DNS Configuration
- Organizational Units (OUs)
- Security Groups
- User & Computer Management
- Group Policy Objects (GPO)
- NTFS & Share Permissions
- SMB File Shares
- PowerShell Automation
- Windows Authentication
- Kerberos
- LDAP
- Enterprise Network Administration
- Active Directory Enumeration
- Red Team Operations
- Detection & Hardening

---

# Lab Architecture

```
                    Host Machine
              (CatchyOS - Arch Linux)

                        │
                VirtualBox Hypervisor
                        │
        Host-Only Network (192.168.56.0/24)
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        │               │                │
     DC01             CTO             CYDECK
 192.168.56.10   192.168.56.20   192.168.56.30

         Domain: evil.corp
```

---

## Virtual Machines

| Machine | Role | Operating System | IP |
|----------|------|------------------|----------------|
| DC01 | Domain Controller | Windows Server 2022 | 192.168.56.10 |
| CTO | Windows 10 Client | Windows 10 Pro | 192.168.56.20 |
| CYDECK | Windows 10 Client | Windows 10 Pro | 192.168.56.30 |

---

## Current Enterprise Structure

```
evil.corp
│
├── Domain Controllers
│      DC01
│
├── Workstations
│      CTO
│      CYDECK
│
├── IT
│      Tyrell Wellick
│      Terry Colby
│      Elliot Alderson
│
├── HR
│      Gideon Goddard
│      Angela Moss
│
├── Finance
│      Philip Price
│      Susan Jacobs
│
├── Developers
│      Darlene Alderson
│      Cisco Ramirez
│      Leon
│
├── Service Accounts
│      SQLService
│      WebService
│      BackupSvc
│      JenkinsSvc
│
└── Security Groups
       IT
       HR
       Finance
       Developers
       HelpDesk
       SQL Admins
       Backup Operators
```

---

## Repository Structure

```
AD-Lab/
│
├── README.md
├── Architecture.md
│
├── 01-Setup/
│   ├── VirtualBox.md
│   ├── Networking.md
│   ├── DC01.md
│   ├── CTO.md
│   └── CYDECK.md
│
├── 02-Enterprise/
│   ├── Organizational-Units.md
│   ├── Security-Groups.md
│   ├── Users.md
│   ├── Group-Membership.md
│   ├── Service-Accounts.md
│   ├── SMB-Shares.md
│   └── NTFS-Permissions.md
│
├── 03-Group-Policy/
│
├── 04-PowerShell/
│
├── 05-Enumeration/
│
├── 06-Attacks/
│
├── 07-Detection/
│
├── 08-Hardening/
│
├── Images/
│
└── PowerShell/
```

---

# Roadmap

The lab is developed incrementally to simulate the lifecycle of an enterprise environment.

## Phase 1 — Infrastructure

- VirtualBox Configuration
- Virtual Networking
- Windows Server Installation
- Windows Client Installation
- Active Directory Deployment
- Domain Controller Configuration
- Domain Join

---

## Phase 2 — Enterprise Administration

- Organizational Units
- Security Groups
- Domain Users
- Service Accounts
- SMB Shares
- NTFS Permissions
- Enterprise File Services

---

## Phase 3 — Windows Administration

- Group Policy Objects
- Password Policies
- Account Lockout
- Windows Firewall
- Windows Defender
- Remote Desktop
- WinRM
- OpenSSH

---

## Phase 4 — Active Directory Enumeration

- DNS Enumeration
- SMB Enumeration
- LDAP Enumeration
- Kerberos Enumeration
- BloodHound
- PowerView
- PowerShell AD Enumeration

---

## Phase 5 — Red Team Operations

- Password Spraying
- AS-REP Roasting
- Kerberoasting
- SMB Relay Concepts
- Pass-the-Hash
- Pass-the-Ticket
- WinRM Lateral Movement
- ACL Abuse
- DCSync
- Resource-Based Constrained Delegation
- Persistence Techniques

---

## Phase 6 — Detection & Hardening

- Windows Event Logs
- Kerberos Monitoring
- Defender Configuration
- Sysmon
- PowerShell Logging
- GPO Hardening
- Least Privilege
- Attack Detection
- Security Best Practices

---

# Documentation Style

Each guide in this repository follows a consistent structure:

- Overview
- Objectives
- Prerequisites
- Step-by-Step Configuration
- Verification
- Troubleshooting
- Key Takeaways
- References

Every configuration performed in the lab is documented with explanations, screenshots, and verification steps.

---

# Technologies Used

- Windows Server 2022
- Windows 10 Pro
- Active Directory Domain Services
- DNS
- SMB
- Kerberos
- LDAP
- PowerShell
- VirtualBox
- Kali Linux
- BloodHound
- Impacket
- NetExec
- Evil-WinRM
- Wireshark

---

# Purpose

The goal of this repository is not simply to demonstrate offensive techniques.

Instead, it documents the complete lifecycle of building and administering an enterprise Active Directory environment before exploring how those administrative components are enumerated, abused, detected, and secured during Red Team operations.

By understanding the underlying Windows infrastructure, every attack demonstrated in this repository can be analyzed from both an offensive and defensive perspective.

---

**Work in Progress**

This repository is continuously expanded as new enterprise components, attack techniques, PowerShell automation, detection strategies, and hardening practices are implemented and documented.
