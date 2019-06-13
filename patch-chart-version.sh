#!/bin/bash
set -e

shopt -s nullglob
if [ -n "$GitVersion_NuGetVersion" ]; then
  for i in charts/*/Chart.yaml; do
    sed -i "s/version: .*/version: $GitVersion_NuGetVersion/; s/appVersion: .*/appVersion: $GitVersion_NuGetVersion/" $i
  done
fi
