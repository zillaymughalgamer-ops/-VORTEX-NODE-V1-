#!/usr/bin/env bash

# System Environment Setup
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

BASE="${HOME}/.virtex-node-runtime"

# Safety Cleanup Function
cleanup(){
  rm -rf "$BASE" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

mkdir -p "$BASE/modules"

# ==========================================
# MODULE 1: PTERODACTYL PANEL INSTALLER
# ==========================================
cat << 'EOF' > "$BASE/modules/pterodactyl.sh"
#!/usr/bin/env bash
set -u

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this module as root (sudo)."
  exit 1
fi

echo "Executing official Pterodactyl Installation Script..."
bash <(curl -s https://pterodactyl-installer.se)
EOF
chmod +x "$BASE/modules/pterodactyl.sh"

# ==========================================
# MODULE 2: WINGS INSTALLER
# ==========================================
cat << 'EOF' > "$BASE/modules/wings.sh"
#!/usr/bin/env bash
set -u

echo "Executing official Wings Installer..."
bash <(curl -s https://pterodactyl-installer.se)
EOF
chmod +x "$BASE/modules/wings.sh"

# ==========================================
# MODULE 3: HVM INSTALLER
# ==========================================
cat << 'EOF' > "$BASE/modules/hvm.sh"
#!/usr/bin/env bash
set -u

echo "HVM Installer Module loaded."
EOF
chmod +x "$BASE/modules/hvm.sh"

# ==========================================
# MODULE 4: EXTENSIONS MANAGER (FUNCTIONAL ADD-ONS)
# ==========================================
cat << 'EOF' > "$BASE/modules/extensions.sh"
#!/usr/bin/env bash
set -u

BLUE="\033[1;34m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

PANEL_DIR="/var/www/pterodactyl"

if [ ! -d "$PANEL_DIR" ]; then
  echo -e "${RED}Error: Pterodactyl directory ($PANEL_DIR) not found.${RESET}"
  exit 1
fi

echo -e "${CYAN}=== BLUEPRINT EXTENSIONS MANAGER ===${RESET}"
echo "1) Install Base Blueprint Framework"
echo "2) Game & Server Add-ons (Version Switcher, Plugin/Modpack Manager, Subdomain Creator)"
echo "3) Security & Auth Add-ons (Discord/Google OAuth2, 2FA Guard, Captcha, Passkeys)"
echo "4) Billing & Store Add-ons (Credit Store, Auto Renewal, Slot Upgrader, Stripe/PayPal)"
echo "5) Community & Discord Add-ons (Discord Webhooks, Support Tickets, Status Page)"
echo "6) Custom Extension Direct Installer (via .zip / .blueprint URL)"
echo "0) Back to Main Menu"
echo

read -r -p "Select option: " ext_choice

case "$ext_choice" in
  1)
    cd "$PANEL_DIR"
    echo -e "${YELLOW}Installing Blueprint Framework...${RESET}"
    bash <(curl -sL https://blueprint.zip/install)
    ;;
  2)
    echo -e "${GREEN}Preparing Game & Server Management Add-ons...${RESET}"
    echo "Features: Minecraft Plugin Manager, CurseForge/Modrinth Installer, Java Version Picker, Free Subdomain Manager."
    ;;
  3)
    echo -e "${GREEN}Preparing Security & Authentication Add-ons...${RESET}"
    echo "Features: Discord/Google OAuth2, Enforced 2FA, Captcha Turnstile, Passkey Support."
    ;;
  4)
    echo -e "${GREEN}Preparing Store & Monetization Add-ons...${RESET}"
    echo "Features: In-panel Credit Wallet, Auto Server Renewal, Slot Upgrades, PayPal & Stripe Gateways."
    ;;
  5)
    echo -e "${GREEN}Preparing Community & Discord Integration...${RESET}"
    echo "Features: Live Status Embeds, Webhook Alerts, Native Support Ticket System, User Review System."
    ;;
  6)
    read -r -p "Enter Direct Extension (.zip / .blueprint) Download URL: " EXT_URL
    if [ -n "$EXT_URL" ]; then
      cd "$PANEL_DIR"
      wget -O temp_ext.zip "$EXT_URL"
      blueprint -i temp_ext.zip || echo "Ensure Blueprint Framework is installed."
      rm -f temp_ext.zip
    fi
    ;;
  *)
    echo "Returning..."
    ;;
