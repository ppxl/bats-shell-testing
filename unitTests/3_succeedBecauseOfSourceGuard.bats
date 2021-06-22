#!/usr/bin/env bash
# Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'
export BATS_TEST_START_TIME="0"

load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'

@test "3- myHello should print standard greeting" {
  source /workspace/resources/3_succeedBecauseOfSourceGuard.sh

  run myHello "${MY_GLOBAL_HELLO}"

  assert_success
  assert_line "Hello world"
  assert_line --partial "world"
}

@test "3- myHello should print custom greeting" {
  source /workspace/resources/3_succeedBecauseOfSourceGuard.sh

  run myHello "Hallo Welt"

  assert_success
  assert_output 'Hallo Welt'
  refute_output 'Hello world'
}