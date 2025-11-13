#!/bin/bash
# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sysctl --system

yum install -y containerd


cat <<EOF | sudo tee /etc/systemd/system/containerd.service
[Unit]
Description=containerd
Documentation=https://containerd.io
[Service]
ExecStart=/usr/bin/containerd
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl enable containerd
systemctl start containerd


yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet


kubeadm init --apiserver-advertise-address $(hostname -I) --apiserver-cert-extra-sans controlplane --pod-network-cidr 172.17.0.0/16

# default .kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/operator-crds.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/tigera-operator.yaml

sudo curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/custom-resources.yaml
sudo sed -E -i 's/cidr: [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/[0-9]+/cidr: 172.17.0.0\/16/' custom-resources.yaml

kubectl create -f custom-resources.yaml

# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml