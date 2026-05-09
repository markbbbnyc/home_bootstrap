#!/bin/bash
set -euo pipefail

echo ">>> Stage 07: GitHub access (git config + dedicated SSH key for the VM)"

# Target user home
USER_HOME="/home/mark"
if [ ! -d "$USER_HOME" ]; then
    echo "❌ User mark home directory not found - skipping"
    exit 1
fi

# ==================== Global git config (idempotent) ====================
echo "Setting global git config for Mark..."
git config --global --replace-all user.name "Mark"
git config --global --replace-all user.email "markbbbnyc@gmail.com"
git config --global --replace-all init.defaultBranch main
git config --global --replace-all pull.rebase false

echo "✓ Git user.name and user.email configured"

# ==================== Create dedicated SSH key for GitHub (only once) ====================
SSH_KEY="${USER_HOME}/.ssh/id_ed25519_github"

if [ ! -f "$SSH_KEY" ]; then
    echo "Generating a new ed25519 SSH key just for GitHub (no passphrase)..."
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "mark@debian-home (bootstrap stage 07)" -q
    echo "✓ GitHub SSH key generated"
else
    echo "✓ GitHub SSH key already exists"
fi

# Set correct permissions
chmod 600 "$SSH_KEY"
chmod 644 "${SSH_KEY}.pub"
chown -R mark:mark "${USER_HOME}/.ssh"

# ==================== ~/.ssh/config for GitHub (idempotent) ====================
SSH_CONFIG="${USER_HOME}/.ssh/config"

if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
    cat >> "$SSH_CONFIG" << 'EOF'

# GitHub SSH config (added by bootstrap stage 07)
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
EOF
    echo "✓ ~/.ssh/config updated for GitHub"
else
    echo "✓ GitHub already configured in ~/.ssh/config"
fi

chown mark:mark "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"

# ==================== Show the public key they need to add to GitHub ====================
echo ""
echo "=== ACTION REQUIRED: Add this key to your GitHub account ==="
echo "Copy the line below and paste it into:"
echo "   GitHub → Settings → SSH and GPG keys → New SSH key"
echo ""
cat "${SSH_KEY}.pub"
echo ""
echo "After you add it on GitHub, test with:"
echo "   ssh -T git@github.com"
echo "   (It should say 'Hi Mark! You've successfully authenticated...')"

# Marker so we never regenerate the key
touch "${USER_HOME}/.github_configured"
chown mark:mark "${USER_HOME}/.github_configured"

echo "✓ Stage 07 complete!"
echo "   Git is ready with your name/email"
echo "   Dedicated GitHub SSH key is set up"
echo "   Just add the public key shown above to GitHub (one-time)"
