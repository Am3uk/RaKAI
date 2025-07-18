#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import json
import datetime
import subprocess

#Caminhos
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
CONFIG_PATH = os.path.join(ROOT_DIR, "System", "config.json")
MEMORY_PATH = os.path.join(ROOT_DIR, "Memory", "memory.json")
LOG_PATH = os.path.join(ROOT_DIR, "Logs", "session.log")
MODEL_PATH = os.path.join(ROOT_DIR, "Models", "llama.cpp", "build", "bin", "llama-run")  # binário compilado
MODEL_FILE = os.path.join(ROOT_DIR, "Models", "phi2", "phi-2.Q4_K_M.gguf")

#Utilidades

def load_config():
    with open(CONFIG_PATH, "r") as f:
        return json.load(f)

def load_memory():
    if not os.path.exists(MEMORY_PATH):
        return []
    with open(MEMORY_PATH, "r") as f:
        data = json.load(f)
        if isinstance(data, list):
            return data
        else:
            return []  # Se for dict ou outra coisa, reseta para lista vazia

def save_memory(memory):
    with open(MEMORY_PATH, "w") as f:
        json.dump(memory, f, indent=4)

def log_message(text):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_PATH, "a") as f:
        f.write(f"[{timestamp}] {text}\n")

# ============ Interação com Modelo ============

def call_model(prompt):
    """
    Chama o modelo local usando subprocess.
    Retorna a resposta gerada.
    """
    try:
        result = subprocess.run(
            [
                MODEL_PATH,
                MODEL_FILE,
                prompt,
                "--temp", "0.2",
                "-t", "2"
                "-c", "256"
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        output = result.stdout.strip()
        return output
    except Exception as e:
        return f"Erro ao chamar o modelo: {e}"

# ============ Loop Principal ============

def main():
    print("===============================")
    print("     RaKAI - Núcleo Ativo")
    print("===============================\n")

    config = load_config()
    memory = load_memory()

    print(f"Olá, sou {config.get('entity_name', 'RaKAI')} v{config.get('version', '?.?')}")
    print("Digite 'exit' para sair.\n")

    while True:
        user_input = input("Você > ")

        if user_input.lower() == "exit":
            print("Encerrando sessão.")
            break

        # Armazena entrada
        memory.append({"input": "john", "content": user_input})
        save_memory(memory)

        # Chama o modelo
        response = call_model(user_input)

        # Armazena resposta
        memory.append({"output": "RaKAI", "content": response})
        save_memory(memory)

        # Exibe resposta
        print(f"RaKAI > {response}")

        # Loga sessão
        log_message(f"Usuário: {user_input}")
        log_message(f"RaKAI: {response}")


if __name__ == "__main__":
    main()
