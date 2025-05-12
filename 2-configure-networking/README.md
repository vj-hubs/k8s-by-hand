# Networking Configuration Scripts

| Step              | Original Guide                                                                                                                                | Purpose                                                      |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| Compute Resources | [Kubernetes the Hard Way - Compute Resources](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md) | Automate networking and host configuration for the required VMs. |

## 1. generate-machines.sh
Generates the `machines.txt` file with the required VM information.

**Usage:**
```sh
chmod +x generate-machines.sh
./generate-machines.sh
```

---

## 2. configure-hosts.sh
Sets up SSH keys, hostnames, and hosts files across all VMs as described in `machines.txt`.

**Usage:**
```sh
chmod +x configure-hosts.sh
sudo ./configure-hosts.sh
```

---

Make sure both scripts are run from the `2-configure-networking` directory and that you have the necessary permissions. 