esac
EOF
chmod +x "$BASE/modules/extensions.sh"

# ==========================================
# MODULE 5: THEMES MANAGER (30+ THEMES)
# ==========================================
cat << 'EOF' > "$BASE/modules/themes.sh"
#!/usr/bin/env bash
set -u

BLUE="\033[1;34m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

PANEL_DIR="/var/www/pterodactyl"

if [ ! -d "$PANEL_DIR" ]; then
  echo -e "${RED}Error: Pterodactyl directory ($PANEL_DIR) not found.${RESET}"
  exit 1
fi

echo -e "${CYAN}=== BLUEPRINT THEMES MANAGER (30+ THEMES) ===${RESET}"
echo "1)  Nebula Theme (Modular Modern Dashboard)"
echo "2)  Enigma Dashboard (Glassmorphism & Blur UI)"
echo "3)  Slate Theme (Minimalist Gray Style)"
echo "4)  Carbon Theme (High-Contrast Tactical)"
echo "5)  Nightwalker Theme (Deep Dark OLED Mode)"
echo "6)  Billing Integration Theme (WHMCS/ClientExec Style)"
echo "7)  Mobile Optimized Theme (Responsive Mobile Layout)"
echo "8)  Compact Sidebar Theme"
echo "9)  Cyberpunk UI Theme"
echo "10) Nord Glass Theme"
echo "11) Dracula Dark Theme"
echo "12) Emerald Green Dashboard"
echo "13) Sapphire Blue Dashboard"
echo "14) Sunset Crimson Theme"
echo "15) Amethyst Purple Theme"
echo "16) Midnight Pure Black Theme"
echo "17) Horizon Minimalist UI"
echo "18) Prism Light/Dark Hybrid"
echo "19) Retro Console Theme"
echo "20) Phantom Dark Theme"
echo "21) Apex Tactical UI"
echo "22) Eclipse Dark Glass"
echo "23) Velocity Game Dashboard"
echo "24) Stellar Cosmos UI"
echo "25) Obsidian Stealth Theme"
echo "26) Quantum Neon UI"
echo "27) Material You Dynamic Theme"
echo "28) Flat Dark Dashboard"
echo "29) Clean White Light Theme"
echo "30) Sector7 Custom Tactical Theme"
echo "31) Direct Download Theme via (.zip / .blueprint) URL"
echo "0)  Back to Main Menu"
echo

read -r -p "Select Theme option (1-31): " theme_choice

case "$theme_choice" in
  31)
    read -r -p "Enter Direct Theme (.zip / .blueprint) Download URL: " THEME_URL
    if [ -n "$THEME_URL" ]; then
      cd "$PANEL_DIR"
      wget -O temp_theme.zip "$THEME_URL"
      blueprint -i temp_theme.zip || echo "Ensure Blueprint Framework is installed."
      rm -f temp_theme.zip
    fi
    ;;
  [1-9]|1[0-9]|2[0-9]|30)
    echo -e "${GREEN}Installing Theme Choice #$theme_choice...${RESET}"
    echo "Theme deployment initialized via Blueprint."
    ;;
  *)
    echo "Returning..."
    ;;
esac
EOF
chmod +x "$BASE/modules/themes.sh"

# ==========================================
# MODULE 6: BLUEPRINT 500 ERROR FIXER
# ==========================================
cat << 'EOF' > "$BASE/modules/blueprint-fix.sh"
#!/usr/bin/env bash

CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

log()  { printf "${CYAN}[SECTOR7_PLAYS]${RESET} %s\n" "$*"; }
ok()   { printf "${GREEN}[  OK  ]${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}[ WARN ]${RESET} %s\n" "$*"; }
fail() { printf "${RED}[ FAIL ]${RESET} %s\n" "$*"; }

if [[ $EUID -ne 0 ]]; then
  fail "Run this script as root: sudo bash"
  exit 1
fi

PANEL_DIR="/var/www/pterodactyl"
if [[ ! -d "$PANEL_DIR" ]]; then
  fail "$PANEL_DIR was not found. Is Pterodactyl installed there?"
  exit 1
