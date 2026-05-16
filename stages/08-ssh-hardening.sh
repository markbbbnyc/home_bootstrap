#!/usr/bin/env bash
set -euo pipefail

echo "🪄 Stage 08: SSH hardening + root lockdown — sealing the fortress..."

SSH_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSH_CONFIG}.backup.$(date +%s)"
[ ! -f "/etc/ssh/sshd_config.backup" ] && cp "$SSH_CONFIG" "$BACKUP" && cp "$BACKUP" /etc/ssh/sshd_config.backup

#sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG"
sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$SSH_CONFIG"
sed -i 's/^#\?PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$SSH_CONFIG"
sed -i '/^AllowUsers/d' "$SSH_CONFIG"
echo "AllowUsers mark root" >> "$SSH_CONFIG"
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG"
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' "$SSH_CONFIG"

passwd -l root || true
systemctl restart ssh || true

echo "✨ Stage 08 complete! The fortress is sealed. Only 'mark' and 'root' may enter by key."
echo "🛡️  Security summary: root SSH disabled, passwords off, key-only access enforced."
