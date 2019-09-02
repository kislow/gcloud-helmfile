FROM google/cloud-sdk:260.0.0
RUN apt-get install -y --no-install-recommends unzip jq postgresql-client

# Install 0install
ENV ZEROINSTALL_VERSION 2.14.1
RUN curl --silent --fail --location https://downloads.sourceforge.net/project/zero-install/0install/$ZEROINSTALL_VERSION/0install-linux-x86_64-$ZEROINSTALL_VERSION.tar.bz2 | tar xj
RUN 0install-linux-x86_64-$ZEROINSTALL_VERSION/install.sh local
RUN rm -rf 0install-linux-x86_64-$ZEROINSTALL_VERSION/

# Drop root rights
RUN useradd -m user
USER user
WORKDIR /home/user
ENV PATH="/home/user/bin:${PATH}"

# Install helm with helm-autoversion
RUN 0install add helm http://repo.roscidus.com/kubernetes/helm-autoversion
RUN 0install add-feed http://repo.roscidus.com/kubernetes/helm http://repo.roscidus.com/kubernetes/helm-autoversion
RUN helm init --client-only

# Install helmfile
RUN 0install add helmfile http://repo.roscidus.com/kubernetes/helmfile

# Install Cloud SQL Proxy
RUN 0install add cloud_sql_proxy http://repo.roscidus.com/google/cloudsql-proxy

# Install scripts
COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]
