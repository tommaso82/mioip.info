#!/bin/bash

# Configurazione: File per memorizzare l'ultimo IP rilevato
IP_FILE="/percorso/completo/ip_last.txt"

# Configurazione: Email per inviare la notifica
EMAIL="tuo-email@example.com"

# Funzione per inviare una notifica via email
send_email_notification() {
    local new_ip=$1
    echo "Il tuo indirizzo IP è cambiato. Il nuovo IP è: $new_ip" | mail -s "Cambio di IP Rilevato" $EMAIL
}

# Funzione per ottenere l'indirizzo IP corrente usando mioip.info
get_current_ip() {
    curl -s https://mioip.info
}

# Funzione principale
check_ip_change() {
    # Ottieni l'IP corrente
    current_ip=$(get_current_ip)
    
    # Verifica se il file IP_FILE esiste
    if [[ -f $IP_FILE ]]; then
        # Leggi l'ultimo IP salvato
        last_ip=$(cat $IP_FILE)
        
        # Confronta l'IP corrente con l'ultimo IP salvato
        if [[ "$current_ip" != "$last_ip" ]]; then
            # L'IP è cambiato, invia una notifica
            send_email_notification $current_ip
            
            # Aggiorna il file con il nuovo IP
            echo $current_ip > $IP_FILE
        fi
    else
        # Il file non esiste, crea il file e salva l'IP corrente
        echo $current_ip > $IP_FILE
    fi
}

# Esegui la funzione principale
check_ip_change

# --------------------------------------
# CRON
# --------------------------------------
#
# Per aggiungere questo script al cron, puoi utilizzare il seguente comando:
# 
# crontab -e
#
# Aggiungi la seguente riga al file crontab per eseguire lo script ogni 5 minuti:
# 
# */5 * * * * /percorso/completo/monitor_ip.sh
#
# Assicurati di sostituire "/percorso/completo/monitor_ip.sh" con il percorso completo del tuo script.
#
