# DC01 - Domain Controller Setup

> This guide documents the complete deployment and configuration of the **Domain Controller (DC01)** for the **evil.corp** Active Directory Red Team Lab. DC01 serves as the central authentication server, DNS server, and Active Directory infrastructure for all machines in the lab.

---

# Overview

| Property | Value |
|----------|-------|
| Hostname | DC1 |
| Domain | evil.corp |
| NetBIOS Name | E-CORP |
| Operating System | Windows Server 2022 Standard (Desktop Experience) |
| IP Address | 192.168.56.10 |
| DNS Server | Self (192.168.56.10) |
| Server Roles | Active Directory Domain Services, DNS |
| Forest Functional Level | Windows Server 2022 |
| Domain Functional Level | Windows Server 2022 |

---

# Lab Architecture

```
                    evil.corp Active Directory

                               DC1
                      Windows Server 2022
                 AD DS + DNS + File Server
                      192.168.56.10
                             │
         ┌───────────────────┴───────────────────┐
         │                                       │
         │                                       │
    CTO Workstation                       CYDECK Workstation
    Windows 10 Pro                         Windows 10 Pro
    192.168.56.20                          192.168.56.30
      Tyrell Wellick                       Gideon Goddard
```

---

# Prerequisites

Before beginning the installation, ensure the following resources are available.

| Resource | Value |
|-----------|-------|
| Hypervisor | Oracle VirtualBox |
| ISO | Windows Server 2022 |
| CPU | 2 vCPUs |
| RAM | 4 GB |
| Storage | 60 GB |
| Network | Internal Network |

---

# Step 1 - Create the Virtual Machine

Create a new virtual machine in Oracle VirtualBox.

Configure the VM with the following specifications.

| Setting | Value |
|----------|-------|
| Name | DC01 |
| Type | Microsoft Windows |
| Version | Windows Server 2022 (64-bit) |
| Memory | 4096 MB |
| Processor | 2 Cores |
| Disk | 60 GB VDI |
| Network Adapter | Internal Network |

Attach the Windows Server 2022 ISO image.

---

# Step 2 - Install Windows Server

Power on the virtual machine.

Windows Setup will start automatically.

Configure the installation preferences.

| Setting | Value |
|----------|-------|
| Language | English (United States) |
| Time & Currency | English (United States) |
| Keyboard | US |

Click **Next** and then **Install Now**.

---

# Step 3 - Select the Windows Edition

Choose:

```
Windows Server 2022 Standard Evaluation
(Desktop Experience)
```

> **Desktop Experience** provides the graphical user interface, making administration significantly easier for beginners.

---

# Step 4 - Accept the License Agreement

Accept the Microsoft Software License Terms.

Click **Next**.

---

# Step 5 - Installation Type

Select

```
Custom: Install Windows only (Advanced)
```

Choose the primary virtual hard disk.

Windows automatically creates the required partitions.

Click **Next**.

---

# Step 6 - Wait for Installation

Windows will now:

- Copy installation files
- Install required features
- Install updates
- Complete the operating system setup

The virtual machine will restart automatically several times.

---

# Step 7 - Configure Administrator Password

After installation completes, Windows prompts for the Administrator password.

For this lab environment use:

```
Username:
Administrator

Password:
P@$$w0rd!
```

Login using the Administrator account.

---

# Step 8 - Rename the Server

Open

```
Server Manager
    → Local Server
        → Computer Name
            → Change
```

Rename the server to

```
DC1
```

Restart the server when prompted.

---

# Step 9 - Configure a Static IP Address

Open

```
Network Connections
```

Edit the Ethernet adapter and configure the following.

| Setting | Value |
|----------|-------|
| IP Address | 192.168.56.10 |
| Subnet Mask | 255.255.255.0 |
| Default Gateway | Leave Blank |
| Preferred DNS | 192.168.56.10 |

Verify the configuration.

```cmd
ipconfig
```

Expected IPv4 Address:

```
192.168.56.10
```

---

# Step 10 - Install Active Directory Domain Services

Open

```
Server Manager
```

Navigate to

```
Manage
    → Add Roles and Features
```

Install the following role.

```
Active Directory Domain Services
```

Accept all required dependencies.

Click **Install**.

---

# Step 11 - Promote the Server to a Domain Controller

After the installation completes, click

```
Promote this server to a domain controller
```

Choose

