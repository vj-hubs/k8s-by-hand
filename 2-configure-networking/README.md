# Networking Configuration Scripts

| Step              | Original Guide                                                                                                                                | Purpose                                                      |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| Compute Resources | [Kubernetes the Hard Way - Compute Resources](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md) | Automate networking and host configuration for the required VMs. |

## 1. generate-machines.sh
Generates the `machines.txt` file with the required VM information.

**Usage:**
```sh
chmod +x generate-machines.sh
# Default: Lima
./generate-machines.sh
# For Multipass:
./generate-machines.sh --provider multipass
```

---

## 2. configure-hosts.sh
Sets up SSH keys, hostnames, and hosts files across all VMs as described in `machines.txt`.

### Transferring and Running `configure-hosts.sh` on the Jumpbox

1. **Copy the script and SSH into the jumpbox:**

   For Lima (default port-forwarded SSH):
   ```sh
   scp -P 2222 configure-hosts.sh root@127.0.0.1:/root/
   ssh -p 2222 root@127.0.0.1
   ```

   For Multipass:
   ```sh
   jumpbox_ip=$(multipass exec jumpbox -- hostname -I | awk '{print $1}')
   scp configure-hosts.sh root@$jumpbox_ip:/root/
   ssh root@$jumpbox_ip
   ```

2. **On the jumpbox, run:**
   ```sh
   chmod +x configure-hosts.sh
   sudo ./configure-hosts.sh
   ```
