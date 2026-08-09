# Organizational Units

## Domain

```text
evil.corp
```

NetBIOS domain:

```text
e-corp
```

Domain Controller:

```text
DC1
```

The lab uses Active Directory Users and Computers (ADUC) to organize domain objects. fileciteturn1file3

## Built Enterprise OU Structure

The enterprise structure established for the lab is:

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

The standard AD containers remain present:

```text
Builtin
Computers
Domain Controllers
ForeignSecurityPrincipals
Managed Service Accounts
Users
```

The `Groups` OU was explicitly created and configured with **Protect container from accidental deletion** enabled. fileciteturn2file0

## Purpose

| OU | Intended role |
|---|---|
| `Admins` | Administrative identities |
| `IT` | IT users and administrative identities |
| `HR` | Human Resources users |
| `Finance` | Finance users |
| `Developers` | Developer identities |
| `Service Accounts` | Service identities |
| `Groups` | Security/group objects |
| `Servers` | Server computer objects |
| `Workstations` | Domain workstation objects |

OUs provide logical organization and can also be used as the scope for management controls such as Group Policy. fileciteturn2file0

## Domain Layout

```text
evil.corp
│
├── Builtin
├── Computers
├── Domain Controllers
│   └── DC1
├── ForeignSecurityPrincipals
├── Managed Service Accounts
├── Users
│   ├── Administrator
│   ├── Guest
│   └── lab accounts
│
└── Enterprise OUs
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
