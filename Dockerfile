FROM google/cloud-sdk:292.0.0
RUN apt-get install -y --no-install-recommends 0install-core unzip jq postgresql-client

# Drop root rights
RUN useradd -m user
USER user
WORKDIR /home/user
ENV PATH="/home/user/bin:${PATH}"

# Setup Helm with helm-autoversion (pre-cache common versions)
RUN 0install download https://apps.0install.net/kubernetes/helm.xml --version 2.14.3
RUN 0install download https://apps.0install.net/kubernetes/helm.xml --version 2.15.2
RUN 0install download https://apps.0install.net/kubernetes/helm.xml --version 2.16.1
RUN 0install add helm https://apps.0install.net/kubernetes/helm.xml --version 2.14..!2.16.2
RUN 0install add-feed https://apps.0install.net/kubernetes/helm.xml https://apps.0install.net/kubernetes/helm-autoversion.xml
RUN helm init --client-only

# Install helmfile
RUN 0install add helmfile https://apps.0install.net/kubernetes/helmfile.xml --version-for https://apps.0install.net/kubernetes/helm.xml 2.14..!2.16.2

# Install scripts
COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]
