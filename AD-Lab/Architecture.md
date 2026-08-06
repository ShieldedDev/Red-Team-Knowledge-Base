# Active Directory Lab Architecture

> This document describes the complete architecture of the Active Directory lab environment, including the infrastructure, virtual networking, domain hierarchy, organizational design, and enterprise resources. It serves as the blueprint for the entire lab.

---

# Table of Contents

- [Overview](#overview)
- [Lab Objectives](#lab-objectives)
- [Host Machine](#host-machine)
- [Virtualization Platform](#virtualization-platform)
- [Network Architecture](#network-architecture)
- [Virtual Machines](#virtual-machines)
- [Domain Architecture](#domain-architecture)
- [Organizational Structure](#organizational-structure)
- [Security Groups](#security-groups)
- [Service Accounts](#service-accounts)
- [Shared Resources](#shared-resources)
- [Technology Stack](#technology-stack)
- [Lab Roadmap](#lab-roadmap)

---

# Overview

This Active Directory Lab simulates a small enterprise Windows environment designed for learning enterprise administration, Active Directory internals, and modern Red Team operations.

Unlike many penetration testing labs that focus only on exploitation, this environment is built from the ground up to mirror the lifecycle of a real enterprise infrastructure.

Every user, computer, group, permission, policy, and service created throughout this project will later become part of attack simulations, privilege escalation paths, detection exercises, and hardening practices.

---

# Lab Objectives

The primary objectives of this lab are:

- Deploy a Windows Active Directory environment from scratch.
- Learn Windows Server administration.
- Understand Active Directory architecture.
- Configure enterprise users, groups, and permissions.
- Deploy realistic Windows services.
- Practice PowerShell automation.
- Perform Active Directory enumeration.
- Simulate common Red Team attack paths.
- Analyze Windows security controls.
- Implement defensive hardening techniques.

---

# Host Machine

| Component | Specification |
|------------|---------------|
| Host Operating System | CatchyOS (Arch Linux) |
| Processor | Intel Core i5 12th Generation H-Series |
| Memory | 16 GB RAM |
| Storage | 512 GB SSD |
| Hypervisor | Oracle VirtualBox |

---

# Virtualization Platform

The entire lab is hosted inside Oracle VirtualBox.

The environment uses a dedicated Host-Only network to provide complete isolation from the physical network while allowing communication between all virtual machines.

Benefits include:

- Safe malware experimentation
- Network isolation
- Repeatable testing
- Snapshot support
- Easy recovery

---

# Network Architecture

## Network Type

```
VirtualBox Host-Only Network
```

## Network Address

```
192.168.56.0/24
```

## Topology

```
                    CatchyOS Host
                          │
                   VirtualBox Host
                     vboxnet0
                  192.168.56.1
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        │                 │                 │
      DC01              CTO             CYDECK
192.168.56.10      192.168.56.20    192.168.56.30
```

---

## IP Addressing Scheme

| Machine | Address | Purpose |
|----------|----------|-------------------------|
| Host Adapter | 192.168.56.1 | VirtualBox Host Adapter |
| DC01 | 192.168.56.10 | Domain Controller + DNS |
| CTO | 192.168.56.20 | Windows 10 Client |
| CYDECK | 192.168.56.30 | Windows 10 Client |

---

# Virtual Machines

## DC01

| Property | Value |
|-----------|-------|
| Operating System | Windows Server 2022 |
| Role | Domain Controller |
| Services | AD DS, DNS |
| Hostname | DC01 |
| Domain | evil.corp |

---

## CTO

| Property | Value |
|-----------|-------|
| Operating System | Windows 10 Pro |
| Role | Client Workstation |
| Department | IT |
| Hostname | CTO |

---

## CYDECK

| Property | Value |
|-----------|-------|
| Operating System | Windows 10 Pro |
| Role | Client Workstation |
| Department | HR |
| Hostname | CYDECK |

---

# Domain Architecture

| Property | Value |
|-----------|-------|
| Domain Name | evil.corp |
| NetBIOS Name | E-CORP |
| Forest | evil.corp |
| DNS Server | DC01 |
| Functional Level | Windows Server 2022 |

---

# Active Directory Structure

```
evil.corp
│
├── Domain Controllers
│      └── DC01
│
├── Workstations
│      ├── CTO
│      └── CYDECK
│
├── IT
│      ├── tyrell
│      ├── tcolby
│      └── elliot
│
├── HR
│      ├── ggideon
│      └── angela
│
├── Finance
│      ├── pprice
│      └── sjacobs
│
├── Developers
│      ├── darlene
│      ├── cramirez
│      └── leon
│
├── Service Accounts
│      ├── SQLService
│      ├── WebService
│      ├── BackupSvc
│      └── JenkinsSvc
│
├── Groups
│      ├── IT
│      ├── HR
│      ├── Finance
│      ├── Developers
│      ├── HelpDesk
│      ├── SQL Admins
│      ├── Backup Operators
│      └── Remote Desktop Users
│
└── Servers
```

---

# Security Groups

The environment follows Microsoft's recommended practice of assigning permissions to security groups rather than directly to individual users.

Current groups include:

- IT
- HR
- Finance
- Developers
- HelpDesk
- SQL Admins
- Backup Operators
- Remote Desktop Users

---

# Service Accounts

The following managed service accounts are included within the lab.

| Service Account | Intended Purpose |
|-----------------|------------------|
| SQLService | Microsoft SQL Server |
| WebService | IIS Application Pool |
| BackupSvc | Enterprise Backup Software |
| JenkinsSvc | Jenkins Automation Server |

These accounts will later be used to study:

- Service Principal Names (SPNs)
- Kerberos Authentication
- Kerberoasting
- Delegation
- Privilege Escalation

---

# Shared Resources

The enterprise currently hosts the following departmental SMB shares.

```
\\DC01\IT

\\DC01\HR

\\DC01\Finance

\\DC01\Developers

\\DC01\Public
```

Access to each share is controlled using both:

- NTFS Permissions
- Share Permissions

Role-based access is enforced using Active Directory security groups.

---

# Technology Stack

The lab currently utilizes the following technologies.

### Infrastructure

- Oracle VirtualBox
- Windows Server 2022
- Windows 10 Pro
- Active Directory Domain Services
- DNS Server

### Administration

- Active Directory Users and Computers
- Group Policy Management
- PowerShell
- Windows Server Manager

### Networking

- SMB
- LDAP
- DNS
- Kerberos

### Offensive Security (Planned)

- BloodHound
- SharpHound
- NetExec
- Impacket
- Evil-WinRM
- CrackMapExec Concepts
- PowerView
- Rubeus
- Mimikatz

---

# Current Environment Status

The following components have been successfully deployed.

- Windows Server installed
- Active Directory configured
- DNS configured
- Domain Controller promoted
- Static IP addressing configured
- Two Windows clients joined to the domain
- Organizational Units created
- Enterprise users created
- Security groups created
- Service accounts created
- SMB shares configured
- NTFS permissions configured
- Share permissions verified

---

# Future Expansion

The following components will be implemented during future phases of the project.

- Group Policy Objects
- WinRM
- OpenSSH
- IIS
- PowerShell Automation
- BloodHound
- Active Directory Enumeration
- Kerberoasting
- AS-REP Roasting
- Lateral Movement
- Privilege Escalation
- Detection Engineering
- Windows Hardening

---

# Conclusion

This architecture represents the baseline enterprise environment used throughout this repository.

Every administrative configuration introduced in later sections is intentionally designed to support realistic Windows administration tasks while simultaneously providing opportunities to study Active Directory enumeration, attack techniques, defensive monitoring, and security hardening from both offensive and defensive perspectives.
