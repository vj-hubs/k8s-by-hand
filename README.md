## k8s-by-hand

#### ℹ️ This is a learning and implementation guide for [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) using open source virtualization tools (Lima or Multipass)
---

| Project         | Original Guide                                                                                                                | Purpose                                                                 |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| k8s-by-hand     | [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)                                         | Hands-on with scripts  |
---

### 🚀 Steps

1. [Setting up the VMs](1-setting-up-the-VMs/README.md)
2. [Configure Networking](2-configure-networking/README.md)

---

### 📁 Project Structure

```text
k8s-by-hand/
├── 1-setting-up-the-VMs/
│   ├── README.md
│   ├── start-all-vms.sh
│   ├── node-0.yaml
│   ├── node-1.yaml
│   ├── server.yaml
│   └── jumpbox.yaml
├── 2-configure-networking/
│   ├── README.md
│   ├── configure-hosts.sh
│   └── generate-machines.sh
└── README.md
```
