#!/bin/bash

# Function to run a command and exit on failure
run_cmd() {
    echo "Running: $1"
    if ! eval "$1"; then
        echo "❌ Failed: $1"
        exit 1
    fi
}

# Function to run a command without exiting on failure
run_cmd_nonfatal() {
    echo "Running: $1"
    if ! eval "$1"; then
        echo "⚠️ Failed: $1, continuing..."
    fi
}

# Check if a command is installed
is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# Detect Python
is_python_installed() {
    is_installed python3 || is_installed python
}

# Detect distro
detect_linux_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo ""
    fi
}

# Install Python
install_python() {
    case "$1" in
        ubuntu)
            run_cmd "sudo apt update"
            run_cmd "sudo apt install -y python3 python3-pip"
            ;;
        arch)
            run_cmd "sudo pacman -Syyu --noconfirm"
            run_cmd "sudo pacman -S --noconfirm python python-pip"
            ;;
        *)
            echo "Unsupported distro: $1"
            exit 1
            ;;
    esac
}

# Setup Flatpak
setup_flatpak() {
    if ! is_installed flatpak; then
        echo "Installing Flatpak..."
        case "$1" in
            ubuntu)
                run_cmd "sudo apt install -y flatpak"
                ;;
            arch)
                run_cmd "sudo pacman -S --noconfirm flatpak"
                ;;
        esac
    fi
    run_cmd_nonfatal "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
}

# Refresh Arch mirrors
refresh_arch_mirrors() {
    run_cmd_nonfatal "sudo pacman -Syy"
    if ! is_installed reflector; then
        run_cmd "sudo pacman -S --noconfirm reflector rsync"
    fi
    run_cmd_nonfatal "sudo reflector --country US,IN --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"
}

# Install pentesting tools
install_pentest_tools() {
    echo "Installing tools for $1..."
    case "$1" in
        ubuntu)
            run_cmd "sudo apt update"
            run_cmd "sudo apt install -y nmap wireshark aircrack-ng metasploit-framework sqlmap hydra john nikto burpsuite gobuster dirb wpscan git vim neovim clang gcc python3-pip default-jdk ufw kismet"
            run_cmd "sudo snap install zap-owasp"
            ;;
        arch)
            refresh_arch_mirrors
            run_cmd "sudo pacman -S --noconfirm nmap wireshark-qt aircrack-ng metasploit sqlmap hydra john nikto gobuster wpscan git vim neovim clang gcc python-pip jdk-openjdk ufw kismet"
            if ! is_installed yay; then
                run_cmd "sudo pacman -S --noconfirm base-devel git"
                run_cmd "git clone https://aur.archlinux.org/yay.git /tmp/yay"
                run_cmd "cd /tmp/yay && makepkg -si --noconfirm"
            fi
            for tool in burpsuite owasp-zap dirb; do
                if ! is_installed $tool; then
                    run_cmd "yay -S --noconfirm $tool"
                fi
            done
            ;;
        *)
            echo "Unsupported distro"
            return
            ;;
    esac

    setup_flatpak "$1"
    for app in "com.google.Chrome" "org.mozilla.firefox"; do
        run_cmd_nonfatal "flatpak install -y flathub $app"
    done

    echo "Installing Python pentest tools..."
    if is_python_installed; then
        if [ "$1" = "ubuntu" ]; then
            run_cmd "pip3 install --user requests scapy pwntools"
        elif [ "$1" = "arch" ]; then
            if ! is_installed pipx; then
                run_cmd "sudo pacman -S --noconfirm python-pipx"
            fi
        fi
    fi
    
    echo "Configuring firewall..."
    run_cmd_nonfatal "sudo ufw enable"
    run_cmd_nonfatal "sudo ufw default deny incoming"
    run_cmd_nonfatal "sudo ufw default allow outgoing"
}

# Main
main() {
    if [ "$(uname)" != "Linux" ]; then
        echo "Only for Linux systems."
        exit 1
    fi

    distro=$(detect_linux_distro)
    if [ -z "$distro" ]; then
        echo "Distro detection failed."
        exit 1
    fi
    echo "Detected: $distro"

    if ! is_python_installed; then
        echo "Python not found. Installing..."
        install_python "$distro"
    else
        echo "✅ Python installed"
    fi

    install_pentest_tools "$distro"

    echo "✅ Pentesting setup complete. Tools installed for:
    - Web Pentesting: Burp Suite, ZAP, Gobuster, Dirb, Nikto, WPScan
    - Network: Nmap, Wireshark, Scapy
    - Wi-Fi: Aircrack-ng, Kismet
    - Exploitation: Metasploit, Hydra, John, Pwntools
    - SQLi: SQLmap
    - Dev: Git, Vim, Clang, Python3, Java
    - Browsers: Chrome, Firefox via Flatpak
    🔐 UFW configured"
}

main
