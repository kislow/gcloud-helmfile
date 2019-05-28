#!/bin/bash
set -e

# Sanity checks
if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
  echo Environment variable GOOGLE_APPLICATION_CREDENTIALS not set!
  exit 1
fi
if [ -z "$GCP_PROJECT" ]; then
  echo Environment variable GCP_PROJECT not set!
  exit 1
fi
if [ -z "$CLUSTER_NAME" ]; then
  echo Environment variable CLUSTER_NAME not set!
  exit 1
fi
if [ -z "$CI_PROJECT_DIR" ]; then
  echo Environment variable CI_PROJECT_DIR not set!
  exit 1
fi

# Connect to Kubernetes Cluster
gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
gcloud beta container clusters get-credentials $CLUSTER_NAME --region ${CLUSTER_REGION:-europe-west3} --project $GCP_PROJECT

cd $CI_PROJECT_DIR

# Patch version number in charts
shopt -s nullglob
if [ -n "$GitVersion_NuGetVersion" ]; then
  for i in charts/*/Chart.yaml; do
    sed -i "s/version: .*/version: $GitVersion_NuGetVersion/; s/appVersion: .*/appVersion: $GitVersion_NuGetVersion/" $i
  done
fi

# Deploy charts
helmfile ${HELMFILE_OPERATION:-sync}
