#!/bin/sh

# Usage: ./generate-machines.sh [--provider lima|multipass]
# Default provider is lima

PROVIDER="lima"
if [ "$1" = "--provider" ] && [ -n "$2" ]; then
  PROVIDER="$2"
fi

# List of VMs
VMS="server node-0 node-1"

# Output file
OUTFILE="machines.txt"
> "$OUTFILE"  # Empty the file if it exists

for vm in $VMS; do
  # Get the IP address based on provider
  if [ "$PROVIDER" = "multipass" ]; then
    ip=$(multipass exec "$vm" -- hostname -I | awk '{print $1}')
  else
    ip=$(limactl shell "$vm" -- hostname -I | awk '{print $1}')
  fi

  # Compose the line based on the VM name
  case "$vm" in
    server)
      echo "$ip server.kubernetes.local server" >> "$OUTFILE"
      ;;
    node-0)
      echo "$ip node-0.kubernetes.local node-0 10.200.0.0/24" >> "$OUTFILE"
      ;;
    node-1)
      echo "$ip node-1.kubernetes.local node-1 10.200.1.0/24" >> "$OUTFILE"
      ;;
  esac
done

echo "machines.txt created:"
cat "$OUTFILE"

# Copy file to jumpbox based on provider
if [ "$PROVIDER" = "multipass" ]; then
  jumpbox_ip=$(multipass exec jumpbox -- hostname -I | awk '{print $1}')
  echo "Copying machines.txt to jumpbox (root@${jumpbox_ip}:/root/)..."
  scp "$OUTFILE" root@"$jumpbox_ip":/root/
else
  echo "Copying machines.txt to jumpbox (root@127.0.0.1:2222:/root/)..."
  scp -P 2222 "$OUTFILE" root@127.0.0.1:/root/
fi
echo "Done!"
