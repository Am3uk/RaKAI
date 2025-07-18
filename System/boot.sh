
# Logar boot
echo "$(date) | RaKAI iniciado"

echo ""
echo "=================================="
echo "     RaKAI está online."
echo "=================================="



#!/bin/bash

echo "=================================="
echo "      RaKAI - Boot Sequence"
echo "=================================="
echo ""

# Caminho raiz (ajusta se estiver em outro lugar)
ROOT_DIR="$(dirname "$(realpath "$0")")/.."

# Verificar se pastas essenciais existem
folders=("System" "Core" "Tools" "Memory" "Logs" "Assets" "Models")

for folder in "${folders[@]}"
do
    if [ ! -d "$ROOT_DIR/$folder" ]; then
        echo "[!] Pasta faltando: $folder — Criando..."
        mkdir -p "$ROOT_DIR/$folder"
    else
        echo "[X] Pasta encontrada: $folder"
    fi
done

CONFIG_FILE="$ROOT_DIR/System/config.json"
LOG_FILE="$ROOT_DIR/Logs/boot.log"

# Carregar configurações
if [ -f "$ROOT_DIR/System/config.json" ]; then
    echo "[X] Configuração carregada."

    #checar se jq foi instalado
    if ! command -v jq &> /dev/null; then
        echo "[!] jq não está instalado. Rode: 'sudo apt install jq'"
        exit 1
    fi

    #extrair dados JSON
    entity_name=$(jq -r '.entity_name' "$CONFIG_FILE")
    version=$(jq -r '.version' "$CONFIG_FILE")
    personality=$(jq -r '.version' "$CONFIG_FILE")
    host_id=$(jq -r '.host_id' "$CONFIG_FILE")
    location=$(jq -r '.location' "$CONFIG_FILE")
    boot_count=$(jq -r '.boot_count' "$CONFIG_FILE")

    #incrementar o boot_count
    new_boot_count=$((boot_count + 1))
    jq ".boot_count = $new_boot_count" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    echo ""
    echo "→ Entidade: $entity_name"
    echo "→ Host ID: $host_id"
    echo "→ Localização: $location"
    echo "→ Personalidade: $personality"
    echo "→ Versão: $version"
    echo "→ Boot #: $new_boot_count"
    echo ""

    #atualizar log
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] BOOT | $entity_name | HOST: $host_id | Boot #$new_boot_count" >> "$LOG_FILE"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE" 

else
    echo "[!] Arquivo config.json não encontrado em /System — Usando padrões."
fi
