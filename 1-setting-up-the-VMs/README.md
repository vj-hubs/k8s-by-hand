# VM Startup Script

| Step                | Original Guide                                                                                                                        | Purpose                                                      |
|---------------------|-------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| Prerequisites Setup | [Kubernetes the Hard Way - Prerequisites](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-prerequisites.md) | Automate VM provisioning for the tutorial prerequisites step. |

To start all VMs defined in this directory using Lima:

```bash
chmod +x lima-vms.sh && ./lima-vms.sh
```

## Alternative: Using Multipass

If you are on Windows, or prefer Multipass, you can use the following script to launch the VMs:

```bash
chmod +x multipass-vms.sh && ./multipass-vms.sh
```

## Accessing the Lima VMs

Once the VMs are set up and running, you can SSH into each VM using the following commands:
**The password for all VMs is `root`**
```bash
# Jumpbox
ssh -p 2222 root@127.0.0.1

# Server
ssh -p 2223 root@127.0.0.1

# Node 0
ssh -p 2224 root@127.0.0.1

# Node 1
ssh -p 2225 root@127.0.0.1
```

## Accessing the Multipass VMs

Once the Multipass VMs are set up and running, you can get the IP address of each VM and SSH into them as follows:

1. List all running VMs and their IP addresses:

```bash
multipass list --format yaml
```

2. Or, get the IP address of a specific VM (e.g., jumpbox):

```bash
multipass exec jumpbox -- hostname -I
```

3. SSH into a VM (replace <vm-ip> with the actual IP address from above):

**The password for all VMs is `root`**
```bash
ssh root@<vm-ip>
```

(Use the IP address you obtained from the previous step.)

## Reference

For more details on Lima YAML configuration, see the official [Lima default.yaml template](https://github.com/lima-vm/lima/blob/master/templates/default.yaml)

For Multipass, see the [Multipass documentation](https://multipass.run/docs/command-reference)
