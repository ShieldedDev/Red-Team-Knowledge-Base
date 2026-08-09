# SMB Shares

## SMB Infrastructure

The Windows Server Domain Controller provides SMB file-sharing services.

```text
Server:
    DC1

Domain:
    evil.corp

Protocol:
    SMB
```

The lab created the following custom SMB share:

```text
steel_mountain
```

## Share Configuration

| Setting | Value |
|---|---|
| Server | `DC1` |
| Volume | `C:` |
| Local path | `C:\Shares\steel_mountain` |
| Share name | `steel_mountain` |
| Network path | `\\DC1\steel_mountain` |
| Protocol | SMB |
| Access-Based Enumeration | Disabled |
| Caching | Enabled |
| BranchCache | Disabled |
| SMB encryption | Disabled |
| Share permission | `Everyone - Full Control` |

These values are directly documented from the completed SMB Share configuration. fileciteturn3file0 fileciteturn3file2

## Share Architecture

```text
                    DC1
                     │
          ┌──────────┴──────────┐
          │                     │
 Local filesystem           SMB service
          │                     │
          ▼                     ▼
C:\Shares\steel_mountain   \\DC1\steel_mountain
                                  │
                                  │ SMB
                                  ▼
                                Client
```

The client accesses the SMB namespace rather than the underlying local filesystem path. fileciteturn3file1

## Share Permissions

The share was created with:

```text
Everyone - Full Control
```

The wizard also showed these folder permissions:

```text
CREATOR OWNER          Full Control
BUILTIN\Users          Special
BUILTIN\Users          Read & execute
BUILTIN\Administrators Full Control
NT AUTHORITY\SYSTEM    Full Control
```

fileciteturn3file0

This is a deliberately broad lab configuration and should not be treated as a production least-privilege design.

## SMB Settings

```text
Access-Based Enumeration: Disabled
Caching:                  Enabled
BranchCache:              Disabled
Encrypt data:             Disabled
```

fileciteturn3file0

## Verification

From a Windows client:

```cmd
net view \\DC1
```

```cmd
dir \\DC1\steel_mountain
```

Map the share:

```cmd
net use Z: \\DC1\steel_mountain
```

Inspect connections:

```cmd
net use
```

Remove the mapping:

```cmd
net use Z: /delete
```

The lab documentation also records Linux-side SMB access using `smbclient` for authorized lab testing. fileciteturn3file1

## Important Security Model

SMB permissions and NTFS permissions are separate layers:

```text
Client
  │
  ▼
SMB Share Permissions
  │
  ▼
NTFS Permissions
  │
  ▼
File / Directory
```

Effective access is determined by the combination of these controls. fileciteturn3file1
