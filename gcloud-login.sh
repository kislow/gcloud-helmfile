#!/bin/bash
set -e

if [ ! -f ~/.kube/config ]; then
  if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "Environment variable GOOGLE_APPLICATION_CREDENTIALS not set!"
    exit 1
  fi
  if [ -z "$GCP_PROJECT" ]; then
    echo "Environment variable GCP_PROJECT not set!"
    exit 1
  fi
  if [ -z "$CLUSTER_NAME" ]; then
    echo "Environment variable CLUSTER_NAME not set!"
    exit 1
  fi
  gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"
  gcloud config set project "$GCP_PROJECT"
  gcloud beta container clusters get-credentials "$CLUSTER_NAME" --region "${CLUSTER_REGION:-europe-west3}" --project "$GCP_PROJECT"
fi
