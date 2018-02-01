# Chapter 2 - Setup the network


## Configure the IP address

5 - Check you IP address
In order to connect to your Raspberry Pi from your computer using SSH (or VNC),
you need to know the Pi's IP address.
The easiest way is when you have a display connected:
```
hostname -l
```

Without any display,

6 - Change the hostname
Use the _raspi-config_ utility to change the hostname to k8s-master-1
or similar and then reboot.

7 - Set a static IP address
It's not fun when your cluste breaks because the IP of your master changed.
Let's fix that problem ahead of time:

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


-> Go to [Next Chapter](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/03-Docker-Kubernetes-Installation.md)
