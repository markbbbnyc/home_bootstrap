#!/usr/bin/env bash
set -euo pipefail

echo "🪄 Stage 06: IRC communication setup — opening a new channel..."

USER_HOME="/home/mark"
[ -d "$USER_HOME" ] || { echo "❌ User home not found — skipping."; exit 1; }

apt-get update -qq
apt-get install -y -qq irssi

CONFIG_DIR="${USER_HOME}/.irssi"
mkdir -p "$CONFIG_DIR"

# Create minimal auto-connect config
if [ ! -f "$CONFIG_DIR/config" ]; then
    cat > "$CONFIG_DIR/config" << 'EOF'
servers = (
  {
    address = "irc.libera.chat";
    chatnet = "libera";
    port = "6697";
    use_ssl = "yes";
    ssl_verify = "yes";
  }
);
chans = (
  {
    name = "#debian";
    chatnet = "libera";
    auto = "yes";
  }
);
settings = {
  core = { realname = "Mark"; nick = "mark"; };
};
EOF
fi

# Create auto-connect wrapper script
#cat > "${USER_HOME}/.irc_autostart.sh" << 'EOF'
#!/usr/bin/env bash
#[ -n "$SSH_CLIENT" ] && [ -z "$TMUX" ] && exec irssi
#EOF
#chmod +x "${USER_HOME}/.irc_autostart.sh"
#chown mark:mark "${USER_HOME}/.irc_autostart.sh" "${USER_HOME}/.irssi" -R

# Add to bashrc if not present
BASHRC="${USER_HOME}/.bashrc"
if ! grep -q "irc_autostart" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" << 'EOF'

[ -f ~/.irc_autostart.sh ] && . ~/.irc_autostart.sh
EOF
fi

echo "✨ Stage 06 complete! IRC is tuned and ready for conversation."
