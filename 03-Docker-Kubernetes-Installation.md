# Chapter 3 - Install Docker & Kubernetes


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
$ sudo swapon --summary
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
  
  
## Add repo lists & install kubeadm

```
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -q && \
  sudo apt-get install -qy kubeadm
```
  
  
-> Go to [Next Chapter](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/04-OpenFaas-Installation.md)