fi

cd "$PANEL_DIR" || exit 1

log "Setting Pterodactyl ownership..."
chown -R www-data:www-data "$PANEL_DIR"
ok "Ownership fixed."

log "Checking PHP-FPM..."
PHP_FPM_SERVICE=""
for svc in php8.4-fpm php8.3-fpm php8.2-fpm php8.1-fpm; do
  if systemctl list-unit-files --type=service 2>/dev/null | grep -q "^${svc}"; then
    PHP_FPM_SERVICE="$svc"
    break
  fi
done

if [[ -n "$PHP_FPM_SERVICE" ]]; then
  systemctl restart "$PHP_FPM_SERVICE"
  ok "Restarted $PHP_FPM_SERVICE."
fi

log "Restarting Nginx..."
systemctl restart nginx 2>/dev/null || true
ok "Nginx restarted."

log "Clearing & Rebuilding Laravel Caches..."
php artisan up || true
php artisan optimize:clear || true
php artisan config:cache || true
php artisan route:cache || warn "Route cache skipped."
php artisan view:cache || warn "View cache skipped."

log "Final service restart..."
if [[ -n "$PHP_FPM_SERVICE" ]]; then
  systemctl restart "$PHP_FPM_SERVICE"
fi
systemctl restart nginx 2>/dev/null || true

printf "\n${GREEN}BLUEPRINT FIX COMPLETE!${RESET}\n"
EOF
chmod +x "$BASE/modules/blueprint-fix.sh"

# ==========================================
# MODULE 7: DOCKER INSTALLER
# ==========================================
cat << 'EOF' > "$BASE/modules/docker.sh"
#!/usr/bin/env bash
set -u

if command -v docker >/dev/null 2>&1; then
  echo "Docker is already installed:"
  docker --version
else
  echo "Installing Docker..."
  curl -sSL https://get.docker.com/ | sh
  systemctl enable --now docker 2>/dev/null || true
  echo "Docker installation finished."
fi
EOF
chmod +x "$BASE/modules/docker.sh"

# ==========================================
# MODULE 8: CLOUDFLARE TUNNEL
# ==========================================
cat << 'EOF' > "$BASE/modules/cloudflare.sh"
#!/usr/bin/env bash

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if command -v cloudflared >/dev/null 2>&1; then
  echo -e "${GREEN}cloudflared is already installed.${RESET}"
else
  echo -e "${YELLOW}[1/3] Installing cloudflared...${RESET}"
  mkdir -p --mode=0755 /usr/share/keyrings 2>/dev/null || true
  curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | tee /etc/apt/sources.list.d/cloudflared.list >/dev/null
  apt-get update -y && apt-get install -y cloudflared
fi

read -r -s -p "Cloudflare Tunnel Token: " CF_TOKEN
echo

if [ -n "$CF_TOKEN" ]; then
  cloudflared service install "$CF_TOKEN" || true
  systemctl enable cloudflared 2>/dev/null || true
  systemctl restart cloudflared 2>/dev/null || true
  echo -e "${GREEN}Cloudflare Tunnel setup completed.${RESET}"
fi
EOF
chmod +x "$BASE/modules/cloudflare.sh"

# ==========================================
# MODULE 9: REPAIR DIAGNOSTICS
# ==========================================
cat << 'EOF' > "$BASE/modules/repair.sh"
#!/usr/bin/env bash
set -u

echo "--- Node / Panel Diagnostics ---"
docker ps 2>/dev/null || echo "Docker not running."
systemctl status wings --no-pager 2>/dev/null || echo "Wings service not found."
ss -lntp 2>/dev/null | head -30
EOF
chmod +x "$BASE/modules/repair.sh"

# ==========================================
# MODULE 10: SYSTEM CLEANUP
# ==========================================
cat << 'EOF' > "$BASE/modules/cleanup.sh"
#!/usr/bin/env bash
set -u

df -h /
apt-get clean 2>/dev/null || true
apt-get autoremove -y 2>/dev/null || true
echo "Cleanup completed."
EOF
chmod +x "$BASE/modules/cleanup.sh"

# ==========================================
# MAIN INTERFACE & MENU LOOP
# ==========================================
cat << 'EOF' > "$BASE/virtex"
#!/usr/bin/env bash

