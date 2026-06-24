#!/bin/bash
# ╔═════════════════════════════════════════════════════════╗
# ║ NERDVERSE DASHBOARD v2.3 — Glitch Grid + Movement      ║
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

# 🗄️ Database
DB_USER="mark"
DB_NAME="nerdverse"

run_query() {
    mysql -D "$DB_NAME" -u "$DB_USER" -e "$1" 2>/dev/null
}

run_query_raw() {
    mysql -D "$DB_NAME" -u "$DB_USER" -N -e "$1" 2>/dev/null
}

pause() {
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

clear_screen() {
    clear
}

# ==================== MAP FUNCTIONS ====================

show_glitch_grid() {
    echo -e "${PURPLE}=== 🌿 5×5 GLITCH-GRID : NEON CODE GROVE 🌿 ===${NC}"
    
    local player_pos=$(run_query_raw "SELECT position FROM heroes WHERE username='PixelSlayer42';")
    [ -z "$player_pos" ] && player_pos="B3"

    echo -e "${CYAN}You are here → ${YELLOW}★★ ${player_pos} ★★${NC}\n"

    # Nice bordered grid
    echo -e "${WHITE}────────────────────────────────────────────────────────────${NC}"
    echo -e " ${YELLOW}A1:Root${NC} (2)  ${YELLOW}A2:Moss${NC} (1)  ${YELLOW}A3:Code${NC} (3)  ${YELLOW}A4:Meme${NC} (2)  ${YELLOW}A5:Glitch${NC} (4)"
    echo -e " ${YELLOW}B1:Spore${NC} (1)  ${YELLOW}B2:Clear${NC} (0)  ${YELLOW}B3:Wire${NC} (2)  ${YELLOW}B4:Pepe${NC} (1)  ${YELLOW}B5:Void${NC} (5)"
    
    # Highlight current row
    local row=$(echo "$player_pos" | cut -c2)
    case $row in
        1) echo -e " ${YELLOW}C1:Thorn${NC} (3)  ${YELLOW}C2:Path${NC} (0)  ${YELLOW}C3:Node${NC} (1)  ${RED}**${player_pos}:Rift**${NC} (2)  ${YELLOW}C5:Null${NC} (6)" ;;
        2) echo -e " ${YELLOW}C1:Thorn${NC} (3)  ${YELLOW}C2:Path${NC} (0)  ${YELLOW}C3:Node${NC} (1)  ${RED}**${player_pos}:Rift**${NC} (2)  ${YELLOW}C5:Null${NC} (6)" ;;
        *) echo -e " C1:Thorn (3)  C2:Path (0)  C3:Node (1)  C4:Rift (2)  C5:Null (6)" ;;
    esac
    
    echo -e " ${YELLOW}D1:Canopy${NC} (2)  ${YELLOW}D2:Bush${NC} (1)  ${YELLOW}D3:Log${NC} (1)  ${YELLOW}D4:Shard${NC} (3)  ${YELLOW}D5:Fog${NC} (4)"
    echo -e " ${YELLOW}E1:Edge${NC} (1)  ${YELLOW}E2:Clear${NC} (0)  ${YELLOW}E3:Code${NC} (2)  ${YELLOW}E4:Bridge${NC} (1)  ${YELLOW}E5:End${NC} (0)"
    echo -e "${WHITE}────────────────────────────────────────────────────────────${NC}"

    echo -e "\n${YELLOW}Terrain Legend:${NC}"
    echo -e "   ${GREEN}Clear/Path (0) = Safe${NC}"
    echo -e "   ${CYAN}Meme/Pepe = +DEX bonus${NC}"
    echo -e "   ${RED}Void/Null/Rift = High Risk${NC}"
}

# ==================== OTHER FUNCTIONS ====================

show_heroes() {
    echo -e "${BLUE}=== HEROES ===${NC}"
    run_query "SELECT username, class, level, reputation, hp, mana, position FROM heroes ORDER BY reputation DESC;"
}

