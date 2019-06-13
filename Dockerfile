FROM google/cloud-sdk:246.0.0

# Install 0install
RUN apt-get update && apt-get install -y --no-install-recommends 0install-core

# Drop root rights
RUN useradd -m user
USER user
WORKDIR /home/user
ENV PATH="/home/user/bin:${PATH}"

# Install helm-autoversion
RUN 0install add helm --version 0.3 http://assets.axoom.cloud/tools/helm-autoversion.xml
RUN helm init --client-only

# Install helmfile
RUN curl --silent --fail --location https://github.com/roboll/helmfile/releases/download/v0.67.0/helmfile_linux_amd64 -o bin/helmfile \
 && chmod +x bin/helmfile

# Install sscript
COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]
