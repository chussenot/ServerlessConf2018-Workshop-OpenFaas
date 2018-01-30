#Chapter 1 - Install the Raspberry Pis

## Setup the Raspberry Pi

1 - Download [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/)

![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/01-001.jpg)

2 - Burn Raspbian to a micro SD Card
_As preconized on the Raspberrypi.org website, I use [Etcher](https://etcher.io/) but you can choose the dd command (Linux/Mac) or Win32DiskImager (Windows) if you prefer._

![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/01-002.jpg)
![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/01-003.jpg)
![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/01-004.jpg)

3 - Enable SSH
Without any display, you can easily enable the SSH by adding a file named **ssh** without any extension, onto the boot partition of the micro SD Card.


## Setup the network

4 - Download and install [Putty](https://www.putty.org/).

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



