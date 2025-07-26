# Pentesting Setup Script

## Overview
This Bash script automates the setup of a Linux system for penetration testing by installing essential tools, configuring Python, setting up Flatpak for browser installations, and enabling a basic firewall configuration with UFW. It supports Ubuntu and Arch Linux distributions.

## Prerequisites
- **Operating System**: Linux (Ubuntu or Arch Linux)
- **Root Privileges**: The script requires `sudo` access for installing packages and configuring the system.
- **Internet Connection**: Required for downloading packages and Flatpak repositories.
- **Disk Space**: Ensure sufficient disk space (at least 5-10 GB recommended) for tools and dependencies.

## Usage
1. **Download the Script**:
   Save the script as `cyber_setup.sh` or clone the repository if available.

2. **Make the Script Executable**:
   ```bash
   chmod +x cyber_setup.sh
   ```

3. **Run the Script**:
   ```bash
   ./cyber_setup.sh
   ```

   The script will:
   - Detect the Linux distribution (Ubuntu or Arch).
   - Install Python if not already installed.
   - Install pentesting tools, browsers via Flatpak, and Python libraries.
   - Configure UFW (Uncomplicated Firewall) with default rules.

4. **Verify Installation**:
   After completion, the script outputs a summary of installed tools and their categories. Check for any error messages during execution.

## Supported Distributions
- **Ubuntu** (tested on LTS versions)
- **Arch Linux** (including AUR support via `yay`)

Other distributions are not supported and will result in an error.

## Installed Tools
The script installs the following tools, categorized by their purpose:

### Web Pentesting
- **Burp Suite**: Web vulnerability scanner
- **OWASP ZAP**: Web application security scanner (via Snap on Ubuntu, AUR on Arch)
- **Gobuster**: Directory/file enumeration
- **Dirb**: Web content scanner (via AUR on Arch)
- **Nikto**: Web server scanner
- **WPScan**: WordPress vulnerability scanner

### Network Pentesting
- **Nmap**: Network exploration and port scanning
- **Wireshark**: Network protocol analyzer
- **Scapy**: Packet manipulation (via Python)

### Wi-Fi Pentesting
- **Aircrack-ng**: Wi-Fi security testing suite
- **Kismet**: Wireless network detector

### Exploitation
- **Metasploit Framework**: Penetration testing framework
- **Hydra**: Password cracking tool
- **John the Ripper**: Password cracker
- **Pwntools**: Exploit development library (via Python)

### SQL Injection
- **SQLmap**: Automated SQL injection tool

### Development Tools
- **Git**: Version control
- **Vim/Neovim**: Text editors
- **Clang/GCC**: Compilers
- **Python 3**: With `pip` for package management
- **Java (OpenJDK)**: For Java-based tools

### Browsers
- **Google Chrome**: Installed via Flatpak
- **Mozilla Firefox**: Installed via Flatpak

### Additional
- **UFW**: Configured to deny incoming and allow outgoing traffic
- **Python Libraries**: `requests`, `scapy`, `pwntools` (Ubuntu only, extendable for Arch)

## Notes
- **Error Handling**: The script exits on critical failures (e.g., package installation errors) but continues for non-critical tasks (e.g., Flatpak browser installation).
- **Arch Linux**: Uses `yay` for AUR packages (`burpsuite`, `owasp-zap`, `dirb`). Ensure a stable internet connection for AUR builds.
- **Ubuntu**: Some tools (e.g., `burpsuite`) may require additional repositories or manual installation if not available in default repos.
- **Firewall**: UFW is enabled with default rules. Add specific rules (e.g., `sudo ufw allow 22` for SSH) as needed.
- **Security**: Run this script in a controlled environment (e.g., VM) to avoid unintended system changes. Pentesting tools should be used ethically and legally.

## Troubleshooting
- **Package Installation Fails**: Check internet connectivity and repository availability. For Ubuntu, run `sudo apt update` manually; for Arch, ensure `pacman` mirrors are up-to-date.
- **AUR Issues**: If `yay` fails, manually install dependencies or check AUR package status.
- **Python Tools**: On Arch, Python tools are not installed by default. Add `pipx runpip` commands if needed.
- **Verification**: The script verifies `john` and `hydra` installations. Check output for confirmation.

## Contributing
Feel free to submit issues or pull requests to improve the script, add support for other distributions, or include additional tools.

## License
This script is provided under the MIT License. Use it responsibly and in compliance with applicable laws.