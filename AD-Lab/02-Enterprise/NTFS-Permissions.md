# NTFS Permissions

## Scope

The SMB share created in this lab is backed by:

```text
C:\Shares\steel_mountain
```

and published as:

```text
\\DC1\steel_mountain
```

The underlying filesystem is NTFS. The SMB wizard showed the selected `C:` volume as NTFS. fileciteturn3file0

## Permission Layers

Windows file-share authorization uses multiple permission layers.

```text
Client
  │
  ▼
SMB Share Permissions
  │
  ▼
NTFS / Folder Permissions
  │
  ▼
File
```

Share permissions and NTFS permissions are independent controls. Effective access is based on the resulting combination. fileciteturn3file1

## Documented Folder Permissions

The SMB Share Wizard displayed the following folder permissions:

| Principal | Access |
|---|---|
| `CREATOR OWNER` | Full Control |
| `BUILTIN\Users` | Special |
| `BUILTIN\Users` | Read & execute |
| `BUILTIN\Administrators` | Full Control |
| `NT AUTHORITY\SYSTEM` | Full Control |

fileciteturn3file0

The share-level permission was:

```text
Everyone - Full Control
```

Therefore the lab currently demonstrates a broad share configuration rather than a hardened least-privilege ACL model. fileciteturn3file0

## Effective Access

A user can have:

```text
SMB Share:
    Full Control

NTFS:
    Read
```

and still be unable to write to the file because the NTFS layer is more restrictive.

The important principle is:

```text
Effective Access
    =
Share Permission
    +
NTFS Permission
```

with the effective result constrained by the more restrictive applicable permission. fileciteturn3file1

## Current Resource

```text
Server:
    DC1

Filesystem:
    NTFS

Directory:
    C:\Shares\steel_mountain

SMB:
    \\DC1\steel_mountain
```

## Security Relevance

NTFS ACLs are important during Active Directory security assessments because permissions may be inherited or granted through:

- Individual users
- Security groups
- Built-in groups
- Nested groups
- Service accounts

An apparently low-privileged user can therefore obtain significant resource access through group membership or an incorrectly configured ACL.

## Verification

On the Windows server, the underlying ACL can be inspected through the folder's **Security** properties.

PowerShell can also be used to inspect ACLs:

```powershell
Get-Acl C:\Shares\steel_mountain
```

For a more detailed ACL view:

```powershell
(Get-Acl C:\Shares\steel_mountain).Access
```

From a client, verify the actual effective behavior through the SMB path:

```cmd
dir \\DC1\steel_mountain
```

and, where the test account is intentionally permitted to write:

```cmd
echo SMB test > \\DC1\steel_mountain\test.txt
```

The lab documentation specifically recommends verifying the share from both the server and a client. fileciteturn3file3

> **Documentation note:** The available lab notes preserve the permissions displayed during SMB-share creation, but do not preserve a complete custom NTFS ACL matrix beyond that screenshot. No additional ACL assignments are invented here.
