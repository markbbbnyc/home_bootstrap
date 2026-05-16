#!/bin/bash

# Nerdverse Dashboard - Battle Monitor
# Save as: nerdverse_dashboard.sh

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Database configuration
DB_USER="root"
DB_PASS="magara68"
DB_NAME="nerdverse"

# Function to run MySQL queries
run_query() {
    local query="$1"
    mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e "$query" 2>/dev/null
}

# Function to display hero information
show_heroes() {
    echo -e "${BLUE}=== HEROES ===${NC}"
    run_query "SELECT username, class, level, reputation, hp, mana FROM heroes ORDER BY reputation DESC;"
}

# Function to display active battles
show_battles() {
    echo -e "${RED}=== ACTIVE BATTLES ===${NC}"
    run_query "SELECT b.battle_id, h.username, q.title as quest_title, b.enemy_name, b.battle_status, b.battle_difficulty FROM battles b JOIN
heroes h ON b.hero_id = h.hero_id JOIN quests q ON b.quest_id = q.quest_id WHERE b.battle_status = 'in_progress' ORDER BY b.started_at DESC;"
}

# Function to display recent battle results
show_recent_battles() {
    echo -e "${GREEN}=== RECENT BATTLE RESULTS ===${NC}"
    run_query "SELECT b.battle_id, h.username, q.title as quest_title, b.enemy_name, b.battle_result, b.xp_gained, b.combat_time FROM battles b
JOIN heroes h ON b.hero_id = h.hero_id JOIN quests q ON b.quest_id = q.quest_id WHERE b.battle_status != 'in_progress' ORDER BY b.ended_at DESC
LIMIT 5;"
}

# Function to display quest information
show_quests() {
    echo -e "${YELLOW}=== CURRENT QUESTS ===${NC}"
    run_query "SELECT q.quest_id, q.title, q.difficulty, q.reputation_required, h.username, q.status FROM quests q LEFT JOIN heroes h ON
q.assigned_to = h.hero_id WHERE q.status != 'Completed' ORDER BY q.reputation_required;"
}

# Function to display quest requirements
show_quest_requirements() {
    echo -e "${PURPLE}=== QUEST REQUIREMENTS ===${NC}"
    run_query "SELECT q.quest_id, q.title, q.difficulty, q.reputation_required, q.requires_battle, q.battle_enemy, q.battle_difficulty FROM quests
q WHERE q.requires_battle = TRUE ORDER BY q.reputation_required;"
}

# Function to show overall game stats
show_game_stats() {
    echo -e "${CYAN}=== GAME STATISTICS ===${NC}"
    local total_heroes=$(run_query "SELECT COUNT(*) FROM heroes;" | tail -n 1)
    local total_quests=$(run_query "SELECT COUNT(*) FROM quests;" | tail -n 1)
    local completed_quests=$(run_query "SELECT COUNT(*) FROM quests WHERE status = 'Completed';" | tail -n 1)
    local active_battles=$(run_query "SELECT COUNT(*) FROM battles WHERE battle_status = 'in_progress';" | tail -n 1)

    echo -e "Total Heroes: ${GREEN}$total_heroes${NC}"
    echo -e "Total Quests: ${GREEN}$total_quests${NC}"
    echo -e "Completed Quests: ${GREEN}$completed_quests${NC}"
    echo -e "Active Battles: ${RED}$active_battles${NC}"
}

# Function to show hero reputation ranking
show_reputation_ranking() {
    echo -e "${BLUE}=== REPUTATION RANKING ===${NC}"
    run_query "SELECT username, class, reputation, level FROM heroes ORDER BY reputation DESC LIMIT 10;"
}

# Main menu function
show_menu() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                ${YELLOW}NERDVERSE DASHBOARD${NC}                        ${CYAN} ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1. ${GREEN}Show Heroes${NC}                   2. ${RED}Show Active Battles${NC}    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} 3. ${GREEN}Show Recent Battles${NC}           4. ${YELLOW}Show Quests${NC}            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} 5. ${PURPLE}Show Quest Requirements${NC}       6. ${CYAN}Show Game Stats${NC}        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} 7. ${BLUE}Show Reputation Ranking${NC}       8. ${RED}Exit${NC}                   ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -n "Enter your choice (1-8): "
}

# Main execution loop
main() {
    while true; do
        show_menu
        read -r choice

        case $choice in
            1)
                show_heroes
                echo
                ;;
            2)
                show_battles
                echo
                ;;
            3)
                show_recent_battles
                echo
                ;;
            4)
                show_quests
                echo
                ;;
            5)
                show_quest_requirements
                echo
                ;;
            6)
                show_game_stats
                echo
                ;;
            7)
                show_reputation_ranking
                echo
                ;;
            8)
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please try again.${NC}"
                echo
                ;;
        esac

        read -p "Press Enter to continue..."
        clear
    done
}

# Run the main function
main
