#!/bin/sh
set -e

V1_HEX="${1:-../zephyrproject/builds/bbc_microbit/zephyr/zephyr.hex}"
V2_HEX="${2:-../zephyrproject/builds/bbc_microbit_v2/zephyr/zephyr.hex}"
OUT="${3:-../zephyrproject/builds/microbit-universal.hex}"

echo "🧩 Generating Universal HEX..."
echo "  V1_HEX: $V1_HEX"
echo "  V2_HEX: $V2_HEX"

node -e "
  const fs = require('fs');
  const { createUniversalHex } = require('@microbit/microbit-universal-hex');

  function checkHex(path) {
    if (!fs.existsSync(path)) {
      throw new Error('HEX file not found: ' + path);
    }
    const data = fs.readFileSync(path, 'utf8');
    if (!data.trim()) {
      throw new Error('HEX file is empty: ' + path);
    }
    return data;
  }

  const hexV1 = checkHex('${V1_HEX}');
  const hexV2 = checkHex('${V2_HEX}');

  // Provide boardId for each hex (V1: 0x9900, V2: 0x9903)
  const universalHex = createUniversalHex([
    { hex: hexV1, boardId: 0x9900 },
    { hex: hexV2, boardId: 0x9903 }
  ]);
  fs.writeFileSync('${OUT}', universalHex);

  console.log('✅ Universal HEX created at: ${OUT}');
"