show_battles() {
    echo -e "${RED}=== ACTIVE BATTLES ===${NC}"
    run_query "
        SELECT b.battle_id, h.username, q.title as quest_title, 
               b.enemy_name, b.battle_status 
        FROM battles b 
        JOIN heroes h ON b.hero_id = h.hero_id
        JOIN quests q ON b.quest_id = q.quest_id 
        WHERE b.battle_status = 'in_progress' 
        ORDER BY b.started_at DESC;"
}

show_recent_battles() {
    echo -e "${GREEN}=== RECENT BATTLE RESULTS ===${NC}"
    run_query "
        SELECT b.battle_id, h.username, b.enemy_name, b.battle_result, b.xp_gained 
        FROM battles b 
        JOIN heroes h ON b.hero_id = h.hero_id
        WHERE b.battle_status != 'in_progress' 
        ORDER BY b.ended_at DESC LIMIT 5;"
}

show_quests() {
    echo -e "${YELLOW}=== CURRENT QUESTS ===${NC}"
    run_query "
        SELECT q.quest_id, q.title, q.difficulty, q.status 
        FROM quests q 
        WHERE q.status != 'Completed' 
        ORDER BY q.reputation_required;"
}

show_quest_requirements() {
    echo -e "${PURPLE}=== QUEST REQUIREMENTS ===${NC}"
    run_query "SELECT quest_id, title, difficulty, requires_battle, battle_enemy FROM quests WHERE requires_battle = TRUE;"
}

show_game_stats() {
    echo -e "${CYAN}=== GAME STATISTICS ===${NC}"
    local heroes=$(run_query_raw "SELECT COUNT(*) FROM heroes;")
    local quests=$(run_query_raw "SELECT COUNT(*) FROM quests;")
    local completed=$(run_query_raw "SELECT COUNT(*) FROM quests WHERE status = 'Completed';")
    echo -e "Total Heroes: ${GREEN}${heroes:-0}${NC}"
    echo -e "Total Quests: ${GREEN}${quests:-0}${NC}"
    echo -e "Completed:    ${GREEN}${completed:-0}${NC}"
}

show_reputation_ranking() {
    echo -e "${BLUE}=== REPUTATION RANKING ===${NC}"
    run_query "SELECT username, class, reputation, level FROM heroes ORDER BY reputation DESC LIMIT 10;"
}

show_ranger_status() {
    echo -e "${PURPLE}=== PIXEL RANGER: ELOWEN THORNWHISPER ===${NC}"
    run_query "SELECT username, class, level, hp, mana, reputation, ac, position FROM heroes WHERE username='PixelSlayer42';"
}

enter_ranger_encounter() {
    echo -e "${RED}=== INITIATING ENCOUNTER ===${NC}"
    run_query "CALL start_adventure((SELECT hero_id FROM heroes WHERE username='PixelSlayer42'));"
    echo -e "${GREEN}Encounter started. Check tavern_log.${NC}"
}

roll_ranger_check() {
    echo -e "${CYAN}=== 🎲 ROLL SKILL/ATTACK CHECK ===${NC}"
    read -p "Skill: " skill
    read -p "DC: " dc
    read -p "Modifier: " mod

    local hero_id=$(run_query_raw "SELECT hero_id FROM heroes WHERE username='PixelSlayer42';")
    local result=$(run_query_raw "CALL do_d20_check($hero_id, '${skill:-perception}', ${dc:-12}, ${mod:-0});")
    echo -e "${GREEN}${result:-Check completed}${NC}"
}

