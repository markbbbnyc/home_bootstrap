#!/bin/bash

# ╔═════════════════════════════════════════════════════════╗
# ║           NERDVERSE DASHBOARD v2.1 (Dual Campaign)       ║
# ╚════════════════════════════════════════════════════════╝

# 🎨 Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# 🗄️ Database Configuration
DB_USER="mark"
DB_PASS=""
DB_NAME="nerdverse"

# 🛠️ Safe MySQL wrapper (matches your original working version)
run_query() {
  mysql -D"$DB_NAME" -e "$1" 2>/dev/null
}

# 📊 Core NerdVerse Functions
show_heroes() {
  echo -e "${BLUE}=== HEROES ===${NC}"
  run_query "SELECT username, class, level, reputation, hp, mana FROM heroes ORDER BY reputation DESC;"
}

show_battles() {
  echo -e "${RED}=== ACTIVE BATTLES ===${NC}"
  run_query "SELECT b.battle_id, h.username, q.title as quest_title, b.enemy_name, b.battle_status, b.battle_difficulty FROM battles b JOIN heroes h ON b.hero_id = h.hero_id
JOIN quests q ON b.quest_id = q.quest_id WHERE b.battle_status = 'in_progress' ORDER BY b.started_at DESC;"
}

show_recent_battles() {
  echo -e "${GREEN}=== RECENT BATTLE RESULTS ===${NC}"
  run_query "SELECT b.battle_id, h.username, q.title as quest_title, b.enemy_name, b.battle_result, b.xp_gained, b.combat_time FROM battles b JOIN heroes h ON b.hero_id =
h.hero_id JOIN quests q ON b.quest_id = q.quest_id WHERE b.battle_status != 'in_progress' ORDER BY b.ended_at DESC LIMIT 5;"
}

show_quests() {
  echo -e "${YELLOW}=== CURRENT QUESTS ===${NC}"
  run_query "SELECT q.quest_id, q.title, q.difficulty, q.reputation_required, h.username, q.status FROM quests q LEFT JOIN heroes h ON q.assigned_to = h.hero_id WHERE
q.status != 'Completed' ORDER BY q.reputation_required;"
}

show_quest_requirements() {
  echo -e "${PURPLE}=== QUEST REQUIREMENTS ===${NC}"
  run_query "SELECT q.quest_id, q.title, q.difficulty, q.reputation_required, q.requires_battle, q.battle_enemy, q.battle_difficulty FROM quests q WHERE q.requires_battle =
TRUE ORDER BY q.reputation_required;"
}

show_game_stats() {
  echo -e "${CYAN}=== GAME STATISTICS ===${NC}"
  local heroes=$(run_query "SELECT COUNT(*) FROM heroes;" | tail -n 1)
  local quests=$(run_query "SELECT COUNT(*) FROM quests;" | tail -n 1)
  local completed=$(run_query "SELECT COUNT(*) FROM quests WHERE status = 'Completed';" | tail -n 1)
  local active=$(run_query "SELECT COUNT(*) FROM battles WHERE battle_status = 'in_progress';" | tail -n 1)
  echo -e "Total Heroes:    ${GREEN}${heroes:-0}${NC}"
  echo -e "Total Quests:    ${GREEN}${quests:-0}${NC}"
  echo -e "Completed:       ${GREEN}${completed:-0}${NC}"
  echo -e "Active Battles:  ${RED}${active:-0}${NC}"
}

show_reputation_ranking() {
  echo -e "${BLUE}=== REPUTATION RANKING ===${NC}"
  run_query "SELECT username, class, reputation, level FROM heroes ORDER BY reputation DESC LIMIT 10;"
}

# 🏹 Pixel Ranger (Elowen Merge) Functions
show_ranger_status() {
  echo -e "${PURPLE}=== PIXEL RANGER: ELOWEN THORNWHISPER ===${NC}"
  run_query "SELECT username, class, level, hp, mana, reputation FROM heroes WHERE username='PixelSlayer42';"
  echo -e "${YELLOW}(JSON ability/spell columns will populate after Phase 1 schema extension)${NC}"
}

enter_ranger_encounter() {
  echo -e "${RED}=== INITIATING ENCOUNTER ===${NC}"
  echo -e "${YELLOW}DM generating terrain, initiative, and narrative hooks...${NC}"
  run_query "CALL start_adventure((SELECT hero_id FROM heroes WHERE username='PixelSlayer42'));" 2>/dev/null
  echo -e "${GREEN}Encounter seeded. Check tavern_log for narrative output.${NC}"
}

