#!/bin/bash

TARGETS=("0d28:0204")

while IFS= read -r line; do
  for id in "${TARGETS[@]}"; do
    if echo "$line" | grep -qi "$id"; then
      BUS=$(echo "$line" | awk '{printf "%03d", $2}')
      DEV=$(echo "$line" | awk '{gsub(":", "", $4); printf "%03d", $4}')
      DEV_PATH="/dev/bus/usb/$BUS/$DEV"
      echo "Found micro:bit at $DEV_PATH"
      if sudo chmod 666 "$DEV_PATH"; then
        echo "Permissions set to 666 for $DEV_PATH"
      else
        echo "Failed to set permissions for $DEV_PATH" >&2
      fi
    fi
  done
done < <(lsusb)
