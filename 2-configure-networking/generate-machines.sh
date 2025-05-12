#!/bin/sh

# List of VMs
VMS="server node-0 node-1"

# Output file
OUTFILE="machines.txt"
> "$OUTFILE"  # Empty the file if it exists

for vm in $VMS; do
  # Get the IP address
  ip=$(limactl shell "$vm" -- ip -f inet addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)

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

echo "Copying machines.txt to jumpbox (root@127.0.0.1:2222:/root/)..."
scp -P 2222 "$OUTFILE" root@127.0.0.1:/root/
echo "Done!"
