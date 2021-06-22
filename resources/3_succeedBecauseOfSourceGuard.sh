#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

export MY_GLOBAL_HELLO="Hello world"

function myHello() {
  local whatIsWorld
  whatIsWorld="${1}"
  echo "${whatIsWorld}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  export HIDDEN_GLOBAL="This will be only executed when called from shell"

  myHello "$@"
fi