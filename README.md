# nsd-docker

This creates the `dnesting/nsd` Docker image for the 
[NSD](https://www.nlnetlabs.nl/projects/nsd/about/) DNS server.
The `:latest` tag should be automatically built from the latest release of NSD.

See [nsd.conf](nsd.conf) for the "default" configuration file used by this image.
You can apply your own configuration on top of this by mounting a volume to `/etc/nsd/` in the container
and placing any files matching `*.conf` in that directory.

The image runs as a non-root user on port 5333.
To run on port 53, the container must be privileged.

## Kubernetes

An example Kubernetes pod configuration is in [kubernetes/pod.yaml](kubernetes/pod.yaml).
It is configured using a supplied ConfigMap, but this just creates configuration files
in `/etc/nsd`.
This example enables nsd-control and uses it as a liveness probe.
It also enables Prometheus metrics on port 9153.

I've also included a [kubernetes/pod-privileged.yaml](kubernetes/pod-privileged.yaml)
to show how to run NSD on port 53.

