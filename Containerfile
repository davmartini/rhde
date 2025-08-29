FROM registry.redhat.io/rhel9/rhel-bootc:latest

RUN dnf --enablerepo=rhacm-2.14-for-rhel-9-x86_64-rpms -y install flightctl-agent openssh-server && \
    dnf -y clean all && \
    systemctl enable flightctl-agent.service && \
    systemctl mask bootc-fetch-apply-updates.timer

RUN useradd rhde

ADD authorized_keys /var/home/rhde/authorized_keys

ADD config.yaml /etc/flightctl/