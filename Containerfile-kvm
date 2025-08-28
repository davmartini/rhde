FROM registry.redhat.io/rhel9/rhel-bootc:latest

RUN dnf --enablerepo=rhacm-2.14-for-rhel-9-x86_64-rpms -y install flightctl-agent && \
    dnf -y clean all && \
    systemctl enable flightctl-agent.service && \
    systemctl mask bootc-fetch-apply-updates.timer

ADD config.yaml /etc/flightctl/