#!/bin/bash
set -euo pipefail

echo ">>> Stage 01: Create user 'mark', sudo access, root password, and harden SSH"

# Update package list once at the very beginning
apt-get update -qq

# 1. Create user mark if it doesn't exist
if ! id -u mark &>/dev/null; then
    echo "Creating user 'mark'..."
    useradd -m -s /usr/bin/bash mark
    echo "mark ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/mark
    chmod 440 /etc/sudoers.d/mark
fi

# 2. Change root password (interactive, only once)
#if [ ! -f /root/.root_password_set ]; then
#    echo "=== Set new root password ==="
#    passwd root
#    touch /root/.root_password_set
#fi

## 3. Setup SSH key for mark (idempotent)
mkdir -p /home/mark/.ssh
cat > /home/mark/.ssh/authorized_keys << 'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG3otktoD1Stvuci/JSYN0JanuWnCceBrmDgs0/Z5xo
EOF

chmod 700 /home/mark/.ssh
chmod 600 /home/mark/.ssh/authorized_keys
chown -R mark:mark /home/mark/.ssh

# 4. Harden SSH - disable root login and password auth
if ! grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
fi

# Restart SSH only if config changed
if systemctl restart ssh; then
    echo "SSH hardened (root login disabled)"
fi

# 5. Make sure zsh is installed early
if ! command -v bash &>/dev/null; then
    apt-get install -y bash
fi

echo "✓ User 'mark' created, SSH key installed, root access hardened."
