#!/usr/bin/env bash
set -euo pipefail

echo "🪄 Stage 05: tmux auto-start on SSH login — weaving the time portal..."

USER_HOME="/home/mark"
[ -d "$USER_HOME" ] || { echo "❌ User home not found — skipping."; exit 1; }

tmux -V >/dev/null 2>&1 || { apt-get update -qq && apt-get install -y -qq tmux; }

TMUX_CONF="${USER_HOME}/.tmux.conf"
if [ ! -f "$TMUX_CONF" ]; then
    cat > "$TMUX_CONF" << 'EOF'
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"
set -g mouse on
set -g base-index 1; setw -g pane-base-index 1
set -g renumber-windows on
set -s escape-time 0
set -g status-style "bg=#282c34,fg=#abb2bf"
set -g status-right "#[fg=#61afef]%H:%M #[fg=#98c379]%d-%b-%y"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind h select-pane -L; bind j select-pane -D; bind k select-pane -U; bind l select-pane -R
bind a attach-session -t main
bind r source-file ~/.tmux.conf \; display "tmux reloaded!"
EOF
fi

BASHRC="${USER_HOME}/.bashrc"
if ! grep -q "tmux auto-start" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" << 'EOF'

if [ -n "$SSH_CLIENT" ] && [ -z "$TMUX" ]; then
    exec tmux new-session -A -s main
fi
EOF
fi
chown mark:mark "$TMUX_CONF" "$BASHRC"
chmod 644 "$TMUX_CONF" "$BASHRC"

echo "✨ Stage 05 complete! The time portal is active."
