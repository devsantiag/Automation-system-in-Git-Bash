#!/bin/bash

INTERVALO=5  # intervalo em segundos

while true; do
    DATA=$(date +"%H:%M:%S - %d/%m")
    echo "📅 Agora é $DATA"
    sleep $INTERVALO
done

