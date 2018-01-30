# Chapter 1 - Install the Raspberry Pis


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

With a display
```
sudo raspi-config
```
Interfacing Options \ P2 SSH  
![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/01-005.jpg)
![image](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/images/01-006.jpg)

4 - Download and install [Putty](https://www.putty.org/)

5 - Configure the WiFi  
_on RPi2 with Dongle_  
```
sudo nano /etc/network/interfaces
```
Add SSID name and passwork psk
```
allow-hotplug wlan0
iface wlan0 inet static
address 192.168.0.150
netmask 255.255.255.0
gateway 192.168.0.1
wpa-ssid "SSID NAME"
wpa-psk "WIFI PASSWORD"

ifdown wlan0
ifup wlan0
```
Reboot the RPi then check the IP address  
```
ifconfig
```

_on RPi3_
```
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```
Add at the end of the file  
```
network={
  ssid="SSID NAME"
  psk="WIFI PASSWORD"
  key_mgmt=WPA-PSK
}
```
Reboot the RPi then check the IP address  
```
ifconfig wlan0
```


-> Go to [Next Chapter](https://github.com/estelle-a/ServerlessConf2018-Workshop-OpenFaas/blob/master/02-Setup-network.md)
