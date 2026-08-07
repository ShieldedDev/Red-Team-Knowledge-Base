# CTO Workstation Configuration

This document covers the post-installation configuration performed on the **CTO workstation** after Windows installation.

---

# Machine Information

| Setting | Value |
|---------|-------|
| Computer Name | CTO |
| User | tyrell wellick |
| IP Address | 192.168.56.20 |
| Subnet Mask | 255.255.255.0 |
| Preferred DNS | 192.168.56.10 |
| Domain | (Joined later) |

---

# 1. Configure Static Network

The workstation must communicate with the Domain Controller using a static IPv4 configuration. The Domain Controller also acts as the DNS server for the Active Directory environment.

---

## Step 1 — Verify Initial Network

After Windows installation the workstation receives an unidentified network because no static IP or DNS server has been configured.

![Initial Network](Images/network-nd-sharing.png)

At this stage:

- Network is identified as **Unidentified Network**
- Internet connectivity is unavailable
- Active Directory resources cannot be reached

---

## Step 2 — Open Network Adapter Settings

Navigate to:

```
Settings
    ↓
Network & Internet
    ↓
Advanced Network Settings
    ↓
Change Adapter Options
```

This opens the classic Network Connections window.

![Change Adapter Settings](Images/change-adapter-settings.png)

---

## Step 3 — Open Ethernet Properties

Right-click the Ethernet adapter and select **Properties**.

![Ethernet Properties](Images/properties.png)

The Ethernet Properties window contains all networking protocols installed on the adapter.

---

## Step 4 — Configure IPv4

Select

```
Internet Protocol Version 4 (TCP/IPv4)
```

Click **Properties**.

Configure the following values.

| Setting | Value |
|---------|-------|
| IP Address | 192.168.56.20 |
| Subnet Mask | 255.255.255.0 |
| Default Gateway | Leave Blank |
| Preferred DNS | 192.168.56.10 |
| Alternate DNS | Leave Blank |

The Domain Controller (DC01) acts as the DNS server for all domain clients.

![IPv4 Configuration](Images/set-ip.png)

---

## Step 5 — Save Configuration

Click

```
OK
```

to save the IPv4 configuration.

Windows immediately applies the new networking configuration.

The Ethernet Properties dialog should now show IPv4 configured correctly.

![Ethernet Adapter](Images/ipv4-settings.png)

---

## Step 6 — Verify Configuration

Open Command Prompt and execute:

```cmd
ipconfig
```

Expected output:

```
IPv4 Address . . . . . . . : 192.168.56.20
Subnet Mask . . . . . . . : 255.255.255.0
Preferred DNS . . . . . . : 192.168.56.10
```

Verify that the IP address matches the configuration assigned earlier.

![Verify Configuration](Images/ipconfig.png)

---

## Result

The CTO workstation is now configured with a static IPv4 address and uses the Domain Controller as its DNS server.

This configuration allows the workstation to:

- Resolve Active Directory DNS records
- Locate the Domain Controller
- Join the Active Directory domain
- Access enterprise resources such as shared folders and authentication services
