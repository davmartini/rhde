# RHDE Lab

## Create your firts image

1. Install necessary packages :
```
sudo dnf install -y container-tools virt-install
```

2. Login to Red hat Quay & Red Hat Registry
```
podman login quay.io
podman login registry.redhat.io
```

3. Install the bootc-image-builder:
```
sudo podman pull registry.redhat.io/rhel10/bootc-image-builder
```

3. Create a sample Containerfile
```
FROM registry.redhat.io/rhel10/rhel-bootc:latest
RUN dnf -y install cloud-init && \
    ln -s ../cloud-init.target /usr/lib/systemd/system/default.target.wants && \
    dnf clean all
```

4. Build your image
```
podman build -t localhost/rhde:10 .
```

5. Tag and push your new image on your registry
```
podman tag localhost/rhde:10 quay.io/david_martini/rhde10:0.1
podman push quay.io/david_martini/rhde10:0.1
```

6. Create an ISO image with Bootc Image Builder
```
sudo podman run --rm -it --privileged --pull=newer --security-opt label=type:unconfined_t -v /var/lib/containers/storage:/var/lib/containers/storage -v $(pwd)/config.toml:/config.toml     -v $(pwd)/output:/output registry.redhat.io/rhel10/bootc-image-builder:latest --type iso --config /config.toml localhost/test
```

