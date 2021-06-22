#!/usr/bin/env bash
# Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'
export BATS_TEST_START_TIME="0"

load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'

# This test must fail because of an unbound variable.
#
# This is the consequence of sourcing the script-under-test
# that contains execution calls that are not secured by a source guard.
#
# See 3_succeedBecauseOfSourceGuard.sh for how source guards are used
@test "2- test should fail" {
  source /workspace/resources/2_failBecauseOfSourcing.sh

  run myHello "${MY_GLOBAL_HELLO}"

  assert_success
}
