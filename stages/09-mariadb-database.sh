#!/usr/bin/env bash
set -euo pipefail

echo "Stage 09: 🗄️ Install MariaDB, create full-privs user 'mark', and load dump — enchanting the data vault..."

# ── Password handling (priority: argument → env var → interactive prompt)
if [ $# -ge 1 ]; then
  DB_PASS="$1"
  echo "🔑 Password received via command-line argument."
elif [ -n "${MARK_DB_PASSWORD:-}" ]; then
  DB_PASS="${MARK_DB_PASSWORD}"
  echo "🔑 Password received via MARK_DB_PASSWORD environment variable."
else
  echo "🔑 Please enter a strong password for the MariaDB user 'mark':"
  read -s -p "Password: " DB_PASS
  echo
  if [ -z "$DB_PASS" ]; then
    echo "❌ Error: Password cannot be empty!"
    exit 1
  fi
  # Optional: Ask for confirmation
  read -s -p "Confirm Password: " DB_PASS_CONFIRM
  echo
  if [ "$DB_PASS" != "$DB_PASS_CONFIRM" ]; then
    echo "❌ Error: Passwords do not match!"
    exit 1
  fi
fi

# ── 1. Install MariaDB (idempotent)
if ! dpkg -l | grep -q "^ii  mariadb-server"; then
  echo "🪄 Summoning MariaDB server + client..."
  apt-get update -qq
  apt-get install -y -qq mariadb-server mariadb-client
else
  echo "✅ MariaDB already installed."
fi

# ── 2. Ensure service is running
systemctl enable --now mariadb >/dev/null 2>&1 || true
sleep 2

# ── 3. Create or update user 'mark' with ALL PRIVILEGES
echo "🔑 Creating/updating DB user 'mark' with full privileges..."

mysql -u root -e "
    CREATE USER IF NOT EXISTS 'mark'@'localhost' IDENTIFIED BY '${DB_PASS}';
    GRANT ALL PRIVILEGES ON *.* TO 'mark'@'localhost' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
" 2>/dev/null || true

echo "✅ MariaDB user 'mark' is ready with full privileges!"

# ── 4. Load database dump if present
DUMP_FILE="${BOOTSTRAP_DIR:-/opt/home_bootstrap}/data/nerdverse-dump.sql"

if [ -f "$DUMP_FILE" ]; then
  echo "📥 Found dump file → loading schema and data..."
  mysql -u root <"$DUMP_FILE"
  echo "✅ Database dump loaded successfully!"
else
  echo "📌 No dump file found at $DUMP_FILE"
  echo "   Tip: Place your schema+data file there and re-run to auto-import."
fi

echo "🎉 Stage 09 complete! The enchanted database vault is now open."
echo "   User: mark"
echo "   Host: localhost"
echo "   Use: mysql -u mark -p"

# -- 5 . Create ~/.my.cnf

cat >/home/mark/.my.cnf <<EOF
[client]
user = mark
password = ${DB_PASS}
host = localhost
port = 3306
EOF

# Secure and own the file
chmod 600 /home/mark/.my.cnf
chown mark:mark /home/mark/.my.cnf

echo "✅ ~/.my.cnf created successfully with your credentials."
echo "File location: /home/mark/.my.cnf"
