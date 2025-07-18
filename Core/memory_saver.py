import json
import os
from datetime import datetime

def save_memory(memory_path, new_entry):
    if not os.path.exists(memory_path):
        base_data = {"memorias": []}
    else:
        with open(memory_path, 'r', encoding='utf-8') as f:
            try:
                base_data = json.load(f)
            except json.JSONDecodeError:
                base_data = {"memorias": []}

    new_entry["timestamp"] = datetime.now().isoformat()
    base_data["memorias"].append(new_entry)

    with open(memory_path, 'w', encoding='utf-8') as f:
        json.dump(base_data, f, indent=2, ensure_ascii=False)
