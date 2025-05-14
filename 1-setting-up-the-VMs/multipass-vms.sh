#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if multipass is installed, otherwise install it
if ! command -v multipass >/dev/null 2>&1; then
  echo "multipass not found. Installing multipass using Homebrew..."
  if ! brew install --cask multipass; then
    echo "Failed to install multipass. Please install it manually."
    exit 1
  fi
fi

# Delete the existing VMs and purge
multipass delete jumpbox server node-0 node-1 || true
multipass purge

# VM definitions: name memory disk
VMS=(
  "jumpbox 512M 10G"
  "server 2G 20G"
  "node-0 2G 20G"
  "node-1 2G 20G"
)

for vm in "${VMS[@]}"; do
  set -- $vm
  NAME=$1
  MEM=$2
  DISK=$3
  echo "Launching VM '$NAME'..."
    multipass launch --name "$NAME" --memory "$MEM" --disk "$DISK" --cloud-init "$SCRIPT_DIR/cloud-init.yaml"
done
