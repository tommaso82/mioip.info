#!/usr/bin/env bash
# ==============================================================================
# Script: monitor_ip.sh
# Description: Monitora i cambiamenti dell'IP pubblico (IPv4/IPv6) usando mioip.info
# Author: Tommaso82
# Link: https://mioip.info
# ==============================================================================

# Impostazioni di default
LOG_FILE="/var/log/mioip_monitor.log"
CURRENT_IP_FILE="/tmp/mioip_current.txt"
PROTOCOL="ipv4" # Valori supportati: ipv4, ipv6, auto

# Colori per l'output in terminale
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funzione: Mostra l'aiuto
show_help() {
    echo -e "Usage: $0 [OPTIONS]"
    echo -e "Monitora i cambiamenti del tuo IP pubblico usando mioip.info"
    echo -e "\nOptions:"
    echo -e "  -4          Forza l'uso di IPv4 (default)"
    echo -e "  -6          Forza l'uso di IPv6"
    echo -e "  -a          Usa risoluzione automatica"
    echo -e "  -l <file>   Percorso personalizzato per il log file (default: $LOG_FILE)"
    echo -e "  -h          Mostra questo aiuto"
    exit 0
}

# Parsing degli argomenti
while getopts "46al:h" opt; do
    case ${opt} in
        4 ) PROTOCOL="ipv4" ;;
        6 ) PROTOCOL="ipv6" ;;
        a ) PROTOCOL="auto" ;;
        l ) LOG_FILE=$OPTARG ;;
        h ) show_help ;;
        \? ) show_help ;;
    esac
done

# Determina l'URL da chiamare in base al protocollo
if [ "$PROTOCOL" = "auto" ]; then
    API_URL="https://mioip.info"
else
    API_URL="https://${PROTOCOL}.mioip.info"
fi

# Funzione per loggare e stampare
log_message() {
    local message="$(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo -e "${message}"
    # Se il file di log è scrivibile o la directory esiste, scrivi il log
    if [ -w "$LOG_FILE" ] || [ -w "$(dirname "$LOG_FILE")" ]; then
        echo "$message" >> "$LOG_FILE"
    fi
}

# 1. Ottieni il nuovo IP
# Usiamo curl con timeout per evitare che lo script si blocchi se cade la rete
NEW_IP=$(curl -s --max-time 10 "$API_URL")

# Controllo errori di rete
if [ -z "$NEW_IP" ]; then
    log_message "${RED}ERRORE: Impossibile contattare $API_URL. Rete offline?${NC}"
    exit 1
fi

# 2. Ottieni il vecchio IP (se esiste)
if [ -f "$CURRENT_IP_FILE" ]; then
    OLD_IP=$(cat "$CURRENT_IP_FILE")
else
    OLD_IP="Nessuno"
fi

# 3. Compara e Agisci
if [ "$NEW_IP" != "$OLD_IP" ]; then
    log_message "${YELLOW}CAMBIO IP RILEVATO!${NC} Vecchio: $OLD_IP -> Nuovo: ${GREEN}$NEW_IP${NC}"
    echo "$NEW_IP" > "$CURRENT_IP_FILE"
    
    # ==========================================================
    # INSERISCI QUI LA TUA LOGICA CUSTOM
    # Esempio: Invia notifica Telegram, aggiorna DNS, riavvia VPN
    # ==========================================================
    
    # Esempio Telegram (scommenta e compila se serve)
    # TELEGRAM_TOKEN="tuo_token"
    # CHAT_ID="tuo_chat_id"
    # curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
    #     -d chat_id="${CHAT_ID}" \
    #     -d text="IP cambiato: $NEW_IP" > /dev/null
    
else
    # Output silenzioso se l'IP non è cambiato (utile se gira in cron)
    # Rimuovi il commento sotto se vuoi loggare ogni singolo check
    # log_message "IP invariato: $NEW_IP"
    exit 0
fi
