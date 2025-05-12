#!/bin/bash

set -e

# Check if multipass is installed, otherwise install it
if ! command -v multipass >/dev/null 2>&1; then
  echo "multipass not found. Installing multipass using Homebrew..."
  if ! brew install --cask multipass; then
    echo "Failed to install multipass. Please install it manually."
    exit 1
  fi
fi

# Delete all existing VMs and purge
multipass delete --all
multipass purge

# VM definitions: name memory disk
VMS=(
  "jumpbox 512M 10G"
  "server 2G 20G"
  "node0 2G 20G"
  "node1 2G 20G"
)

for vm in "${VMS[@]}"; do
  set -- $vm
  NAME=$1
  MEM=$2
  DISK=$3
  echo "Launching VM '$NAME'..."
  if [ "$NAME" = "jumpbox" ]; then
    multipass launch --name "$NAME" --memory "$MEM" --disk "$DISK" --cloud-init jumpbox.yaml
  else
    multipass launch --name "$NAME" --memory "$MEM" --disk "$DISK"
  fi
done
