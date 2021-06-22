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

myHello "$@"
