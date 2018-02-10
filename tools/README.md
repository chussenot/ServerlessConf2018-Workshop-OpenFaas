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

### Generate a k8s token for you cluster

First you need name your cluster. If you will work on the same network with other
guys in this workshop, please choose different names.

`export CLUSTER_NAME=St0rm_cluster`

Now you can generate a token by running once this command,

`make generate_token`

And you will find a `cfg` folder with a `token.yml` file. We will use it later to
initialize the master k8s node and join it with worker nodes.

### Create your cluster

Ok, now your have to:

* Put each cards on your RasPis.
* Edit the [`ansible/hosts`](ansible/hosts) file for your CLUSTER_NAME
* Run the command `make create` with some options
  * CLUSTER_NAME

Resources, you may find useful
------------------------------

### Docker

* [Install Docker on Raspian](https://docs.docker.com/install/linux/docker-ce/debian/)
* [get.docker.com](https://get.docker.com/)
* [Memory issue](https://docs.docker.com/engine/admin/resource_constraints/#memory)
* [arm32v7 images](https://hub.docker.com/u/arm32v7/)
* [arm32v6 images](https://hub.docker.com/u/arm32v6/)
* [resin.io base image](https://hub.docker.com/r/resin/rpi-raspbian/)

### RasPis

* [How to flash an sd card for raspberry-pi](https://computers.tutsplus.com/articles/how-to-flash-an-sd-card-for-raspberry-pi--mac-53600)
* [5 things on docker-rpi by @alexellis](https://blog.alexellis.io/5-things-docker-rpi/)
* [enable cgroup memory](https://github.com/raspberrypi/linux/commit/ba742b52e5099b3ed964e78f227dc96460b5cdc0)
