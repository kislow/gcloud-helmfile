#!/bin/bash
set -e

$(dirname "$0")/gcloud-login.sh

cd "${CI_PROJECT_DIR:-.}"
$(dirname "$0")/chart-patch.sh
helmfile ${HELMFILE_OPERATION:-sync}
