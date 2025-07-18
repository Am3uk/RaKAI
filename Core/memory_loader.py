import json
import os

def load_memory(memory_path):
    if not os.path.exists(memory_path):
        print(f"[!] Arquivo de memória não encontrado: {memory_path}")
        return []

    with open(memory_path, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
            return data.get("memorias", [])
        except json.JSONDecodeError:
            print("[!] Erro ao ler memory.json")
            return []
