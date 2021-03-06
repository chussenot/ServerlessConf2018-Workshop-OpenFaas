Chapter 3 - Install Docker & Kubernetes
=======================================

In this chapter, we are following an **updated** version of the steps described
by Alex Ellis in the [k8s-pi](https://gist.github.com/alexellis/fdbc90de7691a1b9edb545c17da2d975#file-k8s-pi-md).

Follow these steps to configure your master and worker nodes.

First update your packages list `/etc/apt/sources.list`

```
sudo apt update
```

Install Docker
-------------

8 - This installs 17.09.
```
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    docker-ce=17.09.0~ce-0~raspbian
sudo usermod pi -aG docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
```

### Run ARM version of docker hello-world


```
docker run armhf/hello-world

  Unable to find image 'armhf/hello-world:latest' locally
  latest: Pulling from armhf/hello-world
  a0691bf12e4e: Pull complete
  Digest: sha256:9701edc932223a66e49dd6c894a11db8c2cf4eccd1414f1ec105a623bf16b426
  Status: Downloaded newer image for armhf/hello-world:latest

  Hello from Docker on armhf!
  This message shows that your installation appears to be working correctly.

  To generate this message, Docker took the following steps:
  1. The Docker client contacted the Docker daemon.
  2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
  3. The Docker daemon created a new container from that image which runs the
  executable that produces the output you are currently reading.
  4. The Docker daemon streamed that output to the Docker client, which sent it
  to your terminal.

  To try something more ambitious, you can run an Ubuntu container with:
  $ docker run -it ubuntu bash

  Share images, automate workflows, and more with a free Docker Hub account:
  https://hub.docker.com

  For more examples and ideas, visit:
  https://docs.docker.com/engine/userguide/
```

## Disable Swap space to avoid errors in Kubernetes

* [What is swap space?](https://en.wikipedia.org/wiki/Paging#LINUX)
* [About k8s swap support #53533](https://github.com/kubernetes/kubernetes/issues/53533)
* [About k8s swap support #7294](https://github.com/kubernetes/kubernetes/issues/7294)

9 - Turn off swap:
```
sudo dphys-swapfile swapoff && \
sudo dphys-swapfile uninstall && \
sudo update-rc.d dphys-swapfile remove
```

This should now show no entries:
```
sudo swapon --summary
```

10 - Change cmdline.txt
```
sudo nano /boot/cmdline.txt
```
Add this text at the end of the line, but don't create any new lines:
```
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```

11 - Now reboot - **Do not skip this step**

## Install Kubernetes

[Official Documentation](https://kubernetes.io/docs/setup/independent/install-kubeadm/)

12 - Add repo lists & install kubeadm

You should do this on your master nodes and your worker nodes.

```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && \
sudo apt-get install -qy kubeadm
```

## Initialize your master node

13 - Generate a token

When you initialize your master node, `kubeadm` will generate a token for you.

```
sudo kubeadm init --token-ttl=0
```

But you can generate your own token with python:

```
python -c 'import random; print "%0x.%0x" % (random.SystemRandom().getrandbits(3*8), random.SystemRandom().getrandbits(8*8))'
```

And pass it in the initialization phase.

```
sudo kubeadm init --token-ttl=0 --token=3dae91.10b0b725926802ee
```

Other possible parameters:

* `--discovery-token-unsafe-skip-ca-verification` to skip CA verfication.
* `--ignore-preflight-errors` to bypass prefligth errors.

We pass in `--token-ttl=0` so that the token never expires - do not use this
setting in production.


> Optionally also pass `--apiserver-advertise-address=192.168.0.27` with the IP of the Pi.

_Note: This step will take a long time, even up to 15 minutes._

You can generate more tokens with the `kubeadm` [token commands](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-token/#cmd-token-generate)

After the `init` is complete run the snippet given to you on the command-line:

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

This step takes the key generated for cluster administration and makes it
available in a default location for use with `kubectl`.

14 - Save your join-token

Your join token is valid for 24 hours, so save it into a text file. Here's an example:
![image](./images/03-001.png)

A tool like [ctop](https://github.com/bcicen/ctop) can be useful in the next parts.
```
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7/ctop-0.7-linux-arm -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
```

15 - Setup networking
Install Weave network driver

```
kubectl apply -f https://git.io/weave-kube-1.6
```
If you run into an issue use this script instead:

```
kubectl apply -f \
 "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

## Test

16 - Check everything worked

```
kubectl get pods --namespace=kube-system

NAME                             READY     STATUS    RESTARTS   AGE
etcd-c1-000                      1/1       Running   0          57m
kube-apiserver-c1-000            1/1       Running   0          57m
kube-controller-manager-c1-000   1/1       Running   0          56m
kube-dns-7b6ff86f69-br82b        0/3       Pending   0          57m
kube-proxy-nnqdj                 1/1       Running   0          57m
kube-scheduler-c1-000            1/1       Running   0          56m
weave-net-fblhq                  2/2       Running   0          55s
```

## Configure the worker nodes

Repeat all steps to install docker & kubernetes and...

17 - Join the cluster
Replace the token / IP for the output you got from the master node:

```
sudo kubeadm join --token 1fd0d8.67e7083ed7ec08f3 192.168.0.27:6443
```

You can now run this on the master:

```
kubectl get nodes
```

![image](./images/03-003.jpg)

## Deploy a container

18 - *function.yml*

```
apiVersion: v1
kind: Service
metadata:
  name: markdownrender
  labels:
    app: markdownrender
spec:
  type: NodePort
  ports:
    - port: 8080
      protocol: TCP
      targetPort: 8080
      nodePort: 31118
  selector:
    app: markdownrender
---
apiVersion: apps/v1beta1 # for versions before 1.6.0 use extensions/v1beta1
kind: Deployment
metadata:
  name: markdownrender
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: markdownrender
    spec:
      containers:
      - name: markdownrender
        image: functions/markdownrender:latest-armhf
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
          protocol: TCP
```

19 - Deploy and test:
```
kubectl create -f function.yml
curl -4 http://localhost:31118 -d "# test"
<p><h1>test</h1></p>
```
From a remote machine such as your laptop use the IP address of your Kubernetes
master and try the same again.

## Start up the dashboard

The dashboard can be useful for visualising the state and health of your system
but it does require the equivalent of "root" in the cluster.
If you want to proceed you should first run
in a [ClusterRole from the docs](https://github.com/kubernetes/dashboard/wiki/Access-control#admin-privileges).

```
echo -n 'apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system' | kubectl apply -f -
```

This is the development/alternative dashboard which has TLS disabled
and is easier to use.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard-arm.yaml
```

You can then find the IP and port via `kubectl get svc -n kube-system`.
To access this from your laptop you will need to use `kubectl proxy`
and navigate to `http://localhost:8001/` on the master,
or tunnel to this address with `ssh`.

`ssh -L 8001:localhost:8001 -N pi@master-001`

[More about dashboard access control](https://github.com/kubernetes/dashboard/wiki/Access-control)

## Remove the test deployment

Now on the Kubernetes master remove the test deployment:

```
kubectl delete -f function.yml
```

-> Go to [Next Chapter](./04-OpenFaas-Installation.md)
