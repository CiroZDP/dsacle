# Custom OS - Technical Overview

This operating system (OS) is designed for high flexibility, modularity, and security. It introduces several innovative features that distinguish it from traditional systems. Below is a technical overview of the key features and capabilities of this OS.

---

## Key Features

### 1. **Dual Kernel Support**
   - **Litek Kernel**: A lightweight, minimalistic kernel loaded into RAM for high-performance tasks and system maintenance operations. This kernel is isolated in a specific partition (`/litek/`) and can operate independently of the primary kernel.
   - **Full Kernel**: A full-featured kernel that runs the user-facing system and supports the entire OS's functionality.
   - **Hot Kernel Switching**: The ability to switch between kernels on the fly, even in a running system. This allows for dynamic kernel upgrades without needing a system reboot.

   **Commands:**
   - `dskmgr id create litek0` - Creates a new identity for a Litek partition.
   - `dskmgr -be -s8 bincpy /litek /litek0` - Binarily copies data from the primary kernel partition to the Litek partition with expansion capability.
   - `dskmgr trunc litek0` - Truncates the Litek partition, releasing unused space.
   - `kernel --hotswap /litek0` - Dynamically swaps to the Litek kernel from the full kernel.

### 2. **User Privilege Management and Session Handling**
   - **Multiple User Accounts**: Users can operate in a secure, partitioned environment. User accounts like `root` and `ciro` manage privileges and access control.
   - **Secure Remote Sessions**: The system supports the creation of secure virtual sessions using the `vsession` command. It allows users to connect to the `root` account securely, whether locally or remotely, for system maintenance and updates.
   - **Login and Session Management**: Users can switch between accounts with the `duser` command, ensuring a smooth and secure user experience while maintaining elevated privileges for administrative tasks.
   - **Root Access**: The `root` account has minimal UI (just a terminal) for maximum security, ensuring that only the necessary system tools are available when logged in as root.

   **Commands:**
   - `vsession -c localhost@root -k admin1234` - Creates a secure session to the `root` account locally, automatically closing the session after use.
   - `duser -l root` - Log in directly as root, triggering the login screen to provide access with a password.

### 3. **Kernel Recovery and Update Mechanism**
   - **Hot Kernel Updates**: The system allows updating the kernel dynamically, without requiring a reboot. The Litek kernel can be updated and swapped into the running system on the fly using a simple command structure.
   - **Kernel Burn-Overwriting**: The system supports a robust way of replacing and updating the kernel using a "burn" process that writes the new kernel binary to the Litek partition.
   - **Custom Recovery Partition**: The system maintains a special partition for recovery and kernel management. If the Litek kernel gets corrupted, recovery can be performed by booting into another OS or using specialized commands.

   **Commands:**
   - `kernel` - Displays information about the current kernel and its location (e.g., `/litek0/base`).
   - `dskmgr burn /litek | stream -s8 /home/ciro/downloads/litek-v1.2.0.bin` - Burns the new kernel binary to the Litek partition in 8-byte chunks.
   - `dsvc stop all` - Stops all services before applying the kernel update.
   - `kernel --hotswap /litek` - Swaps the running kernel with the Litek kernel.
   - `dskmgr drain /litek0` - Clears and sanitizes the Litek partition, ensuring all data is securely erased.

### 4. **Disk Management**
   - **Partition Identity**: Instead of traditional partitions, the OS uses "identities" that can be expanded or converted into full partitions when needed. This allows for greater flexibility in disk management.
   - **Binary Copying and Expansion**: The system supports binary copying from one partition to another, with the ability to expand partition sizes dynamically as needed.
   - **Truncating Partitions**: After data transfer or kernel updates, partitions can be truncated to reclaim unused space.
   - **Disk Management Commands**: Disk operations like binary copying and partition management are carried out with highly optimized commands.

   **Commands:**
   - `dskmgr id create litek0` - Creates an identity for a new partition (Litek).
   - `dskmgr -be -s8 bincpy /litek /litek0` - Copies data binary-wise from `/litek` to `litek0` with expansion capability.
   - `dskmgr trunc litek0` - Truncates the Litek partition.
   - `dskmgr burn /litek | stream -s8 /home/ciro/downloads/litek-v1.2.0.bin` - Burns kernel to the Litek partition in chunks of 8 bytes.

### 5. **Service Management**
   - **Service Management with `dsvc`**: The `dsvc` tool provides management for system services such as HTTP, logging, and background tasks.
   - **Automatic Start and Shutdown**: Services can be started, stopped, or checked using simple commands. If necessary, services can be halted before critical updates or changes.
   - **Service Check**: After applying patches or updates, services can be checked for proper operation to ensure that nothing is broken in the system.

   **Commands:**
   - `dsvc start httpservice` - Starts the HTTP service.
   - `dsvc check httpservice` - Checks if the HTTP service is running correctly.
   - `dsvc stop all` - Stops all active services.

### 6. **Security and Access Control**
   - **GPG Key Support for Remote Access**: GPG keys can be used for remote session management, particularly with `vsession`, where they provide an additional layer of security for remote connections.
   - **Whitelisted Access**: A whitelist ensures only authorized users or devices can access the system remotely.
   - **Immutable Kernel**: While the full kernel is active, it is protected from accidental modification. To apply changes or updates, the user must switch to the Litek kernel or use specific tools to modify the system safely.

   **Commands:**
   - `vsession pv list` - Lists configurable options for preventing security breaches, such as disabling kernel panic or preventing root file deletion.
   - `vsession pv disable ...` - Disables certain security features temporarily (use with caution).
