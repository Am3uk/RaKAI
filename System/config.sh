#!/bin/bash

# ╔══════════════════════════════════════╗
# ║      RaKAI :: Config Generator       ║
# ║         by Johnny // Legend          ║
# ╚══════════════════════════════════════╝

clear
echo "╔══════════════════════════════════════╗"
echo "║      RAKAI // Gerador de Config      ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Caminhos
BASE_DIR="$(dirname "$(realpath "$0")")/.."
CONFIG_DIR="$BASE_DIR/System"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Verifica existência
if [ -f "$CONFIG_FILE" ]; then
    echo "--Arquivo config.json já existe em $CONFIG_FILE"
    read -p "Deseja sobrescrever? (s/n): " overwrite
    if [[ "$overwrite" != "s" ]]; then
        echo "-X- Cancelado. Configuração preservada."
        exit 0
    fi
fi

# Inputs do usuário
read -p "Nome da Entidade (ex: RaKAI): " entity_name
read -p "Versão do Sistema (ex: 1.0): " version
read -p "Personalidade (ex: Analítico, Sarcástico, Neutro): " personality
read -p "ID do Host (ex: RAKAI-001): " host_id
read -p "Localização Base (ex: Johnny-Lab, Mobile, Desktop): " location

# Data de criação automática
creation_date=$(date '+%Y-%m-%d %H:%M:%S')

# Gerar config.json
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_FILE" <<EOL
{
    "entity_name": "$entity_name",
    "version": "$version",
    "personality": "$personality",
    "host_id": "$host_id",
    "location": "$location",
    "boot_count": 0,
    "creation_date": "$creation_date",
    "logs_enabled": true,
    "memory_path": "$BASE_DIR/Memories",
    "modules_path": "$BASE_DIR/Modules",
    "scripts_path": "$BASE_DIR/Scripts",
    "status": "active"
}
EOL

echo ""
echo "[X]  Configuração criada com sucesso em:"
echo "--> $CONFIG_FILE"
echo ""
echo "[X] Sistema pronto para boot."
