# CYDECK Workstation Setup

> This document describes the deployment and configuration of the **CYDECK workstation** within the **evil.corp** Active Directory lab. CYDECK represents the Human Resources department workstation used by **Gideon Goddard**.

---

# Overview

| Property | Value |
|----------|-------|
| Hostname | CYDECK |
| Operating System | Windows 10 Pro (22H2) |
| Domain | evil.corp |
| IP Address | 192.168.56.30 |
| DNS Server | 192.168.56.10 |
| Domain Controller | DC1.evil.corp |
| Primary Domain User | ggideon |
| Character | Gideon Goddard |
| Department | Human Resources |

---

# Lab Position

```
                evil.corp
                    │
         ┌──────────┴──────────┐
         │                     │
      DC1 (Server)         Client Systems
     192.168.56.10
                               │
              ┌────────────────┴─────────────┐
              │                              │
        CTO Workstation               CYDECK Workstation
       192.168.56.20                 192.168.56.30
           Tyrell                     Gideon
```

---

# Installation

The operating system installation process for CYDECK is **identical** to the CTO workstation.

Please follow the complete installation guide documented in:

```
01-Setup/
    └── CTO.md
```

This includes:

- Creating the Virtual Machine
- Installing Windows 10 Pro
- Disk Partitioning
- Initial Windows Configuration
- Privacy Settings
- First Login
- Renaming the Computer

The only differences are shown below.

---

# Differences from CTO

## Computer Name

Rename the workstation to

```
CYDECK
```

instead of

```
CTO
```

---

## Temporary Local User

Create the temporary Windows account as

```
Gideon Goddard
```

or simply

```
ggideon
```

This account exists only until the workstation joins the Active Directory domain.

---

## Static Network Configuration

Configure the network adapter with the following settings.

| Setting | Value |
|----------|-------|
| IP Address | 192.168.56.30 |
| Subnet Mask | 255.255.255.0 |
| Gateway | (Leave Blank) |
| Preferred DNS | 192.168.56.10 |

Verify connectivity.

```cmd
ping dc1.evil.corp
```

Expected output:

```
Reply from 192.168.56.10
```

---

# Join the Active Directory Domain

Open

```
Settings
    → System
        → About
            → Rename this PC (Advanced)
```

Select

```
Change...
```

Choose

```
Domain
```

Enter

```
evil.corp
```

When prompted for credentials, authenticate using the Domain Administrator.

```
Username

Administrator

Password

P@$$w0rd!
```

After successful authentication Windows displays

```
Welcome to the evil.corp domain.
```

Restart the workstation.

---

# Login Using Domain Account

After reboot choose

```
Other User
```

Log in using

```
Username

evil\ggideon

Password

Allsafe@123
```

or

```
ggideon@evil.corp
```

---

# Verify Domain Membership

Open Command Prompt.

Run

```cmd
whoami
```

Expected output

```
evil\ggideon
```

Check the computer name.

```cmd
hostname
```

Expected output

```
CYDECK
```

Verify the Active Directory domain.

```cmd
echo %USERDOMAIN%
```

Expected output

```
EVIL
```

Verify the Domain Controller.

```cmd
nltest /dsgetdc:evil.corp
```

Expected output

```
DC: \\DC1.evil.corp
Address: \\192.168.56.10
```

---

# Verify Network Shares

Open Run

```
Win + R
```

Enter

```
\\dc1.evil.corp
```

Authenticate using

```
evil\ggideon
```

Expected access

| Share | Access |
|--------|--------|
| HR | ✅ Allowed |
| IT | ❌ Access Denied |

This verifies that the Human Resources permissions have been applied correctly through Active Directory security groups.

---

# Final Configuration

| Setting | Value |
|----------|-------|
| Computer Name | CYDECK |
| IP Address | 192.168.56.30 |
| Domain | evil.corp |
| Logged-in User | ggideon |
| Department | Human Resources |
| Domain Joined | Yes |
| DNS | 192.168.56.10 |
| Accessible Share | HR |
| Restricted Share | IT |

---

# Machine Role

CYDECK represents the Human Resources workstation inside the enterprise lab.

This machine will later be used for:

- Initial Access simulations
- SMB enumeration
- Lateral Movement
- BloodHound collection
- Kerberoasting
- Credential Hunting
- Pass-the-Hash attacks
- PowerShell Remoting
- WinRM abuse
- ACL Abuse
- Active Directory privilege escalation
- Blue Team detection exercises

---

# Result

The CYDECK workstation is fully configured and successfully joined to the **evil.corp** Active Directory domain.

It now serves as the Human Resources client machine for future Red Team attack simulations throughout the lab.
