#!/usr/bin/env bash
set -euo pipefail

echo "🪄 Stage 04: Starship prompt + terminal compatibility — polishing the glass..."

USER_HOME="/home/mark"
[ -d "$USER_HOME" ] || { echo "❌ User home not found — skipping."; exit 1; }

apt-get update -qq
apt-get install -y -qq ncurses-term

if ! command -v starship >/dev/null 2>&1; then
    echo "⚡ Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

BASHRC="${USER_HOME}/.bashrc"
if ! grep -q "starship init bash" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" << 'EOF'

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
EOF
fi

mkdir -p "${USER_HOME}/.config"
STARSHIP_TOML="${USER_HOME}/.config/starship.toml"
if [ ! -f "$STARSHIP_TOML" ]; then
    cat > "$STARSHIP_TOML" << 'EOF'
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$cmd_duration\
$line_break\
$character"""
[username] style_user = "bold green" style_root = "bold red"
[hostname] style = "bold yellow" ssh_only = false
[directory] truncation_length = 3 style = "bold cyan"
[git_branch] style = "bold purple"
[git_status] style = "bold red"
[cmd_duration] style = "bold yellow" min_time = 500
[character] success_symbol = "[➜](bold green)" error_symbol = "[✗](bold red)"
EOF
fi
chown -R mark:mark "${USER_HOME}/.config"

echo "✨ Stage 04 complete! The prompt shines bright."
