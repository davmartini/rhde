# RHDE Lab with Edge Manager

## What you need 

* flightctl CLI to manage Edge Manager certificat and device enrolment
* bootc image (RHEL9 or 10) available on registry.redhat.io
* bootc-image-builder image to create a bootable bootc image (iso, raw, qcow2, etc...)

## Create your firts image

1. Install necessary packages :
```
sudo subscription-manager repos --enable rhacm-2.14-for-rhel-9-x86_64-rpms
sudo dnf install -y container-tools virt-install flightctl
```

2. Login to your RHACM cluster
```
flightctl login --username=admin01 --password=<password> https://api.apps.ocp.drkspace.fr --insecure-skip-tls-verify
``` 

3. Request a new certificat
```
flightctl certificate request --signer=enrollment --expiration=365d --output=embedded > config.yaml
```


4. Login to Red Hat Registry
```
podman login registry.redhat.io
```

5. Create a sample Containerfile
```
FROM registry.redhat.io/rhel9/rhel-bootc:latest

RUN dnf --enablerepo=rhacm-2.14-for-rhel-9-x86_64-rpms -y install flightctl-agent && \
    dnf -y clean all && \
    systemctl enable flightctl-agent.service && \
    systemctl mask bootc-fetch-apply-updates.timer

ADD config.yaml /etc/flightctl/
```

4. Build your image
```
podman build -t quay.io/david_martini/rhde9:0.1 .
```

5. Generate new signature with sigstor
```
skopeo generate-sigstore-key --output-prefix signingkey
```

6. Configure podman to uplaod signature on registry
```
sudo tee "/etc/containers/registries.d/quay.io.yaml" > /dev/null <<EOF
docker:
    quay.io:
        use-sigstore-attachments: true
EOF
``` 

7. Login to quay
```
podman login quay.io
```

8. Push your image on your regitry
```
podman push \
    --sign-by-sigstore-private-key ./signingkey.private \
    quay.io/david_martini/rhde9:0.1
```

9. Create a output directory
```
mkdir -p output
```

10. Create an ISO image with Bootc Image Builder
```
podman run --rm -it --privileged --pull=newer \
    --security-opt label=type:unconfined_t \
    -v "${PWD}/output":/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    registry.redhat.io/rhel9/bootc-image-builder:latest \
    --type iso \
    quay.io/david_martini/rhde9:0.1
```

