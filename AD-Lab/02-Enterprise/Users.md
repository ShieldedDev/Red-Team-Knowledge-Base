# Domain Users

## Domain

```text
evil.corp
```

Domain Controller:

```text
DC1
```

The lab uses Active Directory Users and Computers (ADUC) for user administration. fileciteturn2file0

## Users Established in the Lab

The enterprise lab contains the following user identities:

| Full Name | Username | UPN |
|---|---|---|
| Tyrell Wellick | `tyrell` | `tyrell@evil.corp` |
| Gideon Goddard | `ggideon` | `ggideon@evil.corp` |
| Terry Colby | `tcolby` | `tcolby@evil.corp` |
| Elliot Alderson | `elliot` | `elliot@evil.corp` |
| Angela Moss | `angela` | `angela@evil.corp` |
| Philip Price | `pprice` | `pprice@evil.corp` |
| Susan Jacobs | `sjacobs` | `sjacobs@evil.corp` |
| Darlene Alderson | `darlene` | `darlene@evil.corp` |
| Cisco Ramirez | `cramirez` | `cramirez@evil.corp` |
| Leon | `leon` | `leon@evil.corp` |

The original ADUC documentation explicitly demonstrates the creation of Gideon Goddard (`ggideon`), Terry Colby (`tcolby`), and Tyrell Wellick (`tyrell`). fileciteturn2file0

## Default Accounts

The standard domain `Users` container also contains built-in accounts such as:

```text
Administrator
Guest
```

The original lab documentation shows these alongside the created lab accounts. fileciteturn4file0

## User Configuration

The lab exercises included:

- Manual user creation
- Copying an existing user account
- Password configuration
- Moving objects between containers/OUs
- Managing users through ADUC

The demonstrated lab configuration used **Password never expires** for the created user workflow. This is appropriate only for a controlled lab and is not a recommended normal enterprise-user setting. fileciteturn4file0

## User Organization

The enterprise OUs include:

```text
Admins
IT
HR
Finance
Developers
Service Accounts
Groups
Servers
Workstations
```

Users can be placed into the appropriate organizational area so that administrative controls and future Group Policy scope can be managed logically.

## Security Relevance

User identities are the starting point for many AD attack paths:

```text
User
  ↓
Group Membership
  ↓
ACL / Permission
  ↓
Resource
```

Effective access can depend on both direct and nested group membership. fileciteturn2file0
