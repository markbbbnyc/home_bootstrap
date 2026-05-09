#!/bin/bash
set -euo pipefail

echo ">>> Stage 02: Base packages + preferred tools"

apt-get update -qq

apt-get install -y -qq \
    zsh git curl wget unzip \
    neovim bat tmux mc glances htop \
    fetchmail alpine btm mariadb mycli \
    lf  # file manager (available on Ubuntu 24.04)

# Make bat usable as "cat" alias later
ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true

# Alpine needs a tiny config stub (we'll override it properly in email stage)
if [ ! -f /home/mark/.alpine.rc ]; then
    touch /home/mark/.alpinerc
    chown mark:mark /home/mark/.alpinerc
fi

echo "✓ Base packages installed (alpine, bat, neovim, fetchmail, glances, mc, lf, tmux, zsh, etc.)"