ranger_rest() {
    echo -e "${YELLOW}=== RANGER REST ===${NC}"
    read -p "Rest type (1=Short, 2=Long): " rest_type
    local hero_id=$(run_query_raw "SELECT hero_id FROM heroes WHERE username='PixelSlayer42';")

    if [ "$rest_type" = "1" ]; then
        run_query "UPDATE heroes SET hp = LEAST(hp + 20, 420) WHERE hero_id = $hero_id;"
        echo -e "${GREEN}Short rest complete.${NC}"
    elif [ "$rest_type" = "2" ]; then
        run_query "UPDATE heroes SET hp = 420, mana = 420 WHERE hero_id = $hero_id;"
        echo -e "${GREEN}Long rest complete — fully restored!${NC}"
    else
        echo -e "${RED}Invalid choice.${NC}"
    fi
}

admin_tools() {
    echo -e "${YELLOW}=== ADMIN / TOOLS ===${NC}"
    read -p "How many random quests? " count
    run_query "CALL generate_random_quest(${count:-3});"
    echo -e "${GREEN}Quests generated.${NC}"
}


move_player() {
    echo -e "${CYAN}=== 🗺️ MOVE ON THE GLITCH GRID ===${NC}"
    read -p "Target coordinate (e.g. C4): " new_pos

    if [[ $new_pos =~ ^[A-E][1-5]$ ]]; then
        run_query "UPDATE heroes SET position = '$new_pos' WHERE username='PixelSlayer42';"
        echo -e "${GREEN}✓ Moved to ${YELLOW}$new_pos${GREEN}. The glitch-weave ripples...${NC}"
        
        if [[ $new_pos =~ (B5|C4|C5|D5|E5) ]]; then
            echo -e "${RED}⚠️  Rift energy is strong here...${NC}"
        fi
    else
        echo -e "${RED}Invalid coordinate! Format: A1 to E5${NC}"
    fi
}


# ==================== MENUS ====================

show_menu() {
    clear_screen
    echo -e "${CYAN}╔═════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}          ${YELLOW}NERDVERSE DASHBOARD v2.3${NC}                ${CYAN}║${NC}"
    echo -e "${CYAN}╠═════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1. Heroes          2. Active Battles               ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} 3. Recent Battles  4. Quests                      ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} 5. Quest Req.      6. Game Stats                   ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} 7. Reputation      8. 🏹 PIXEL RANGER MODE        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} 9. 🗺️ Glitch Grid   0. Exit                        ${CYAN}║${NC}"
    echo -e "${CYAN}╚═════════════════════════════════════════════════════╝${NC}"
    echo -n "Enter choice: "
}

ranger_menu() {
    clear_screen
    echo -e "${PURPLE}╔══ PIXEL RANGER MODE ═══════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} 1. Status          2. Start Encounter            ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC} 3. Roll Check      4. Rest                       ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC} 5. Move on Grid    6. Back to Main               ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC} 0. Logout                                         ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚═════════════════════════════════════════════════════╝${NC}"
    echo -n "Ranger command: "
}

# ==================== MAIN LOOP ====================

main() {
    while true; do
        show_menu
        read -r choice

        case $choice in
            1) show_heroes; pause ;;
            2) show_battles; pause ;;
            3) show_recent_battles; pause ;;
            4) show_quests; pause ;;
            5) show_quest_requirements; pause ;;
            6) show_game_stats; pause ;;
            7) show_reputation_ranking; pause ;;
            8)
                while true; do
                    ranger_menu
                    read -r rchoice
                    case $rchoice in
                        1) show_ranger_status; pause ;;
                        2) enter_ranger_encounter; pause ;;
                        3) roll_ranger_check; pause ;;
                        4) ranger_rest; pause ;;
                        5) move_player; pause ;;
                        6) break ;;
                        0) echo -e "${GREEN}Farewell, Glitch-Weaver!${NC}"; exit 0 ;;
                        *) echo -e "${RED}Invalid.${NC}"; pause ;;
                    esac
                done ;;
            9) show_glitch_grid; pause ;;
            0) echo -e "${GREEN}May your Pepe shards multiply.${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid choice.${NC}"; pause ;;
        esac
    done
}

main
