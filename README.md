# gcloud-helmfile

[![Docker Build Status](https://img.shields.io/docker/cloud/build/axoom/gcloud-helmfile.svg)](https://hub.docker.com/r/axoom/gcloud-helmfile)

This combines [gcloud](https://cloud.google.com/sdk/) and [helmfile](https://github.com/roboll/helmfile) in a single Docker image to enable easy deployments to Google Kubernetes Engine.

Uses [0install](http://0install.net) to automatically download a version of [Helm](https://github.com/helm/helm) that matches the version of Tiller on the cluster.

You can configure it by setting the following environment variables:

| Name                                   | Default        | Description                                                                                                                             |
|----------------------------------------|----------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `GOOGLE_APPLICATION_CREDENTIALS`       | **required**   | The path of a JSON key file for a Google Cloud Platform service account to use to connect to the Kubernetes cluster.                    |
| `GCP_PROJECT`                          | **required**   | The Google Cloud project containing the Kubernetes cluster.                                                                             |
| `CLUSTER_NAME`                         | **required**   | The name of the Kubernetes cluster.                                                                                                     |
| `CLUSTER_REGION`                       | `europe-west3` | The region the Kubernetes cluster is deployed to.                                                                                       |
| `CI_PROJECT_DIR`                       | `.`            | The directory containing the `helmfile.yaml`.                                                                                           |
| `HELMFILE_OPERATION`                   | `sync`         | The command to pass to `helmfile`.                                                                                                      |
| `VERSION` or `GitVersion_NuGetVersion` | -              | If specified, patches this as `version` and `appVersion` into all `Chart.yaml` files in subdirectories of `$CI_PROJECT_DIR/charts`.     |
| `DATABASE_NAME`                        |                | The name of the PostgreSQL database and user to create. (see [Database Initialization](#database-initialization))                       |
| `DATABASE_PASSWORD`                    | *required*     | The password of the PostgreSQL user to create. (see [Database Initialization](#database-initialization))                                |
| `PGPASSWORD`                           | *required*     | The password of the `postgres` super-user used to create databases and users. (see [Database Initialization](#database-initialization)) |

To use this in a [GitLab CI Pipeline](https://docs.gitlab.com/ee/ci/) add the following snippet to your `.gitlab-ci.yml`:

```yaml
deploy:
  stage: deploy
  image: axoom/gcloud-helmfile
  script:
    - /entrypoint.sh
  variables:
    # gcloud
    #GOOGLE_APPLICATION_CREDENTIALS should be set in the GitLab CI settings
    GCP_PROJECT: your-google-cloud-project
    CLUSTER_NAME: your-cluster
    # helmfile
    SOME_VAR: SOME_VAL
```

## Database Initialization

The optional database initialization logic runs if the environment variable `DATABASE_NAME` is set. It assumes that a PostgreSQL instance can be reached via a Kubernetes Service named `cloud-sql` in the namespace `cloud-sql`. The easiest way to achieve this, is to deploy Google's [Cloud SQL Proxy](https://cloud.google.com/sql/docs/postgres/sql-proxy) there.

Before running `helmfile` gcloud-helmfile will try to connect to the host `cloud-sql` with the user `postgres` and the password specified in the environment variable `PGPASSWORD`. It will then create a database (if not already preset) named by the environment variable `DATABASE_NAME` and a user with the same name and a password specified in the environment variable `DATABASE_PASSWORD`.
