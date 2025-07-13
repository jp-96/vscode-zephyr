#!/bin/bash
# launch-debugserver.sh — Prepares environment and launches Zephyr debugserver

cd "/home/vscode/zephyr/dev/"

echo "[INFO] Running permission fix script..."
./fix-microbit-perms.sh

echo "[INFO] Launching west debugserver..."
cd zephyrproject
west debugserver
