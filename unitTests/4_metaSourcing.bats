#!/usr/bin/env bash
# Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'
export BATS_TEST_START_TIME="0"

load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'

@test "4- fail because source guard will not export HIDDEN_GLOBAL" {
  source /workspace/resources/4_metaSourcing.sh

  run myHello "${HIDDEN_GLOBAL}"

  assert_success
}



@test "4- myHello should print custom greeting" {
  source /workspace/resources/4_metaSourcing.sh

  run myHello "Hallo Welt"

  assert_success
  assert_output 'Hallo Welt'
  refute_output 'Hello world'
}