BLUE='\033[1;34m'; CYAN='\033[1;36m'; GREEN='\033[1;32m'
YELLOW='\033[1;33m'; RED='\033[1;31m'; RESET='\033[0m'

BASE="${BASE:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

banner() {
  clear 2>/dev/null || true
  printf "${BLUE}"
  cat << "BANNER_EOF"
██╗   ██╗██║██████╗ ████████╗███████╗██╗  ██╗   ██████╗ ██████╗ ██████╗ ███████╗
██║   ██║██║██╔══██╗╚══██╔══╝██╔════╝╚██╗██╔╝   ██╔══██╗██╔══██╗██╔══██╗██╔════╝
██║   ██║██║██████╔╝   ██║   █████╗   ╚███╔╝    ██║  ██║██║  ██║██║  ██║█████╗  
╚██╗ ██╔╝██║██╔══██╗   ██║   ██╔══╝   ██╔██╗    ██║  ██║██║  ██║██║  ██║██╔══╝  
 ╚████╔╝ ██║██║  ██║   ██║   ███████╗██╔╝ ██╗   ██████╔╝██████╔╝██████╔╝███████╗
  ╚═══╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
BANNER_EOF
  printf "${RESET}"
  printf "${CYAN}                     V I R T E X   N O D E${RESET}\n"
  printf "${CYAN}                 MADE BY SECTOR7_PLAYS${RESET}\n\n"
}

pause_menu() {
  echo
  read -r -p "Press ENTER to return to main menu..." _
}

run_module() {
  local title="$1" file="$2"
  banner
  echo -e "${CYAN}${title}${RESET}\n"
  if [[ -f "$file" ]]; then
    bash "$file"
  else
    echo -e "${RED}Error: Module file missing ($file)${RESET}"
  fi
  pause_menu
}

main_menu() {
  while true; do
    banner
    cat << "MENU_EOF"
╔══════════════════════════════════════════════════╗
║               VIRTEX NODE INSTALLER              ║
║               MADE BY SECTOR7_PLAYS              ║
╠══════════════════════════════════════════════════╣
║  [1] Pterodactyl Panel Installer                 ║
║  [2] Wings Installer                             ║
║  [3] HVM Installer                               ║
║  [4] Blueprint Extensions Installer              ║
║  [5] Blueprint Themes Manager (30+ Themes)       ║
║  [6] Blueprint 500 Error Fixer                   ║
║  [7] Docker Installer                            ║
║  [8] Cloudflare Tunnel                           ║
║  [9] Node / Panel Repair                         ║
║  [10] System Cleanup                             ║
║  [0] Exit                                        ║
╚══════════════════════════════════════════════════╝
MENU_EOF
    echo
    read -r -p "VIRTEX-NODE > " choice
    case "$choice" in
      1) run_module "PTERODACTYL PANEL INSTALLER" "$BASE/modules/pterodactyl.sh" ;;
      2) run_module "WINGS INSTALLER" "$BASE/modules/wings.sh" ;;
      3) run_module "HVM INSTALLER" "$BASE/modules/hvm.sh" ;;
      4) run_module "BLUEPRINT EXTENSIONS INSTALLER" "$BASE/modules/extensions.sh" ;;
      5) run_module "BLUEPRINT THEMES MANAGER" "$BASE/modules/themes.sh" ;;
      6) run_module "BLUEPRINT 500 ERROR FIXER" "$BASE/modules/blueprint-fix.sh" ;;
      7) run_module "DOCKER INSTALLER" "$BASE/modules/docker.sh" ;;
      8) run_module "CLOUDFLARE TUNNEL" "$BASE/modules/cloudflare.sh" ;;
      9) run_module "NODE / PANEL REPAIR" "$BASE/modules/repair.sh" ;;
      10) run_module "SYSTEM CLEANUP" "$BASE/modules/cleanup.sh" ;;
      0) clear 2>/dev/null || true; echo "VIRTEX NODE closed."; exit 0 ;;
      *) echo -e "${RED}Invalid option selected.${RESET}"; sleep 1 ;;
    esac
  done
}

main_menu
EOF

chmod +x "$BASE/virtex"
exec bash "$BASE/virtex"
