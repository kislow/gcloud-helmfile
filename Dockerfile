FROM google/cloud-sdk:270.0.0
RUN apt-get install -y --no-install-recommends 0install-core unzip jq postgresql-client

# Drop root rights
RUN useradd -m user
USER user
WORKDIR /home/user
ENV PATH="/home/user/bin:${PATH}"

# Setup Helm with helm-autoversion (pre-cache common versions)
RUN 0install download --version=2.15.2 http://repo.roscidus.com/kubernetes/helm
RUN 0install download --version=2.16.1 http://repo.roscidus.com/kubernetes/helm
RUN 0install add-feed http://repo.roscidus.com/kubernetes/helm http://repo.roscidus.com/kubernetes/helm-autoversion
RUN 0install add helm http://repo.roscidus.com/kubernetes/helm
RUN helm init --client-only

# Install helmfile
RUN 0install add helmfile http://repo.roscidus.com/kubernetes/helmfile

# Install scripts
COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]