roll_ranger_check() {
  echo -e "${CYAN}=== 🎲 ROLL SKILL/ATTACK CHECK ===${NC}"
  read -p "Skill (athletics/acrobatics/perception/etc.): " skill
  read -p "DC: " dc
  read -p "Modifier (e.g., 5): " mod
  mod=${mod#+}
  [[ ! "$mod" =~ ^-?[0-9]+$ ]] && mod=0
  [[ ! "$dc" =~ ^[0-9]+$ ]]    && dc=10

  # 1️⃣ Extract hero_id first (avoids nested SELECT parsing issues)
  local hero_id=$(mysql -D nerdverse -N -e "SELECT hero_id FROM heroes WHERE username='PixelSlayer42';" 2>/dev/null)
  if [ -z "$hero_id" ]; then
    echo -e "${RED}[ERROR] Could not find PixelSlayer42.${NC}"
    return 1
  fi

  # 2️⃣ Build clean call string
  local q="CALL do_d20_check($hero_id, '$skill', $dc, $mod);"

  # 3️⃣ Execute & capture
  local result=$(mysql -D nerdverse -N -e "$q" 2>/dev/null)

  if [ -z "$result" ]; then
    echo -e "${RED}[DB ERROR] Procedure returned nothing. Verify 'do_d20_check' exists in MariaDB.${NC}"
  else
    echo -e "${GREEN}$result${NC}"
  fi
}


ranger_rest() {
  echo -e "${YELLOW}=== RANGER REST ===${NC}"
  read -p "Rest type (1=Short, 2=Long): " rest_type
  if [ "$rest_type" == "1" ]; then
    echo -e "${GREEN}Short rest: HP recovered. Conditions cleared. DM updates world state.${NC}"
  elif [ "$rest_type" == "2" ]; then
    echo -e "${GREEN}Long rest: Full HP/Mana restore. Spell slots reset. DM advances timeline.${NC}"
  else
    echo -e "${RED}Invalid rest type.${NC}"
  fi
}

# 📜 Main Menu
show_menu() {
  echo -e "${CYAN}╔═════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}              ${YELLOW}NERDVERSE DASHBOARD v2.1${NC}               ${CYAN} ║${NC}"
  echo -e "${CYAN}╠═════════════════════════════════════════════════════╣${NC}"
  echo -e "${CYAN}║${NC} 1. ${GREEN}Heroes              2. ${RED}Active Battles${NC}           ${CYAN} ║${NC}"
  echo -e "${CYAN}║${NC} 3. ${GREEN}Recent Battles       4. ${YELLOW}Quests${NC}                   ${CYAN} ║${NC}"
  echo -e "${CYAN}║${NC} 5. ${PURPLE}Quest Requirements  6. ${CYAN}Game Stats${NC}                ${CYAN} ║${NC}"
  echo -e "${CYAN}║${NC} 7. ${BLUE}Reputation Ranking  8. 🏹 ${PURPLE}PIXEL RANGER MODE${NC}      ${CYAN} ║${NC}"
  echo -e "${CYAN}║${NC} 9. 🛠️ ${YELLOW}Admin/Tools${NC}       0. ${RED}Exit${NC}                     ${CYAN} ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
  echo -n "Enter choice: "
}

ranger_menu() {
  echo -e "${PURPLE}╔══ PIXEL RANGER MODE ═════════════════════════════════╗${NC}"
  echo -e "${PURPLE}║${NC} 1. Check Status/Abilities   2. Start Encounter      ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${NC} 3. Roll Check               4. Rest (Short/Long)    ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${NC} 5. Back to Main Menu      0. Logout                 ${PURPLE}║${NC}"
  echo -e "${PURPLE}╚══════════════════════════════════════════════════════╝${NC}"
  echo -n "Ranger command: "
}

admin_tools() {
  echo -e "${YELLOW}=== ADMIN/TOOLS ===${NC}"
  read -p "Generate N random quests: " count
  run_query "CALL generate_random_quest(${count:-3});" 2>/dev/null
  echo -e "${GREEN}Quest generation triggered. Check quests table.${NC}"
}

# 🔄 Main Execution
main() {
  while true; do
    show_menu
    read -r choice
    case $choice in
      1) show_heroes; echo; read -p "Press Enter..."; clear ;;
      2) show_battles; echo; read -p "Press Enter..."; clear ;;
      3) show_recent_battles; echo; read -p "Press Enter..."; clear ;;
      4) show_quests; echo; read -p "Press Enter..."; clear ;;
      5) show_quest_requirements; echo; read -p "Press Enter..."; clear ;;
      6) show_game_stats; echo; read -p "Press Enter..."; clear ;;
      7) show_reputation_ranking; echo; read -p "Press Enter..."; clear ;;
      8)
        while true; do
          ranger_menu
          read -r rchoice
          case $rchoice in
            1) show_ranger_status; echo; read -p "Press Enter..."; clear ;;
            2) enter_ranger_encounter; echo; read -p "Press Enter..."; clear ;;
            3) roll_ranger_check; echo; read -p "Press Enter..."; clear ;;
            4) ranger_rest; echo; read -p "Press Enter..."; clear ;;
            5) clear; break ;;
            0) clear; exit 0 ;;
            *) echo -e "${RED}Invalid ranger command.${NC}"; read -p "Press Enter..."; clear ;;
          esac
        done
        ;;
      9) admin_tools; echo; read -p "Press Enter..."; clear ;;
      0) echo -e "${GREEN}Goodbye! May your RNG stay legendary.${NC}"; exit 0 ;;
      *) echo -e "${RED}Invalid choice. Try again.${NC}"; read -p "Press Enter..."; clear ;;
    esac
  done
}

main
