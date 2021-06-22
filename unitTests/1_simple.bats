#!/usr/bin/env bash
# Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'
export BATS_TEST_START_TIME="0"

load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'

@test "1- myEcho should print a greeting" {
  source /workspace/resources/1_simple.sh

  run myEcho "Hello world"

  assert_success
  assert_line 'Hello world'
  refute_line 'Hallo Welt'
}

@test "1- add should return the sum of two numbers" {
  source /workspace/resources/1_simple.sh

  # workaround for set -o nounset
  exitCodeAsResult=0
  add 11 31 || exitCodeAsResult=$?

  assert_equal $exitCodeAsResult 42
}