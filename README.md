[日本語版 README はこちら](https://github.com/hitto-hub/scan_and_ssh/blob/main/README-ja.md)

[English README is here](https://github.com/hitto-hub/scan_and_ssh/blob/main/README.md)

# scan_and_ssh

Just ssh. Nothing else.

## Structure

```md
.
├── README.md
├── scan_and_ssh.sh # Main script
└── key_connect.sh  # Scans hosts, filters by SSH key.
```

## File Overview

### scan_and_ssh.sh

`scan_and_ssh.sh` is a script that scans for hosts with open SSH ports within a specified IP range and attempts to connect via SSH. Users can dynamically specify the IP range, ports to scan, the username for the SSH connection, and the path to the SSH key. It also provides an option to use fzf to easily select hosts or SSH keys. The script lists reachable hosts and attempts to SSH into the selected host.

### key_connect.sh

`key_connect.sh` is a script that scans for hosts that can be accessed using a specified SSH key and lists them. It allows users to specify the IP range and ports for scanning, and then filters the hosts that can be accessed with the selected SSH key. Similar to `scan_and_ssh.sh`, it offers the option to use fzf for convenient host selection.

### Prerequisites

To use `scan_and_ssh.sh` and `key_connect.sh`, the following prerequisites are required:

1. **nmap Installation**  
   The script uses the `nmap` command to scan for hosts. `nmap` must be installed on your system.
   - Installation command (examples):

     ```bash
     sudo apt-get install nmap  # Ubuntu/Debian
     sudo yum install nmap      # CentOS/Fedora
     brew install nmap          # macOS
     ```

2. **fzf Installation** (Optional)  
   `fzf` is used for interactive selection of hosts or SSH keys. It is recommended for ease of use.
   - Installation command (examples):

     ```bash
     sudo apt-get install fzf  # Ubuntu/Debian
     sudo yum install fzf      # CentOS/Fedora
     brew install fzf          # macOS
     ```

3. **SSH Key Setup**  
   You need to have SSH public and private keys configured for the connection. By default, the script uses the key located at `~/.ssh/id_rsa`, but this can be customized.

4. **Accessible Network Environment**  
   The script requires that accessible hosts exist within the specified IP range. Make sure to specify an appropriate network range.

5. **Execution Permissions**  
   You need to grant execution permissions to the script before running it. Use the following command to set the necessary permissions:

   ```bash
   chmod +x scan_and_ssh.sh
   chmod +x key_connect.sh
   ```

By fulfilling these prerequisites, the scripts should run without issues.

## Usage

1. Run `scan_and_ssh.sh` to scan for hosts with open SSH ports and connect to them using the specified SSH key.
2. Use `key_connect.sh` to select from multiple SSH keys and narrow down accessible hosts.
