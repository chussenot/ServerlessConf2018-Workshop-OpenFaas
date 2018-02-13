# Chapter 4 - Install OpenFaas

We will deploy OpenFaaS and get full metrics made available through Prometheus.

You can watch Alex’ OpenFaaS introduction and demos from Cloud Native London
meetup in HD on Vimeo: FaaS and Furious - 0 to Serverless in 60 seconds, anywhere.

25 – Clone the GitHub repository and use `kubectl` to deploy

```
git clone https://github.com/openfaas/faas-netes && \
cd faas-netes
kubectl apply -f ./namespaces.yml && \
kubectl apply -f ./yaml_armhf
```

The Kubernetes controller for OpenFaaS is called faas-netes.

26 – Test OpenFaaS

Now get the IP address of your master node in the cluster (i.e. 192.168.0.100)
and open up the FaaS UI in a web-browser:

http://192.168.0.100:31112/

27 - Try the OpenFaaS CLI

You can get the CLI for OpenFaaS by typing in:

`curl -SL https://cli.openfaas.com/ | sudo sh`

armv7l
Getting package https://github.com/alexellis/faas-cli/releases/download/0.4.14/faas-cli-armhf
Attemping to move faas-cli to /usr/local/bin
New version of faas-cli installed to /usr/local/bin
We build the CLI for Windows, Linux, Linux ARM and MacOS.

You can get help from the CLI at any time or check its version with:

```
faas-cli --help
```

Patch your function templates for ARM
Clone the CLI samples and patch the templates for ARM:

```
git clone https://github.com/alexellis/faas-cli && cd faas-cli
```

```
cp template/node-armhf/Dockerfile template/node/ && \
cp template/python-armhf/Dockerfile template/python/ && \
cp template/go-armhf/Dockerfile template/go/
```

Now you can go ahead and create your first function in Python:

```
faas-cli new --lang python http-ping
```

This will create an empty hello-world style function. Let's check it out.
You'll see that the CLI created three files:

* `http-ping.yml`
* `http-ping/handler.py`
* `http-ping/requirements.txt`

Edit `http-ping.yml` and replace `image: http-ping` with your Docker Hub account like: `image: alexellis2/http-ping`.
Since we are on Kubernetes we also need to edit the gateway port from gateway: http://localhost:8080 to gateway: http://localhost:31112.
Now let's build, deploy and invoke the function:
$ faas-cli build -f http-ping.yml
The first time you run this we'll download some Docker images, but for each subsequent build it will use a cache.
If your Docker engine is running in experimental mode you can also "squash" the layers for a smaller final image with faas-cli build --squash.
$ faas-cli push -f http-ping.yml
We are pushing to the Docker Hub, but if you have a local registry that may be faster.
Important note: some Linux distros have IPv6 configuration in the /etc/hosts file that causes deploying to a gateway at "localhost" to hang. The fix is to edit your YAML file or to pass the flag --gateway http://127.0.0.1:31112.
$ faas-cli deploy -f http-ping.yml
Deploying: http-ping.
Deployed.
202 Accepted
URL: http://localhost:31112/function/http-ping

Or if localhost is hanging due to the IPv6 alias:
$ faas-cli deploy -f http-ping.yml --gateway http://127.0.0.1:31112
The function will be downloaded by Kubernetes and deployed on one of your nodes (Raspberry Pis).
This could take a couple of minutes the first time since the Raspberry Pi's network and I/O interfaces are slower than regular PCs.
Now you can invoke the function via the UI or the CLI.
Invoke the function:
Here we can pipe in any output from another CLI command:
$ echo -n "Hi Kubernetes!" | faas-cli invoke http-ping -f http-ping.yml
Hi Kubernetes!
Or type in freestyle:
$ faas-cli invoke http-ping -f http-ping.yml
Reading from STDIN - hit (Control + D) to stop.
I'm writing the tutorial now

I'm writing the tutorial now
List the functions and the invocation count:
$ faas-cli list -f http-ping.yml
Function                        Invocations     Replicas   
http-ping                       2               1
We see the replica count is set to 1 meaning there is only one container mapped to this function (more are added by OpenFaaS if we start to generate high load).
The invocation count is now 2 which is updated live from Prometheus metrics

## More can be Done!

* [Configure Prometheus](https://blog.alexellis.io/prometheus-nodeexporter-rpi/)
* [Sample functions](https://github.com/openfaas/faas/tree/master/sample-functions)
