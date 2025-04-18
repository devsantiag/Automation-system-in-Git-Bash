#!/bin/bash

# clientes_ativos.sh = responsável por verificar os Clientes ativos e retornar os não ativos na aplicação c#

# USUARIO="root"
# BANCO="svr1"
# SAIDA="clientes_ativos.txt"

if [[ -f .env.clientes_ativos ]]; then
    source .env.clientes_ativos
fi

echo "" > "$SAIDA" # Limpa arquivo

# Busca todos os dispositivos
DISPOSITIVOS=$(mysql -u "$USUARIO" -D "$BANCO" -se "SELECT nome, ip FROM dispositivos;")

while IFS=$'\t' read -r nome ip; do
    tentativas=0
    sucesso=0

    while [ $tentativas -lt 5 ]; do
        ping -c 1 -W 1 "$ip" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            sucesso=$((sucesso+1))
        fi
        tentativas=$((tentativas+1))
    done

    if [ $sucesso -eq 5 ]; then
        echo "$nome" >> "$SAIDA"
    fi
done <<< "$DISPOSITIVOS"