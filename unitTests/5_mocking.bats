#!/usr/bin/env bash
# Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'
export BATS_TEST_START_TIME="0"

load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'
load '/workspace/target/bats_libs/bats-mock/load.bash'

setup() {
  # bats-mock/mock_create needs to be injected into the path so the production code will find the mock
  dbctlmock="$(mock_create)"
  export dbctlmock
  export PATH="${PATH}:${BATS_TMPDIR}"
  ln -s "${dbctlmock}" "${BATS_TMPDIR}/dbctlmock"
}

teardown() {
  rm "${BATS_TMPDIR}/dbctlmock"
}

@test "5- mockCallingMethod() should pass with 2 mock calls" {
  mock_set_status "${dbctlmock}" 0
  mock_set_output "${dbctlmock}" "OhLookAChange" 1 # return this string for the 1st call
  mock_set_output "${dbctlmock}" "" 2              # return the empty string for the 2nd call

  source /workspace/resources/5_mocking.sh

  run mockCallingMethod oldKey newKey

  assert_success
  refute_output
  assert_equal "$(mock_get_call_args "${dbctlmock}" "1")" "read newKey"
  assert_equal "$(mock_get_call_args "${dbctlmock}" "2")" "update oldKey OhLookAChange"
  assert_equal "$(mock_get_call_num "${dbctlmock}")" "2"
}

@test "5- mockCallingMethod() should pass with 1 mock call" {
  mock_set_status "${dbctlmock}" 0
  mock_set_output "${dbctlmock}" "sameValueAsBefore" 1
  mock_set_output "${dbctlmock}" "" 2

  source /workspace/resources/5_mocking.sh

  run mockCallingMethod oldKey newKey

  assert_success
  assert_equal "$(mock_get_call_num "${dbctlmock}")" "1"
  assert_equal "$(mock_get_call_args "${dbctlmock}" "1")" "read newKey"
}


@test "5- mockCallingMethod() should error when dbctlmock errors" {
  mock_set_status "${dbctlmock}" 19
  source /workspace/resources/5_mocking.sh

  run mockCallingMethod oldKey newKey

  assert_failure
  assert_equal "$(mock_get_call_num "${dbctlmock}")" "1"
}

