Chapter 2 - Setup the network
=============================

Configure the IP address
------------------------

5 - Check you IP address

In order to connect to your Raspberry Pi from your computer using SSH (or VNC),
you need to know the Pi's IP address.
The easiest way is when you have a display connected:

```
hostname -l
```

Export the name of your favorite EDITOR

```
export EDITOR=vim # vim, nano, vi, etc.
```

Then,

```
sudo $EDITOR /etc/network/interfaces
```

Customize your with the configuration below,

* SSID
* PASSWORD
* STATIC_ADDRESS
* NETMASK
* GATEWAY

```
# allow-hotplug wlan0 # Allow RPi with Wifi Dongle
iface wlan0 inet static
address 192.168.1.100
netmask 255.255.255.0
gateway 192.168.1.1
wpa-ssid "SSID"
wpa-psk "PASSWORD"

ifdown wlan0
ifup wlan0
```

The usual way to get the system to re-read the file and use the changes is to do

```
sudo ifdown wlan0 && sudo ifup wlan0
```

Without any display,

6 - Change the hostname
Use the _raspi-config_ utility to change the hostname to `k8s-master-001`
or similar and then reboot.

7 - Set a static IP address
It's not fun when your cluster breaks because the IP of your master changed.
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

/!\ You should increment static IPs
100 for 101, 102, 103 etc.

You may also need to make a reservation on your router's DHCP table so these addresses don't get given out to other devices on your network.


-> Go to [Next Chapter](./03-Docker-Kubernetes-Installation.md)
