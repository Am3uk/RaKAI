#!/bin/bash
echo "Booting RaKAI..."
sleep 1
bash System/boot.sh
sleep 1
python3 Core/rakai_core.py
