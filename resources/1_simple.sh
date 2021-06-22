#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function myEcho() {
  local whatIsWorld
  whatIsWorld="${1}"
  echo "${whatIsWorld}"
}

function add() {
  local op1 op2
  op1=${1}
  op2=${2}
  return "$(echo ${op1} + ${op2} | bc )"
}