# Chapter 3 - Install Docker & Kubernetes

In this chapter, we are following the steps described by Alex Ellis in the
[k8s-pi](https://gist.github.com/alexellis/fdbc90de7691a1b9edb545c17da2d975#file-k8s-pi-md).

## Install Docker

8 - This installs 17.12 or newer.
```
curl -sSL get.docker.com | sh && \
sudo usermod pi -aG docker
```

## Disable Swap to avoid errors in Kubernetes

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
cgroup_enable=cpuset cgroup_enable=memory
```

11 - Now reboot - **do not skip this step**

## Install Kubernetes

12 - Add repo lists & install kubeadm

```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && \
sudo apt-get install -qy kubeadm
```

## Initialize your master node

13 - Generate a token
```
sudo kubeadm init --token-ttl=0
```

We pass in `--token-ttl=0` so that the token never expires - do not use this
setting in production. The UX for `kubeadm` means it's currently very hard
to get a join token later on after the initial token has expired.

> Optionally also pass `--apiserver-advertise-address=192.168.0.27` with the IP of the Pi.

_Note: This step will take a long time, even up to 15 minutes._

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
![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/03-001.jpg)

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
```

![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/03-002.jpg)

## Configure worker Nodes

17 - Join the cluster
Replace the token / IP for the output you got from the master node:

```
sudo kubeadm join --token 1fd0d8.67e7083ed7ec08f3 192.168.0.27:6443
```

You can now run this on the master:

```
kubectl get nodes
```

![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/03-003.jpg)

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

## Remove the test deployment

Now on the Kubernetes master remove the test deployment:

```
kubectl delete -f function.yml
```

-> Go to [Next Chapter](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/04-OpenFaas-Installation.md)
