FROM alpine:3.11

RUN apk --update --no-cache add sudo curl unzip bash less ansible openssl ca-certificates openssl-dev gnupg openssh-client git git-crypt sshpass

## Kubernetes CLI
ARG KUBECTL_VERSION
ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

# HELM
ARG HELM_VERSION
RUN curl https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o /tmp/helm.tar.gz && \
    mkdir -p /tmp/helm && \
    tar -xvvf /tmp/helm.tar.gz -C /tmp/helm && \
    mv /tmp/helm/linux-amd64/helm /usr/local/bin && \
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/

RUN mkdir -p /etc/ansible
ADD ansible.cfg /etc/ansible/ansible.cfg

ENV TERM xterm-256color
ADD .bashrc /
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]