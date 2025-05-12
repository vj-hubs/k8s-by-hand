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

- [Install Multipass](https://multipass.run/) if you don't have it already.
- You can SSH into a VM with: `multipass shell <vm-name>`
- For advanced provisioning, see the multipass documentation or add cloud-init configs as needed.

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

## Reference

For more details on Lima YAML configuration, see the official [Lima default.yaml template](https://github.com/lima-vm/lima/blob/master/templates/default.yaml)

For Multipass, see the [Multipass documentation](https://multipass.run/docs/command-reference)

---

For the original prerequisites and setup instructions, see the [Kubernetes the Hard Way Prerequisites](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-prerequisites.md).
