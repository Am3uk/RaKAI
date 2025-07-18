#!/bin/bash

#configs iniciais, pasta do modelo a ser carregado
ROOT_DIR="$(dirname "$(realpath "$0")")/.."
CONFIG="$ROOT_DIR/System/config.json"
MODEL_PATH="$ROOT_DIR/Models/phi2/phi-2.Q4_K_M.gguf"
LLAMA_BIN="$ROOT_DIR/Models/llama.cpp/build/main"

#verificar se jq foi instalado
if ! command -v jq &> /dev/null; then
    echo "[!] jq não instalado. Rode: sudo apt install jq"
    exit 1
fi

#retirar info do arquivo de configuracao
entity_name=$(jq -r '.entity_name' "$CONFIG")
version=$(jq -r '.version' "$CONFIG")
personality=$(jq -r '.personality' "$CONFIG")
location=$(jq -r '.location' "$CONFIG")
boot_count=$(jq -r '.boot_count' "$CONFIG")

#prompt inicial
prompt="Você é $entity_name, uma IA local criada por Johnny. Versão $version. Sua personalidade é $personality. Você está localizada em $location. Este é seu boot número $boot_count. Seja coerente, funcional, criativo e direto."

echo "[X] Inicializando RaKAI com o modelo local..."
"$LLAMA_BIN" -m "$MODEL_PATH" -n 256 -p "$prompt"
