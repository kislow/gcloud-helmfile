FROM google/cloud-sdk:246.0.0-alpine

RUN apk add --no-cache ca-certificates git bash curl
RUN gcloud components install beta kubectl

RUN curl --silent --fail --location https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz | tar zx && \
    mv /linux-amd64/helm /usr/local/bin/
RUN helm init --client-only && \
    helm plugin install https://github.com/databus23/helm-diff

RUN curl --silent --fail --location --output /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.64.1/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
