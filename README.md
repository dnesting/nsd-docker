# nsd-docker

![Docker Image Version (tag)](https://img.shields.io/docker/v/dnesting/nsd/latest)


This creates the [`dnesting/nsd`](https://hub.docker.com/r/dnesting/nsd) Docker image for the 
[NSD](https://www.nlnetlabs.nl/projects/nsd/about/) DNS server.
The `:latest` tag should be automatically built from the latest release of NSD.
The image is being built for `linux/amd64`, `linux/arm64`, and `linux/arm/v7` architectures.

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

## Cosign Verification

```
cosign verify \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity-regexp '^https://github.com/dnesting/nsd-docker/.*$' \
  dnesting/nsd:latest
```

## Support

This isn't associated with the NSD project and I don't plan to provide much support for it.
