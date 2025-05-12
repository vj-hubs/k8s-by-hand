#!/bin/bash
set -e

# Check if limactl is installed, otherwise install lima
if ! command -v limactl >/dev/null 2>&1; then
  echo "limactl not found. Installing lima using Homebrew..."
  if ! brew install lima; then
    echo "Failed to install lima. Please install it manually."
    exit 1
  fi
fi

# Delete existing VMs if they exist
limactl delete -f jumpbox server node-0 node-1 || true

# Start all VMs defined by YAML files in this directory
for yaml in $(ls *.yaml); do
  echo "Starting VM from $yaml..."
  limactl start "$(pwd)/$yaml" --tty=false
  echo "Started $yaml"
done
