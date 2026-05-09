#!/usr/bin/env bash
set -euo pipefail

echo "🌟✨ Welcome to Mark's Enchanted Home VM Bootstrap! ✨🌟"
echo "   Time to weave some serious workshop magic on this VM! 🪄"

# 1. Must be root (system spells require grand wizard privileges)
if [ "$EUID" -ne 0 ]; then
  echo "🚫 Oopsie! This incantation requires root powers. Run with sudo or as root."
  exit 1
fi

# 2. Minimal prerequisites
echo "📦 Summoning the bare-minimum ingredients (apt + git + curl)..."
apt-get update -qq
apt-get install -y -qq git curl

# 3. Clone or update the enchanted repo
BOOTSTRAP_DIR="/opt/home_bootstrap"
if [ ! -d "$BOOTSTRAP_DIR" ]; then
  echo "🌱 Planting the bootstrap repo in $BOOTSTRAP_DIR..."
  git clone https://github.com/markbbbnyc/home_bootstrap.git "$BOOTSTRAP_DIR"
else
  echo "🔄 Refreshing the existing bootstrap repo..."
  (cd "$BOOTSTRAP_DIR" && git pull --ff-only) || echo "⚠️  Pull skipped (no biggie, maybe no changes or tiny hiccup)"
fi

# 4. Whimsical logging setup
LOG_DIR="${BOOTSTRAP_DIR}/logs"
ARCHIVE_DIR="${LOG_DIR}/archive"
mkdir -p "$LOG_DIR" "$ARCHIVE_DIR"

CURRENT_LOG="${LOG_DIR}/stage-install.log"
export STAGE_INSTALL_LOG="$CURRENT_LOG"

# Rotate old log into the treasure chest
if [ -f "$CURRENT_LOG" ]; then
  echo "📜 Packing the old log into the archive chest..."
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  OLD_LOG="${ARCHIVE_DIR}/stage-install-${TIMESTAMP}.log"
  mv "$CURRENT_LOG" "$OLD_LOG"
  echo "   Archived → $OLD_LOG 🗃️"

  NUM_LOGS=$(find "$ARCHIVE_DIR" -name "stage-install-*.log" -type f 2>/dev/null | wc -l)
  if [ "$NUM_LOGS" -gt 5 ]; then
    echo "🗜️  Chest getting full! Compressing the oldest logs to keep things light..."
    find "$ARCHIVE_DIR" -name "stage-install-*.log" -type f -printf '%T@ %p\n' 2>/dev/null \
      | sort -n | head -n -5 | cut -d' ' -f2- | xargs -r gzip -9 || true
  fi
fi

echo "=== ✨ New Bootstrap Log — $(date) ✨ ===" > "$CURRENT_LOG"

# 5. Run every stage in glorious sorted order
cd "$BOOTSTRAP_DIR"
echo "🎭 Unleashing the stages in perfect order (01- → 08- …)..."

for stage in stages/0*.sh; do
  [ -f "$stage" ] || continue
  STAGE_NAME=$(basename "$stage")
  echo ">>> 🌟 Running $STAGE_NAME" | tee -a "$CURRENT_LOG"
  bash "$stage" 2>&1 | tee -a "$CURRENT_LOG"
done

echo "=== 🎉 Bootstrap complete! The VM is now enchanted! ===" | tee -a "$CURRENT_LOG"
echo ""
echo "🪄 You can now SSH in as:   ssh mark@<your-vm-ip>"
echo "🔄 Want to update later? Just re-run the bootstrap command anytime."
echo "📜 Full adventure log:   $CURRENT_LOG"
echo "🗃️  Old logs live in:     $ARCHIVE_DIR (auto-compressed when full)"
