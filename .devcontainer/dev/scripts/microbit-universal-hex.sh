#!/bin/bash

set -e  # Exit immediately if any command fails

echo "🛠️ Building micro:bit v1..."
west build -p auto -b bbc_microbit
cp ./build/zephyr/zephyr.hex ./microbit-v1.hex

echo "🛠️ Building micro:bit v2..."
west build -p auto -b bbc_microbit_v2
cp ./build/zephyr/zephyr.hex ./microbit-v2.hex

echo "🔗 Merging HEX files into a universal format..."
node ../.vscode/utils/uhex.js ./microbit-v1.hex ./microbit-v2.hex ./microbit-universal.hex

echo "✅ All done! Output: microbit-universal.hex"
