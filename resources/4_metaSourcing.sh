#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

sourcingExitCode=0
source /workspace/resources/3_succeedBecauseOfSourceGuard.sh || sourcingExitCode=$?
if [[ ${sourcingExitCode} -ne 0 ]]; then
  echo "ERROR: An error occurred while sourcing '3_succeedBecauseOfSourceGuard.sh'."
fi