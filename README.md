ServerlessConf Workshop OpenFaas
================================

Learn how to build a Kubernetes Cluster with Raspberry Pis as servers and how to
run OpenFaas though some practical use cases.

Install dependencies
------------

* make
* ansible

How to
------

Fist, you can run `make help` to see all commands.

* wpa_supplicant.conf

This is a sample to use when flashing donkey micro sdcard to gain access to
your favorite wifi hotspot.

### Bootstrap sdcard

 * add your ssh public key in `authorized_keys` file
 * to configure wifi, add `.env` file with content:

```bash
WIFI_PRIMARY_SSID="ssid"
WIFI_PRIMARY_PASSWORD="password"

WIFI_SECONDARY_SSID="ssid"
WIFI_SECONDARY_PASSWORD="password"
```

* Insert your sdcard
* Create your [partitions](https://elinux.org/RPi_Easy_SD_Card_Setup)
* Run `make flash`
* List your partitions with tool like `gparted`and find your boot and root
partitions
* Run `make init`, to configure SSH access and Wifi.

Resources
---------

* [How to flash an sd card for raspberry-pi](https://computers.tutsplus.com/articles/how-to-flash-an-sd-card-for-raspberry-pi--mac-53600)