```
Add a new forest
```

Specify the root domain name.

```
evil.corp
```

Click **Next**.

---

# Step 12 - Configure Domain Controller Options

Configure the following.

| Setting | Value |
|----------|-------|
| Forest Functional Level | Windows Server 2022 |
| Domain Functional Level | Windows Server 2022 |
| DNS Server | Enabled |
| Global Catalog | Enabled |
| Read Only Domain Controller | Disabled |

---

# Step 13 - Configure DSRM Password

Set the Directory Services Restore Mode password.

For this lab:

```
P@$$w0rd!
```

> In production, this password should be unique and securely stored.

---

# Step 14 - Configure NetBIOS Name

Windows automatically generates the NetBIOS name.

```
E-CORP
```

Accept the default.

---

# Step 15 - Complete the Active Directory Installation

Continue through the remaining configuration pages.

- DNS Options
- Additional Options
- Paths
- Prerequisites Check

Click

```
Install
```

The server will automatically reboot.

---

# Step 16 - Verify the Installation

Login using

```
E-CORP\Administrator
```

Verify the hostname.

```powershell
hostname
```

Expected output

```
DC1
```

Verify the Active Directory domain.

```powershell
Get-ADDomain
```

Expected output

```
evil.corp
```

Verify DNS.

```cmd
nslookup dc1.evil.corp
```

Expected output

```
Server: dc1.evil.corp
Address: 192.168.56.10
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

# Step 17 - Initial Enterprise Configuration

After Active Directory is operational, configure the enterprise structure.

## Create Organizational Units

```
evil.corp

├── Workstations
├── Servers
├── Users
├── Groups
├── Service Accounts
└── Departments
```

---

## Create Security Groups

```
IT

HR

Management
```

---

## Create Domain Users

| User | Username | Department |
|------|----------|------------|
| Tyrell Wellick | tyrell | IT |
| Gideon Goddard | ggideon | HR |
| Terry Colby | tcolby | Management |
| SQL Service | SQLService | Service Account |

---

## Join Client Machines

Join the following computers to the domain.

| Machine | IP Address |
|----------|------------|
| CTO | 192.168.56.20 |
| CYDECK | 192.168.56.30 |

Move both computers into the **Workstations** Organizational Unit.

---

## Configure Shared Folders

Create the following shared folders.

```
C:\Shares\IT

C:\Shares\HR
```

Share them on the network.

```
\\dc1\IT

\\dc1\HR
```

Assign NTFS permissions according to the department security groups.

| Share | Access |
|--------|--------|
| IT | IT Group |
| HR | HR Group |

Verify:

- Tyrell can access only the IT share.
- Gideon can access only the HR share.

---

# Final Configuration

| Component | Status |
|------------|--------|
| Windows Server Installed | Completed |
| Static Networking | Completed |
| DNS Server | Configured |
| Active Directory | Configured |
| Domain | evil.corp |
| NetBIOS | E-CORP |
| Organizational Units | Created |
| Security Groups | Created |
| Domain Users | Created |
| Shared Folders | Configured |
| Client Workstations | Joined |

---

# Lab Credentials

> **Lab credentials used throughout the environment**

| Account | Username | Password |
|----------|----------|----------|
| Domain Administrator | Administrator | P@$$w0rd! |
| Tyrell Wellick | tyrell | olofsson@66 |
| Gideon Goddard | ggideon | Allsafe@123 |
| Terry Colby | tcolby | TechSavy@123 |
| SQL Service | SQLService | mypassword@123 |

---

# Next Steps

With the Domain Controller fully configured, the next phase of the lab includes:

- Deploying workstation security policies
- Configuring SMB shares and permissions
- Implementing Group Policy Objects (GPOs)
- Installing enterprise services
- Simulating common enterprise misconfigurations
- Preparing the environment for Red Team attack scenarios
- Active Directory enumeration
- Kerberoasting
- AS-REP Roasting
- SMB Relay
- BloodHound analysis
- ACL abuse
- Lateral movement
- Privilege escalation
- Persistence techniques
- Blue Team detection exercises

---

# Result

The **DC01** server is now fully operational as the Domain Controller for the **evil.corp** Active Directory lab.

It provides centralized authentication, DNS resolution, directory services, file sharing, and enterprise identity management for all client workstations. This server serves as the foundation for all future Red Team and Blue Team attack simulations documented in this repository.
