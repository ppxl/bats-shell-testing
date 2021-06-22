#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

function mockCallingMethod() {
  local oldKey="${1}"
  local newKey="${2}"
  local newValue

  exitCode=0
  newValue="$(dbctlmock read "${newKey}")" || exitCode=2

  if [[ ${exitCode} -ne 0 ]]; then
    echo "ERROR: An error occurred while calling 'dbctlmock read ${newKey}'."
    exit ${exitCode}
  fi

  if [[ "${newValue}" == "OhLookAChange" ]] ; then
    dbctlmock update "${oldKey}" "${newValue}"
  fi
}

