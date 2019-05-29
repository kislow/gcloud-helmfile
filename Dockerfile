FROM google/cloud-sdk:246.0.0

# Install 0install
RUN apt-get update && apt-get install -y --no-install-recommends 0install-core

# Drop root rights
RUN useradd -m user
USER user
WORKDIR /home/user
ENV PATH="/home/user/bin:${PATH}"

# Install helm and helm-autoversion
RUN 0install add helm http://assets.axoom.cloud/tools/helm-autoversion.xml
RUN 0install run --version 2.14.0 http://repo.roscidus.com/kubernetes/helm init --client-only

# Install helmfile
RUN curl --silent --fail --location https://github.com/roboll/helmfile/releases/download/v0.67.0/helmfile_linux_amd64 -o bin/helmfile \
 && chmod +x bin/helmfile

# Install entrypoint script
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
