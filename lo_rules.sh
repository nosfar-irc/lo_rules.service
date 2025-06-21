#!/bin/bash
LOGFILE="/var/log/lo_rules.log"
GREP_RULE="from 127.0.0.1/8 iif lo lookup 123"

echo "Service started at $(date)" >> "$LOGFILE"

while true; do

  if ip rule show | grep -qF "$GREP_RULE"; then
    # Reguła już istnieje – nic nie robimy
    :
  else
    # Reguły nie ma – dodajemy i logujemy
    ip rule add from 127.0.0.1/8 iif lo table 123
    ip -6 rule add from ::1/128 iif lo table 123
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Dodano reguły dla \"iif lo table 123\" " >> "$LOGFILE"
  fi

# Usypia usluge na 20s
  sleep 20
done
