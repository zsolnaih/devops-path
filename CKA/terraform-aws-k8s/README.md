# 🚀 Kubernetes Cluster on AWS with Terraform (kubeadm-based)

This Terraform project provisions a fully functional Kubernetes cluster on AWS for CKA exam practice. The setup includes one control plane node and one or more worker nodes, all created via Terraform. Kubernetes is installed using kubeadm, triggered from EC2 user data on the control plane. Worker nodes require a manual `kubeadm join` command.

---

## ✨ Features

### 🌐 AWS Infrastructure

The Terraform script creates the following resources:

- **VPC** with configurable name and CIDR (default: `10.0.0.0/16`)
- **Public and private subnets**
- **Internet Gateway**
- **Routing tables** for public/private networking
- **Two Security Groups**  
  - Control plane  
  - Worker nodes  
- **IAM Instance Profile** with SSM access  
- **EC2 instances:**  
  - Control plane: `t3.small`  
  - Workers: `t3.micro` (configurable, min. 1)

---

## ⚙️ Kubernetes Setup

### 🔧 kubeadm Initialization

The control plane initializes Kubernetes using `kubeadm init`.

**Pod CIDR:**  
172.17.0.0/16
> ⚠️ This must not overlap with the VPC CIDR.


### 🔑 Retrieve the Join Command

After the control plane is ready, run the following to get the join command:
```bash
kubeadm token create --print-join-command
```
Run the printed command on each worker node.

### 🔄 kube-proxy NAT Update (AWS Requirement)
On AWS, masquerading must be enabled for pod traffic. Edit the kube-proxy DaemonSet:

```bash
kubectl edit ds kube-proxy -n kube-system
```

Add the following flag under the spec.template.spec.containers.command:
`- --masquerade-all=true`
Save and exit. The DaemonSet will roll out automatically.

---

## 🌐 Example Application (NGINX)
Inside the Terraform directory, the nginx/ folder contains a Kubernetes YAML manifest.

Apply it using:
```bash
kubectl create -f nginx.yaml
```
This creates:
- A `nginx-web` namespace
- A Deployment with 2 replicas
- A NodePort Service

The application is available at:
`http://<node-public-ip>:30007`

---

## 🔐 Security Group Rules
**🖥️ Control Plane Security Group**
*Egress*
| To                   | Port         | Protocol                          | Description                       |
| -------------------- | ------------ | --------------------------------- | --------------------------------- |
| 0.0.0.0              | 0            | TCP/UDP                           | All traffic                       |

*Ingress*
| From                 | Port         | Protocol                          | Description                       |
| -------------------- | ------------ | --------------------------------- | --------------------------------- |
| 0.0.0.0              | 6443         | TCP                               | Kubernetes API server             |
| worker nodes SG      | 443          | TCP                               | Cluster internal traffic          |
| worker nodes SG      | 179          | TCP                               | Calico networking                 |
| worker nodes SG      | 5473         | TCP                               | Calico Typha                      |
| worker nodes SG      | 7443         | TCP                               | Calico Flow                       |

**🧩 Worker Nodes Security Group**

*Egress*
| To                   | Port         | Protocol                          | Description                       |
| -------------------- | ------------ | --------------------------------- | --------------------------------- |
| 0.0.0.0              | 0            | TCP/UDP                           | All traffic                       |

*Ingress*
| From                 | Port         | Protocol                          | Description                       |
| -------------------- | ------------ | --------------------------------- | --------------------------------- |
| 0.0.0.0              | 30000–32767  | TCP                               | NodePorts                         |
| control plane SG     | 10250        | TCP                               | Kubelet                           |
| control plane SG     | 179          | TCP                               | Calico networking                 |
| control plane SG     | 5473         | TCP                               | Calico Typha                      |
| control plane SG     | 7443         | TCP                               | Calico Flow                       |


## 🧰 Terraform Variables
| Name                 | Type         | Default                           | Description                        |
| -------------------- | ------------ | --------------------------------- | ---------------------------------- |
| `aws_region`         | string       | `eu-central-1`                    | AWS region                         |
| `vpc_cidr`           | string       | `10.0.0.0/16`                     | VPC CIDR block                     |
| `public_subnets`     | list(string) | `["10.0.1.0/24","10.0.2.0/24"]`   | Public subnet CIDRs                |
| `private_subnets`    | list(string) | `["10.0.11.0/24","10.0.12.0/24"]` | Private subnet CIDRs               |
| `vpc_name`           | string       | `k8s_vpc`                         | VPC name                           |
| `node_count`         | number       | `2`                               | Number of worker nodes (minimum 1) |
