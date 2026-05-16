# 🪄 Mark's Enchanted Home VM Bootstrap

Welcome, traveler! This is a modular, idempotent bootstrap suite to transform a fresh Debian/Ubuntu VM into a fully enchanted dev workstation. Each stage is a self-contained spell, safe to rerun, and logged in a treasure chest (`/opt/home_bootstrap/logs/archive/`).

## 🧭 How to Cast the Spell
```bash
# Run as root (required for system-wide enchantments) - but run in folder not pipe to bash
curl -fsSL https://raw.githubusercontent.com/markbbbnyc/home_bootstrap/main/install.sh 

# Or re-run anytime to refresh/update:
bash /opt/home_bootstrap/install.sh
```

## 📖 The Stages (in order)
| Stage | What It Does |
|-------|-------|
| `01`  | 🧙‍♂️ Creates `mark` user, sudo access, & hardens SSH |
| `02`  | 📦 Installs base packages (Bash-centric toolchain) |
| `03`  | 🐚 Personalizes `.bashrc` (aliases, history, editors) |
| `04`  | ⚡ Installs & configures `starship` prompt + terminal fixes |
| `05`  | 🌀 Auto-launches `tmux` on SSH login |
| `06`  | 💬 Sets up `weechat` IRC client (SMTP-free comms) |
| `07`  | 🔑 Configures Git & dedicated GitHub SSH key |
| `08`  | 🛡️ Locks down SSH (root login & passwords disabled) |
| `09`  | 🛡️ Insall Nerdverse Mariadb (mark mycli login ) |

## 🗝️ Notes
- 🪄 All stages are **idempotent** → safe to run multiple times
- 🐚 **Bash-only** by design (Zsh references removed)
- 💬 IRC replaces fetchmail/alpine (DigitalOcean SMTP blocks)
- 📜 Full logs: `/opt/home_bootstrap/logs/stage-install.log`
- 🔄 Updates via `cd /opt/home_bootstrap && git pull && bash install.sh`

Happy crafting! ✨
