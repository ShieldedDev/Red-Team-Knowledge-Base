# CTO Workstation Setup

> This document demonstrates the complete deployment and configuration of the **CTO workstation** in the Active Directory lab environment. This workstation represents the Chief Technology Officer's system inside the fictional **evil.corp** enterprise inspired by *Mr. Robot*.

---

# Overview

| Property | Value |
|----------|-------|
| Hostname | CTO |
| Operating System | Windows 10 Pro (22H2) |
| Domain | evil.corp |
| IP Address | 192.168.56.20 |
| DNS Server | 192.168.56.10 |
| Domain Controller | DC1.evil.corp |
| Domain User | tyrell |
| Local Administrator | Administrator |

---

# Prerequisites

Before beginning, ensure the following are available.

- Oracle VirtualBox
- Windows 10 Pro ISO
- Active Directory Domain Controller already deployed
- Internal Network configured inside VirtualBox
- Static IP plan prepared

---

# Step 1 — Create the Virtual Machine

Open **Oracle VirtualBox** and create a new virtual machine.

Configure the virtual machine as follows.

| Setting | Value |
|----------|--------|
| Name | CTO |
| Type | Microsoft Windows |
| Version | Windows 10 (64-bit) |
| Memory | 2-4 GB |
| Processors | 2 |
| Disk Size | 40 GB (VDI) |

Select the downloaded Windows ISO.

Leave **Proceed with Unattended Installation** unchecked since the workstation will be configured manually.

![](Images/win10-iso.png)

---

# Step 2 — Boot from the Windows Installation ISO

Power on the virtual machine.

Windows Setup will start automatically.

Choose the following settings.

| Setting | Value |
|----------|-------|
| Language | English (United States) |
| Time Format | English (United States) |
| Keyboard | US |

Click **Next**.

![](Images/select_region.png)

---

# Step 3 — Start Windows Installation

Click **Install Now** to begin the installation.

![](Images/install_now.png)

---

# Step 4 — Skip Product Activation

Since this workstation exists only for a lab environment, Windows activation is unnecessary.

Click

**I don't have a product key**

to continue.

![](Images/windows_key.png)

---

# Step 5 — Select Windows Edition

Select

**Windows 10 Pro**

then click **Next**.

> Windows Home editions cannot join an Active Directory domain, therefore Windows Pro is required.

![](Images/select-win-10-pro.png)

---

# Step 6 — Accept the License Agreement

Read and accept the Microsoft License Agreement.

Click **Next**.

![](Images/agree_and_tick(1).png)

---

# Step 7 — Choose Installation Type

Select

**Custom: Install Windows only (Advanced)**

This performs a clean installation instead of attempting an upgrade.

![](Images/custom_options.png)

---

# Step 8 — Select Installation Partition

Choose the primary virtual disk.

Click **Next**.

Windows will automatically create the required partitions.

![](Images/partiotions.png)

---

# Step 9 — Install Windows

Windows now copies installation files, installs required features, installs updates, and prepares the operating system.

The virtual machine will automatically reboot multiple times.

![](Images/installting.png)

---

# Step 10 — Select Region

After installation completes, Windows enters the Out-of-Box Experience (OOBE).

Choose

**United States**

and continue.

![](Images/select_region-after-installing.png)

---

# Step 11 — Configure Keyboard Layout

Select

**US Keyboard**

Click **Yes**.

![](Images/keyboard-layout.png)

---

# Step 12 — Create a Temporary Local User

Before joining the workstation to Active Directory, Windows requires creation of a local user account.

For this lab:

| Username |
|-----------|
| Tyrell W |

This account is temporary and will only be used during the initial workstation configuration.

After the workstation joins the domain, authentication will occur using Active Directory accounts.

![](Images/username.png)

---

# Step 13 — Configure Privacy Settings

Disable all optional privacy settings.

Recommended configuration:

- Location → Off
- Find My Device → Off
- Diagnostic Data → Required Only
- Tailored Experiences → Off
- Advertising ID → Off
- Ink & Typing Personalization → Off

Click **Accept**.

![](Images/privacy-settings.png)

---

# Step 14 — Verify Installation

Windows should now boot successfully to the desktop.

At this stage the workstation is standalone and is **not yet joined to the Active Directory domain**.

![](Images/successfully_installed.png)

---

# Step 15 — Rename the Computer

Navigate to

```
Settings
    → System
        → About
            → Rename this PC
```

Rename the workstation as

```
CTO
```

Restart the computer when prompted.

![](Images/rename-pc.png)

---

# Current State

The workstation has now been successfully installed and prepared.

Current configuration:

| Setting | Value |
|----------|-------|
| Hostname | CTO |
| Windows Version | Windows 10 Pro |
| Local Account | Tyrell W |
| Domain Joined | No |
| Static IP | Pending |
| DNS Configuration | Pending |

---

# Next Steps

The workstation installation is now complete.

The following configuration tasks will be performed in the next section.

- Configure a Static IP Address
- Configure DNS
- Verify connectivity to the Domain Controller
- Join the workstation to the **evil.corp** Active Directory domain
- Verify successful domain authentication
- Log in using the **tyrell** domain account
- Verify access to enterprise network resources

---

# Result

The CTO workstation is now fully installed and ready to become a managed Active Directory client inside the **evil.corp** enterprise lab.
