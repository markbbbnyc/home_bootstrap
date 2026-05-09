#!/bin/bash
set -euo pipefail
echo "=== Mark's Home VM Bootstrap ==="

# Update once at start
apt-get update && apt-get upgrade -y

# Run stages in order
for stage in stages/*.sh; do
  echo "Running $stage..."
  bash "$stage"
done

echo "=== Bootstrap complete! ==="
echo "Now: ssh mark@your-droplet-ip"
