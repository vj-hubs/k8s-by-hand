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
# 3. Explicitly process each host from machines.txt - Read first line (server)
read -r IP1 FQDN1 HOST1 SUBNET1 < <(grep -v '^$' "$MACHINES_FILE" | sed -n '1p')
if [ -n "$IP1" ]; then
  echo "Processing $IP1 ($HOST1)..."
  copy_ssh_key_if_needed "$IP1"
  ssh $SSH_OPTS root@"$IP1" "sed -i 's/^127.0.1.1.*/127.0.1.1\t${FQDN1} ${HOST1}/' /etc/hosts"
  ssh $SSH_OPTS root@"$IP1" "hostnamectl set-hostname ${FQDN1}"
  ssh $SSH_OPTS root@"$IP1" "systemctl restart systemd-hostnamed"
  scp $SSH_OPTS "$HOSTS_FILE" root@"$IP1":~/
  ssh $SSH_OPTS root@"$IP1" "cat ~/hosts >> /etc/hosts"
  echo -n "$HOST1 ($IP1): "
  ssh $SSH_OPTS root@"$IP1" hostname --fqdn
fi

# Read second line (node-0)
read -r IP2 FQDN2 HOST2 SUBNET2 < <(grep -v '^$' "$MACHINES_FILE" | sed -n '2p')
if [ -n "$IP2" ]; then
  echo "Processing $IP2 ($HOST2)..."
  copy_ssh_key_if_needed "$IP2"
  ssh $SSH_OPTS root@"$IP2" "sed -i 's/^127.0.1.1.*/127.0.1.1\t${FQDN2} ${HOST2}/' /etc/hosts"
  ssh $SSH_OPTS root@"$IP2" "hostnamectl set-hostname ${FQDN2}"
  ssh $SSH_OPTS root@"$IP2" "systemctl restart systemd-hostnamed"
  scp $SSH_OPTS "$HOSTS_FILE" root@"$IP2":~/
  ssh $SSH_OPTS root@"$IP2" "cat ~/hosts >> /etc/hosts"
  echo -n "$HOST2 ($IP2): "
  ssh $SSH_OPTS root@"$IP2" hostname --fqdn
fi

# Read third line (node-1)
read -r IP3 FQDN3 HOST3 SUBNET3 < <(grep -v '^$' "$MACHINES_FILE" | sed -n '3p')
if [ -n "$IP3" ]; then
  echo "Processing $IP3 ($HOST3)..."
  copy_ssh_key_if_needed "$IP3"
  ssh $SSH_OPTS root@"$IP3" "sed -i 's/^127.0.1.1.*/127.0.1.1\t${FQDN3} ${HOST3}/' /etc/hosts"
  ssh $SSH_OPTS root@"$IP3" "hostnamectl set-hostname ${FQDN3}"
  ssh $SSH_OPTS root@"$IP3" "systemctl restart systemd-hostnamed"
  scp $SSH_OPTS "$HOSTS_FILE" root@"$IP3":~/
  ssh $SSH_OPTS root@"$IP3" "cat ~/hosts >> /etc/hosts"
  echo -n "$HOST3 ($IP3): "
  ssh $SSH_OPTS root@"$IP3" hostname --fqdn
fi

cat "$HOSTS_FILE" >> /etc/hosts
echo "All done!"
