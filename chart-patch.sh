#!/bin/bash
set -e

shopt -s nullglob
if [ -n "$VERSION" ]; then
  for i in charts/*/Chart.yaml; do
    sed -i "s/version: .*/version: $VERSION/; s/appVersion: .*/appVersion: $VERSION/" $i
  done
fi
if [ -n "$GitVersion_NuGetVersion" ]; then
  for i in charts/*/Chart.yaml; do
    sed -i "s/version: .*/version: $GitVersion_NuGetVersion/; s/appVersion: .*/appVersion: $GitVersion_NuGetVersion/" $i
  done
fi
