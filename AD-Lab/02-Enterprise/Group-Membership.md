# Group Membership

## Overview

Group membership is the relationship between an AD security principal and one or more security groups.

The lab uses the model:

```text
User
  ↓
Group Membership
  ↓
Permissions / Access
```

This relationship is central to Active Directory authorization. fileciteturn2file0

## Current Lab Structure

```text
evil.corp
│
├── Users
│   ├── tyrell
│   ├── ggideon
│   ├── tcolby
│   ├── elliot
│   ├── angela
│   ├── pprice
│   ├── sjacobs
│   ├── darlene
│   ├── cramirez
│   └── leon
│
└── Groups
    └── Custom security groups
```

## Membership Inventory

The available written documentation confirms that group objects were created and that group-management operations were practiced, including selecting multiple group objects. It does **not** preserve the exact final membership mapping for every custom group. fileciteturn4file0

Therefore no unverified membership assignments are recorded here.

### Verified State

```text
[+] Users created
[+] Groups OU created
[+] Security groups created/inspected
[+] Group-management operations performed
[+] User → group → permission relationship established as the access-control model
```

## Why Membership Matters

A user does not need to have a permission assigned directly to their account for that permission to become effective.

A simplified model is:

```text
User
 │
 ├── Direct group membership
 │       │
 │       └── Permission
 │
 └── Nested group membership
         │
         └── Permission
```

This is why AD enumeration must examine group relationships rather than looking only at individual user attributes.

## Security Assessment Relevance

Important things to inspect in a real assessment include:

- Privileged group membership
- Unexpected membership
- Nested groups
- Service accounts in privileged groups
- Excessive resource permissions
- Delegated administration
- ACLs granted through groups

These relationships form part of the AD attack-path model documented in the lab. fileciteturn4file1

> **Documentation note:** The exact group/member mapping should be taken from the current AD state rather than reconstructed from incomplete notes.
