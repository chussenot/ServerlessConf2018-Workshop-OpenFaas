#Chapter 2 - Setup the network


## IP address

5 - Check you IP address
In order to connect to your Raspberry Pi from your computer using SSH (or VNC), you need to know the Pi's IP address.  
The easiest way is when you have a display connected:  
...
hostname -l
...

Without any display,

6 - Change the hostname
Use the `raspi-config` utility to change the hostname to k8s-master-1 or similar and then reboot.

7 - Set a static IP address

It's not fun when your cluste breaks because the IP of your master changed. Let's fix that problem ahead of time:
```
cat >> /etc/dhcpcd.conf
```

Paste this block:
```
profile static_eth0
static ip_address=192.168.0.100/24
static routers=192.168.0.1
static domain_name_servers=8.8.8.8
```

Hit Control + D.
Change 100 for 101, 102, 103 etc.

You may also need to make a reservation on your router's DHCP table so these addresses don't get given out to other devices on your network.


## Install Docker

8 - This installs 17.12 or newer.
```
$ curl -sSL get.docker.com | sh && \
sudo usermod pi -aG docker
```

## Disable Swap

For Kubernetes 1.7 and newer you will get an error if swap space is enabled.

9 - Turn off swap:
```
$ sudo dphys-swapfile swapoff && \
  sudo dphys-swapfile uninstall && \
  sudo update-rc.d dphys-swapfile remove
```

This should now show no entries:
```
$ sudo swapon --summary
```

10 - Edit `/boot/cmdline.txt`
Add this text at the end of the line, but don't create any new lines:
```
cgroup_enable=cpuset cgroup_enable=memory
```
> Some people in the comments suggest `cgroup_memory=memory` should now be: `cgroup_memory=1`.

11 - Now reboot - **do not skip this step**


##Add repo lists & install kubeadm
```
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -q && \
  sudo apt-get install -qy kubeadm
```
