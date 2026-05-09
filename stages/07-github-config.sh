#!/usr/bin/env bash
set -euo pipefail

echo "🪄 Stage 07: GitHub access — forging the key to the repository..."

USER_HOME="/home/mark"
[ -d "$USER_HOME" ] || { echo "❌ User home not found — skipping."; exit 1; }

git config --global --replace-all user.name "Mark"
git config --global --replace-all user.email "markbbbnyc@gmail.com"
git config --global --replace-all init.defaultBranch main
git config --global --replace-all pull.rebase false

SSH_KEY="${USER_HOME}/.ssh/id_ed25519_github"
if [ ! -f "$SSH_KEY" ]; then
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "mark@debian-home (bootstrap)" -q
    echo "🔑 New GitHub key generated:"
    cat "${SSH_KEY}.pub"
else
    echo "🐌 GitHub key already exists — skipping."
fi

chmod 600 "$SSH_KEY"; chmod 644 "${SSH_KEY}.pub"
chown -R mark:mark "${USER_HOME}/.ssh"

SSH_CONFIG="${USER_HOME}/.ssh/config"
if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
    cat >> "$SSH_CONFIG" << 'EOF'
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
EOF
    echo "⌨️  Add the key above to GitHub → Settings → SSH keys"
fi
chown mark:mark "$SSH_CONFIG"; chmod 600 "$SSH_CONFIG"
touch "${USER_HOME}/.github_configured"; chown mark:mark "${USER_HOME}/.github_configured"

echo "✨ Stage 07 complete! The repository gates are open."
