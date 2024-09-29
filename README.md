# OpenVPN CLI Manager
The OpenVPN CLI Manager is a Python command-line tool designed to manage your OpenVPN connections effectively. It provides an easy way to list, connect, and disconnect from .ovpn files. The tool also supports multiple locations for .ovpn configuration files, making it flexible and adaptable to different setups.

## Features
- List Available VPN Configurations: Displays all available VPN configuration files, including their server IPs.
- Connect to a VPN: Easily connect to a VPN using a specified .ovpn file.
- Disconnect from VPN: Quickly disconnect from the active VPN connection.
- Multiple Directory Support: Supports VPN configuration files in multiple locations:
    - Current directory (./.vpn)
    - Parent directory (../.vpn)
    - Default home directory (~/.vpn)

## Prerequisites
To use this tool, you need:

1. Python 3.x installed on your system.

2. OpenVPN installed and properly configured (sudo apt-get install openvpn for Ubuntu/Debian-based systems).

3. Rich library for the enhanced CLI interface. You can install it using:

```sh
pip install rich
```
## Installation
1. Clone or Download the script to your local machine.
2. Run installer
```sh
    sudo bash install.sh
```
3. Save your .ovpn files in one of the following locations:
    - ~/.vpn (default directory)
    - ./.vpn (current directory)
    - ../.vpn (parent directory)

## Directory Selection Logic
The tool will look for VPN files in the following order:

- Current Directory (./.vpn): If a .vpn file is found in the current working directory, this will be used.
- Parent Directory (../.vpn): If there is no .vpn file in the current directory, it checks the parent directory.
- Default Directory (~/.vpn): If neither ./.vpn nor ../.vpn is available, the tool will use the default ~/.vpn directory.
## Usage
### General Command Structure
```sh
vpn [option]
```
### Available Options
List All Available VPN Connections:

Lists all available .ovpn files in the specified directory, showing their file names and server IP addresses.

```sh
vpn --
```
Example output:

```arduino
Available VPN Connections
─────────────────────────────────────────
No.  File Name             Server IP
1    myvpn1                192.168.1.10
2    myvpn2                vpn.example.com
```
### Connect to a VPN:

Connect to a VPN using a specified .ovpn file.

```sh
vpn --connect 
```
Replace your_vpn_file_name with the actual name of the VPN file you want to use. For example:

```sh
vpn --connect myvpn1
```
This command will use sudo to initiate the VPN connection using OpenVPN.

### Disconnect from VPN:

Disconnect from the current VPN connection.

```sh
vpn --disconnect
```
### Example Usage
Listing VPN Files
To list all VPN files available:

```sh
vpn --list
```
### Connecting to a VPN
To connect to a VPN called myvpn1:

```sh
vpn --connect myvpn1
```
### Disconnecting from a VPN
To disconnect from an active VPN connection:

```sh
vpn --disconnect
```
## Code Overview
1. Importing Modules
os, subprocess, Path (from pathlib): Used for file and system operations.
rich.console.Console and rich.table.Table: Used for creating a visually appealing console interface.
argparse: Used for command-line argument parsing.
2. Setting VPN Directory
The script looks for .ovpn files in several potential locations and sets the VPN directory accordingly:

```python
DEFAULT_VPN_DIRECTORY = Path.home() / ".vpn"
CURRENT_VPN_FILE = Path("./.vpn")
PARENT_VPN_DIRECTORY = Path("../.vpn")

if CURRENT_VPN_FILE.exists():
    VPN_DIRECTORY = CURRENT_VPN_FILE
elif PARENT_VPN_DIRECTORY.exists():
    VPN_DIRECTORY = PARENT_VPN_DIRECTORY
else:
    VPN_DIRECTORY = DEFAULT_VPN_DIRECTORY
```
3. Listing VPN Configurations
The list_vpns() function creates a table of all .ovpn files found in the selected directory:

```python
def list_vpns():
    table = Table(title="Available VPN Connections")
    table.add_column("No.", justify="right")
    table.add_column("File Name", justify="left")
    table.add_column("Server IP", justify="left")

    vpn_files = list(VPN_DIRECTORY.glob("*.ovpn"))
    if not vpn_files:
        console.print("[red]No VPN files found in the directory![/red]")
        return

    for idx, vpn_file in enumerate(vpn_files, 1):
        server_ip = get_server_ip(vpn_file)
        table.add_row(str(idx), vpn_file.name, server_ip)

    console.print(table)
```
4. Extracting Server IP
The get_server_ip(vpn_file) function extracts the server IP address from the .ovpn configuration file:

```python
def get_server_ip(vpn_file):
    with open(vpn_file, "r") as file:
        for line in file:
            if line.startswith("remote"):
                return line.split()[1]
    return "[yellow]Unknown[/yellow]"
```
5. Connecting and Disconnecting from VPN
connect_vpn(vpn_name): Connects to a specified VPN configuration file using openvpn.

```python
subprocess.run(f"sudo openvpn --config {vpn_file}", shell=True, check=True)
disconnect_vpn(): Disconnects by killing any openvpn processes.
```
```python
subprocess.run(["sudo", "pkill", "openvpn"], check=True)
```
### Security Note
- Root Access: Connecting to or disconnecting from a VPN requires root privileges. This script uses sudo for commands that require administrative rights.
- VPN File Storage: Make sure your .ovpn files are stored securely to prevent unauthorized access.
Troubleshooting
- Permission Issues: If you encounter permission errors, ensure your user has access to run sudo commands, and that openvpn is installed correctly.
VPN Not Found: If the script cannot find a .ovpn file, double-check the specified folder locations (~/.vpn, ./.vpn, ../.vpn).