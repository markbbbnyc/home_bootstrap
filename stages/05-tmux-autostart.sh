#!/usr/bin/env bash
set -euo pipefail

echo "🌀 Stage 05: Configuring tmux auto-start on SSH login..."

USER_HOME="/home/mark"
BASHRC="${USER_HOME}/.bashrc"

# 1. Safety: ensure user home exists (Stage 01 should have created it)
if [ ! -d "$USER_HOME" ]; then
    echo "⚠️  /home/mark does not exist yet. Skipping tmux autostart."
    exit 0
fi

touch "$BASHRC"

# 2. The tmux launch block (safe for interactive + SSH only)
TMUX_BLOCK='# 🌀 Auto-launch tmux on SSH login
if [[ $- == *i* ]] && [[ -n "${SSH_CONNECTION:-$SSH_CLIENT}" ]] && [ -z "$TMUX" ]; then
    tmux start-server \
        && tmux new-session -d -s "mark-home" \
        && tmux attach-session -t "mark-home" \
        && exit
fi'

# 3. Idempotent: skip if already appended
if grep -qF "# 🌀 Auto-launch tmux on SSH login" "$BASHRC"; then
    echo "🐌 tmux autostart already configured — skipping."
else
    echo "$TMUX_BLOCK" >> "$BASHRC"
    echo "✅ tmux autostart appended to ~/.bashrc"
fi
