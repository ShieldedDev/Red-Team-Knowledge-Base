# Service Accounts

## Overview

The lab contains dedicated identities representing services.

Domain:

```text
evil.corp
```

Domain Controller:

```text
DC1
```

## Service Accounts Established

| Account | Intended service |
|---|---|
| `SQLService` | SQL service |
| `WebService` | IIS / web service |
| `BackupSvc` | Backup service |
| `JenkinsSvc` | Jenkins / CI service |

The service-account OU established for the enterprise structure is:

```text
evil.corp
└── Service Accounts
```

## SQLService

The SQL service account is:

```text
Name:
    SQL Service

SamAccountName:
    SQLService

UPN:
    SQLService@evil.corp

Object class:
    user

Enabled:
    True
```

The account was verified with:

```powershell
Get-ADUser SQLService
```

The documented Distinguished Name is:

```text
CN=SQL Service,CN=Users,DC=evil,DC=corp
```

fileciteturn3file10

## SQLService SPN

The lab associates the account with:

```text
DC1/SQLService.evil.corp:60111
```

Relationship:

```text
Active Directory
      │
      ▼
 SQLService
      │
      │ SPN
      ▼
DC1/SQLService.evil.corp:60111
```

The SPN was configured using:

```cmd
setspn -S DC1/SQLService.evil.corp:60111 SQLService
```

The lab documentation also records that an existing SPN was detected when the command was checked again. fileciteturn3file10

## SPN Verification

Useful verification commands:

```cmd
setspn -L SQLService
```

```cmd
setspn -Q DC1/SQLService.evil.corp:60111
```

```cmd
setspn -X
```

These allow the service identity and SPN state to be inspected. fileciteturn3file10

## Security Relevance

Service accounts are important in AD security because they can:

- Hold service permissions
- Own SPNs
- Authenticate through Kerberos
- Have long-lived credentials
- Become privileged if incorrectly configured

For this reason, service-account privilege, password handling, SPNs, and group membership should be treated separately from ordinary user accounts.

## Current Service Identity Layer

```text
evil.corp
│
└── Service Accounts
    ├── SQLService
    ├── WebService
    ├── BackupSvc
    └── JenkinsSvc
```

`SQLService` is the service account for which the lab contains the most detailed documented configuration, including its AD attributes and SPN. fileciteturn3file10
