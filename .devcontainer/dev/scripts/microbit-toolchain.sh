#!/bin/bash

set -e  # Exit immediately if any command fails

MODE="$1"        # Operation mode: flash, debugserver, or both
BOARD_ARG="$2"   # Optional board name override: bbc_microbit or bbc_microbit_v2
TARGETS=("0d28:0204")  # USB vendor:product ID for micro:bit detection
BOARD=""
DEV_PATH=""

# Check if the provided mode is valid
if [[ "$MODE" != "flash" && "$MODE" != "debugserver" && "$MODE" != "both" ]]; then
  echo "Usage: $0 [flash|debugserver|both] [optional: bbc_microbit|bbc_microbit_v2]"
  exit 1
fi

# Step 1: Detect micro:bit USB device and set permission
while IFS= read -r line; do
  for id in "${TARGETS[@]}"; do
    if [[ "$line" == *"$id"* ]]; then
      BUS=$(printf "%03d" "$(echo "$line" | awk '{print $2}')")
      DEV=$(printf "%03d" "$(echo "$line" | awk '{gsub(":", "", $4); print $4}')")
      DEV_PATH="/dev/bus/usb/$BUS/$DEV"

      echo "🔌 micro:bit detected at $DEV_PATH"

      if [[ -e "$DEV_PATH" ]]; then
        if sudo chmod 666 "$DEV_PATH"; then
          echo "✅ Permissions set for $DEV_PATH"
        else
          echo "❌ Failed to set permissions" >&2
        fi
      else
        echo "⚠️ Device path does not exist: $DEV_PATH" >&2
      fi
      break
    fi
  done
done < <(lsusb)

# Step 2: Determine board name from argument or via pyocd auto-detection
if [[ -n "$BOARD_ARG" ]]; then
  BOARD="$BOARD_ARG"
  echo "📦 Using board specified by argument: $BOARD"
else
  result=$(pyocd list)

  if echo "$result" | grep -q "nrf51"; then
    BOARD="bbc_microbit"
    echo "🎯 Detected board: micro:bit v1"
  elif echo "$result" | grep -q "nrf52833"; then
    BOARD="bbc_microbit_v2"
    echo "🎯 Detected board: micro:bit v2"
  else
    echo "❌ No supported board detected"
    exit 1
  fi
fi

# Step 3: Build firmware for the detected or specified board
echo "🔨 Building firmware for $BOARD ..."
west build -p auto -b "$BOARD"

# Step 4: Optionally flash firmware
if [[ "$MODE" == "flash" || "$MODE" == "both" ]]; then
  echo "⚡ Flashing firmware to $BOARD ..."
  west flash
fi

# Step 5: Optionally start debug server
if [[ "$MODE" == "debugserver" || "$MODE" == "both" ]]; then
  echo "🚀 Launching debugserver for $BOARD ..."
  west debugserver
fi
