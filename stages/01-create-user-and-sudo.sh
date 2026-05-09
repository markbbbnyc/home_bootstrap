#!/usr/bin/env bash
set -euo pipefail

echo "🪄 Stage 01: Create user 'mark', sudo access & harden SSH — weaving the first threads..."

apt-get update -qq

if ! id -u mark &>/dev/null; then
    echo "🧙‍♂️ Creating user 'mark'..."
    useradd -m -s /usr/bin/bash mark
    echo "mark ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/mark
    chmod 440 /etc/sudoers.d/mark
else
    echo "🐌 User 'mark' already exists — skipping safely."
fi

# Set root password interactively (only if not already set)
if [ ! -f /root/.root_password_set ]; then
    echo "🔐 Setting new root password (interactive)..."
    passwd root
    touch /root/.root_password_set
fi

# Install SSH key for mark (idempotent)
mkdir -p /home/mark/.ssh
cat > /home/mark/.ssh/authorized_keys << 'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG3otktoD1Stvuci/JSYN0JanuWnCceBrmDgs0/Z5xo
EOF
chmod 700 /home/mark/.ssh
chmod 600 /home/mark/.ssh/authorized_keys
chown -R mark:mark /home/mark/.ssh

# Harden SSH
if ! grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
fi

systemctl restart ssh || true
echo "✨ Stage 01 complete! 'mark' is born and the gates are fortified."
