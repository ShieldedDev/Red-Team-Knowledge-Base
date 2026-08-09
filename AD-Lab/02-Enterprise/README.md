# 02 — Enterprise Infrastructure

This directory documents the Active Directory enterprise layer built on the Windows Server lab.

## Core Infrastructure

| Component | Configuration |
|---|---|
| OS | Windows Server 2022 |
| Domain Controller | `DC1` |
| Domain | `evil.corp` |
| NetBIOS | `e-corp` |
| DNS | Enabled |
| Global Catalog | Enabled |
| Forest Functional Level | Windows Server 2016 |
| Domain Functional Level | Windows Server 2016 |
| AD Database | `C:\Windows\NTDS` |
| SYSVOL | `C:\Windows\SYSVOL` |

fileciteturn4file2

## Network

```text
DC1      192.168.56.10
CTO      192.168.56.20
CYDECK   192.168.56.30
```

The lab uses DC1 as the Active Directory Domain Controller, with CTO and CYDECK as domain-joined workstations.

## Enterprise Structure

```text
evil.corp
├── Admins
├── IT
├── HR
├── Finance
├── Developers
├── Service Accounts
├── Groups
├── Servers
└── Workstations
```

Standard AD containers remain available:

```text
Builtin
Computers
Domain Controllers
ForeignSecurityPrincipals
Managed Service Accounts
Users
```

## Users

```text
tyrell
ggideon
tcolby
elliot
angela
pprice
sjacobs
darlene
cramirez
leon
```

## Service Accounts

```text
SQLService
WebService
BackupSvc
JenkinsSvc
```

`SQLService` has the documented SPN:

```text
DC1/SQLService.evil.corp:60111
```

## SMB

```text
Share:
    steel_mountain

Local:
    C:\Shares\steel_mountain

Network:
    \\DC1\steel_mountain

Protocol:
    SMB
```

Share configuration:

```text
Access-Based Enumeration: Disabled
Caching:                  Enabled
BranchCache:              Disabled
Encryption:               Disabled
Share permission:         Everyone - Full Control
```

## Security Model

```text
Active Directory
       │
       ├── Users
       │      │
       │      └── Group Membership
       │                    │
       │                    ▼
       │                 Security
       │                  Groups
       │                    │
       │                    ▼
       │                  ACLs
       │                    │
       │                    ▼
       └─────────────── Resources
                              │
                              ├── SMB
                              └── NTFS
```

## Documentation Status

```text
[+] AD DS
[+] Domain / Forest
[+] Domain Controller
[+] DNS / Global Catalog
[+] Organizational structure
[+] Domain users
[+] Service accounts
[+] SQLService SPN
[+] SMB share
[+] Share permissions
[+] NTFS permission model
```

The exact custom security-group names and complete user-to-group membership matrix are not preserved in the available written source material, so they are intentionally not fabricated in these notes.
