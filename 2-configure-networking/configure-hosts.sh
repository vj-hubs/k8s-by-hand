#!/bin/bash
set -euo pipefail

KEY_PATH="/root/.ssh/id_rsa"
MACHINES_FILE="machines.txt"
HOSTS_FILE="hosts"

# 1. Generate hosts file from machines.txt
echo "# Kubernetes The Hard Way" > "$HOSTS_FILE"
while read -r IP FQDN HOST SUBNET; do
  [ -z "$IP" ] && continue
  echo "$IP $FQDN $HOST" >> "$HOSTS_FILE"
done < "$MACHINES_FILE"
echo "Generated $HOSTS_FILE:"
cat "$HOSTS_FILE"

echo
# 2. Generate SSH key if not present
if [ ! -f "$KEY_PATH" ]; then
  echo "Generating SSH key at $KEY_PATH"
  ssh-keygen -t rsa -b 4096 -N "" -f "$KEY_PATH"
else
  echo "SSH key already exists at $KEY_PATH"
fi

echo
# 3-7. All actions per host in one loop
while read -r IP FQDN HOST SUBNET; do
  [ -z "$IP" ] && continue
  echo "Processing $IP ($HOST)..."

  # Copy SSH key
  ssh-copy-id -i "${KEY_PATH}.pub" "root@${IP}"

  # Set hostname and update /etc/hosts
  ssh -o BatchMode=yes root@"$IP" "sed -i 's/^127.0.1.1.*/127.0.1.1\t${FQDN} ${HOST}/' /etc/hosts"
  ssh -o BatchMode=yes root@"$IP" "hostnamectl set-hostname ${FQDN}"
  ssh -o BatchMode=yes root@"$IP" "systemctl restart systemd-hostnamed"

  # Copy hosts file and append
  scp "$HOSTS_FILE" root@"$IP":~/
  ssh -o BatchMode=yes root@"$IP" "cat ~/hosts >> /etc/hosts"

  # Verify SSH and FQDN
  echo -n "$HOST ($IP): "
  ssh -o BatchMode=yes root@"$IP" hostname --fqdn

done < "$MACHINES_FILE"

# Update jumpbox /etc/hosts (do this once, not per host)
cat "$HOSTS_FILE" >> /etc/hosts

echo "All done!" 