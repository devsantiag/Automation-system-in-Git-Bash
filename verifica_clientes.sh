#!/bin/bash

# Carregar variáveis do arquivo .env.verifica_clientes
if [ -f .env.verifica_clientes ]; then
    source .env.verifica_clientes
fi

offset=0

while true
do
    clear
    echo "🔎 Lista de Clientes em $(date):"

    RESULTADO=$(mysql -u "$USUARIO" -D "$BANCO" -e "SELECT nome, ip, ativo, id FROM dispositivos ORDER BY rand() LIMIT 1 OFFSET $offset;" 2>&1)
    STATUS=$?

    if [ $STATUS -ne 0 ]; then
        TENTATIVAS=$((TENTATIVAS+1))
        echo "⚠️ Falha ao Conectar ao Banco. Tentativas: $TENTATIVAS de $MAX_TENTATIVAS"

        if [ $TENTATIVAS -ge $MAX_TENTATIVAS ]; then
            echo -e "\n🚨 Banco de dados FORA DO AR após $MAX_TENTATIVAS tentativas!"
            break
        fi
    else
        TENTATIVAS=0

        if [ -z "$RESULTADO" ]; then
            echo -e "\n⚠️ Nenhum cliente encontrado."
            break
        else
            CLIENTE=$(echo "$RESULTADO" | tail -n 1 | awk '{print $1}')
            IP=$(echo "$RESULTADO" | tail -n 1 | awk '{print $2}')
            ATIVO_STR=$(echo "$RESULTADO" | tail -n 1 | awk '{print $3}')
            ID=$(echo "$RESULTADO" | tail -n 1 | awk '{print $4}')

            if [[ "$ATIVO_STR" == "sim" ]]; then
                ATIVO=1
            else
                ATIVO=0
            fi

            echo "Cliente: $CLIENTE | IP: $IP | User ID: $ID | Ativo: $ATIVO"
        fi
    fi

    offset=$((offset+1))
    echo -e "\n⏳ Atualização em andamento..."
    sleep 5
done