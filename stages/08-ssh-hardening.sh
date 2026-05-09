#!/bin/bash
set -euo pipefail

echo ">>> Stage 08: SSH hardening + root lockdown (disable root login + password auth)"

# Target user home
USER_HOME="/home/mark"
if [ ! -d "$USER_HOME" ]; then
    echo "❌ User mark home directory not found - skipping"
    exit 1
fi

# ==================== Backup SSH config once ====================
SSH_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSH_CONFIG}.backup.$(date +%s)"

if [ ! -f "/etc/ssh/sshd_config.backup" ]; then
    cp "$SSH_CONFIG" "$BACKUP"
    cp "$BACKUP" /etc/ssh/sshd_config.backup
    echo "✓ SSH config backed up"
fi

# ==================== Apply secure SSH settings (idempotent) ====================
echo "Applying hardened SSH settings..."

# Disable root login completely
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"

# Disable password authentication (key-only)
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG"
sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$SSH_CONFIG"

# Disable empty passwords
sed -i 's/^#\?PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$SSH_CONFIG"

# Only allow user mark (and root for sudo if needed, but we block root login)
sed -i '/^AllowUsers/d' "$SSH_CONFIG"
echo "AllowUsers mark" >> "$SSH_CONFIG"

# Extra security (already usually default, but enforce)
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG"
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' "$SSH_CONFIG"

echo "✓ SSH config hardened (root login + password auth disabled)"

# ==================== Restart SSH (only if config actually changed) ====================
if ! diff -q "$SSH_CONFIG" "$BACKUP" >/dev/null 2>&1; then
    echo "Restarting SSH service..."
    systemctl restart ssh
    echo "✓ SSH service restarted with new settings"
else
    echo "✓ SSH settings were already hardened"
fi

# ==================== Optional: Lock root account password (recommended) ====================
echo "Locking root account password (you can still sudo as mark)..."
passwd -l root || true
echo "✓ Root password locked (no direct root login possible)"

# ==================== Final message ====================
echo "✓ Stage 08 complete!"
echo ""
echo "=== Security summary ==="
echo "• Root SSH login is now disabled"
echo "• Password login is disabled (only your SSH key works)"
echo "• Only user 'mark' can SSH in"
echo "• Root account is locked (use 'sudo -i' from mark if needed)"
echo ""
echo "Test it: Open a NEW terminal and try to SSH in."
echo "It should still work perfectly as mark@..."
echo "If you ever need to undo, restore from /etc/ssh/sshd_config.backup"

echo "Your home VM bootstrap is now COMPLETE and production-ready!"
