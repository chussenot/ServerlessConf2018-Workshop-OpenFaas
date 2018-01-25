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

Insert your sdcard and run `make flash`
