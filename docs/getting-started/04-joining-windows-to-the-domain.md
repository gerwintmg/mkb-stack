# Joining Windows to the Domain

This guide explains how to join a Windows computer to the mkb-stack domain. This process is essential for accessing network resources and enabling single sign-on.

> [!IMPORTANT]
> The initial domain join and the first login for any user on a new machine **must be performed on the local network** (e.g., in the office). This is a one-time requirement per machine and user.

## The "Chicken and Egg" Problem: How Remote Login Works

A common point of confusion is how a user can log into their domain account when they are not in the office and not yet connected to the VPN. The solution is **cached credentials**.

1.  **First Login on Local Network:** When a user logs into a domain-joined computer for the first time while connected to the local network, Windows communicates with the Samba domain controller. After successful authentication, Windows securely saves (caches) the user's login information on the computer.

2.  **Subsequent Logins (Remote):** When the user is working remotely, Windows will first try to contact the domain controller. If it can't be reached, Windows will use the cached credentials to log the user in. The user can then access their local files and applications.

3.  **Connecting the VPN:** After logging into Windows, the user must manually start their WireGuard client to connect to the office network. Once the VPN is connected, they will be able to access all network resources, such as file shares.

## Step-by-Step: Joining a Windows PC to the Domain

**Prerequisites:**

*   The Windows computer must be connected to the local network.
*   You must have the Samba domain name and the credentials for a domain administrator account.

1.  **Open System Properties:**
    *   Press `Win + R`, type `sysdm.cpl`, and press Enter.

2.  **Change Computer Name/Domain:**
    *   In the "Computer Name" tab, click the "Change..." button.

3.  **Join the Domain:**
    *   In the "Member of" section, select "Domain".
    *   Enter the Samba domain name (e.g., `EXAMPLE.LAN`) and click "OK".

4.  **Enter Administrator Credentials:**
    *   You will be prompted to enter the username and password of an account with permission to join the domain. Use the domain administrator account (e.g., `Administrator`).

5.  **Restart:**
    *   You will be welcomed to the domain. Click "OK" and restart the computer when prompted.

## First Login for a Domain User

After the computer has been joined to the domain and restarted, the user can log in with their domain account.

1.  On the Windows login screen, select "Other user".
2.  Enter the username in the format `DOMAIN\username` (e.g., `EXAMPLE\gerwin`).
3.  Enter the user's password.

This first login must also be done on the local network to cache the user's credentials.

After completing these steps, the user can take the computer home, log in with their cached credentials, and then connect to the VPN.
