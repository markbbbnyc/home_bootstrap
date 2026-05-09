#!/bin/bash
set -euo pipefail

echo "=== Mark's Home VM Bootstrap ==="

# 1. Minimal prerequisites
apt-get update -qq
apt-get install -y -qq git

# 2. Clone / update the repo once (this is what makes curl | sh work)
BOOTSTRAP_DIR="/opt/home_bootstrap"
if [ ! -d "$BOOTSTRAP_DIR" ]; then
  echo "Cloning bootstrap repo..."
  git clone https://github.com/markbbbnyc/home_bootstrap.git "$BOOTSTRAP_DIR"
else
  echo "Updating bootstrap repo..."
  cd "$BOOTSTRAP_DIR" && git pull --ff-only || true
fi

# 3. Run every stage in sorted order (01-, 02-, …)
cd "$BOOTSTRAP_DIR"
echo "Running stages/*.sh..."
for stage in stages/*.sh; do
  if [ -f "$stage" ]; then
    echo ">>> Running $(basename "$stage")"
    bash "$stage"
  fi
done

echo "=== Bootstrap complete! ==="
echo "You can now SSH as: ssh mark@<droplet-ip>"
echo "Re-run the curl command anytime for updates."
