#!/bin/bash
set -euo pipefail

KEY_PATH="/root/.ssh/id_rsa"
MACHINES_FILE="machines.txt"
HOSTS_FILE="hosts"
SSH_OPTS="-o BatchMode=yes -o CheckHostIP=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

copy_ssh_key_if_needed() {
  local ip="$1"
  if ! ssh $SSH_OPTS -o ConnectTimeout=5 root@"$ip" true 2>/dev/null; then
    echo "Copying SSH key to $ip..."
    ssh-copy-id -o CheckHostIP=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "${KEY_PATH}.pub" "root@${ip}"
  else
    echo "SSH key already present on $ip"
  fi
}

configure_host() {
  local ip="$1" fqdn="$2" host="$3"
  ssh $SSH_OPTS root@"$ip" "sed -i 's/^127.0.1.1.*/127.0.1.1\t${fqdn} ${host}/' /etc/hosts"
  ssh $SSH_OPTS root@"$ip" "hostnamectl set-hostname ${fqdn}"
  ssh $SSH_OPTS root@"$ip" "systemctl restart systemd-hostnamed"
  scp $SSH_OPTS "$HOSTS_FILE" root@"$ip":~/
  ssh $SSH_OPTS root@"$ip" "cat ~/hosts >> /etc/hosts"
  echo -n "$host ($ip): "
  ssh $SSH_OPTS root@"$ip" hostname --fqdn
}

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

# 3. First pass: copy SSH key to all hosts
while read -r IP FQDN HOST SUBNET; do
  [ -z "$IP" ] && continue
  copy_ssh_key_if_needed "$IP"
done < "$MACHINES_FILE"
echo

# 4. Second pass: configure all hosts
while read -r IP FQDN HOST SUBNET; do
  [ -z "$IP" ] && continue
  echo "Processing $IP ($HOST)..."
  configure_host "$IP" "$FQDN" "$HOST"
done < "$MACHINES_FILE"

echo
cat "$HOSTS_FILE" >> /etc/hosts
echo "All done!"
