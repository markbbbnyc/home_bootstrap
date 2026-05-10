#!/usr/bin/env bash
set -euo pipefail

echo "🪄 Stage 02: Base packages + preferred tools — gathering the workshop materials..."

apt-get update -qq
apt-get install -y -qq \
    bash git curl wget unzip duf \
    neovim bat tmux mc glances htop weechat\
    lf irssi # Removed zsh/fetchmail/alpine; added irssi for IRC

# Alias bat as cat for consistent tooling
ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true

echo "✨ Stage 02 complete! The toolkit is forged and ready."
