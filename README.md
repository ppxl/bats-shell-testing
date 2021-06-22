# Shell Testing with BATS

- [BATS on Github: github.com/bats-core](https://github.com/bats-core/) - Core, Assertions, File etc.
- [BATS mock](https://github.com/grayhemp/bats-mock)
- [BATS Docker Hub](https://hub.docker.com/r/bats/bats) - includes BATS Core only.
- BATS doc: https://bats-core.readthedocs.io/

## Agenda

1. Basics
  - Installation
  - BATS skeleton
    - Header
    - Set Up / Tear Down
    - Test
    - Gotcha: Scripts with good error handling
1. Test options
1. Sourcing and source guards
1. Mocks
1. Files in `/`

## Basics

BATS tests are 100% Bash scripts. Everything that is possible with Bash can also be implemented in the tests.

### Installation

```
git clone --depth 1 https://github.com/bats-core/bats-assert WORKDIR/bats_libs/bats-assert
git clone --depth 1 https://github.com/grayhemp/bats-mock WORKDIR/bats_libs/bats-mock
git clone --depth 1 https://github.com/bats-core/bats-support WORKDIR/bats_libs/bats-support

docker run --rm \
		-v $(WORKDIR):$(WORKSPACE) \
		-w $(WORKSPACE)
		bats/bats:1.2.1 \
		bats --formatter junit --output /WORKSPACE/path/to/report/dir /WORKSPACE/path/to/test/scripts
```

**Findings:**

- Docker image `bats/bats` is underdocumented
- inclusion of BATS libraries has to be worked out
- own sub-image seemed to make more sense
  - For usage see [Makefile](Makefile)
  - sub-image see [Dockerfile](unitTests/Dockerfile)

### BATS skeleton

`skeleton.bats`:

**header:**

``bash
#!/usr/bin/env bash
## Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'.
export BATS_TEST_START_TIME="0"

load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'
```

**Special method names for test setup and teardown:** ```bash''.

``bash
setup() {
   doThatOneThing
}

teardown() {
   undoThatOneThing
}
```

**Tests

```bash
@test "x should result in y" {
  source yourScriptUnderTestHere
  
  run yourMethodHere
  
  ## yourAssertionsHere  
}
```

**Gotcha: scripts with good error handling**.

BATS reacts a bit strangely to scripts with `nounset` -- mainly because there are unset variables in BATS itself

```bash
#!/usr/bin/env bash
set -o nounset
## ... other security switches
```

**Solution:**

Set BATS variables with empty values

## Test possibilities

Through BATS core and extensions common tests are possible:

Test of
- output on the console
   - `assert_output`
   - `assert_line`
   - `refute_output`
   - `refute_line`
- value comparison
   - `assert_equal`
- Exit codes
   - `assert_success`
   - `assert_failure`
- Mocking of results
   - `mock_create`
   - `mock_set_status`
   - `mock_set_output`
   - `mock_get_call_num`
   - `mock_get_call_args`
- Operations on file system
   - `assert_exist`
   - `assert_dir_exist`
   - and many more plus their negation variants

## Sourcing and source guards

```
. file.sh
source file.sh
```

See:
- [2_failBecauseOfSourcing.bats](unitTests/2_failBecauseOfSourcing.bats)
- [3_succeedBecauseOfSourceGuard.bats](unitTests/3_succeedBecauseOfSourceGuard.bats)

## mocks

Repository: [grayhemp/bats-mock](https://github.com/grayhemp/bats-mock)

Example: How to test `dbctlmock` without dogu?

Solution: Mocks

- `mock_create` enables custom mocks
- mocks must be findable in `$PATH

See [4_mocking.bats](unitTests/5_mocking.bats)

## files in `/`

How to test `/startup.sh`?

# Outlook

- Environment of own container im
- NPM
   - npmjs.org/bats
   - Advantages in versioning
   - Question how to test in containers here
- BDD
   - This is the BDD alternative to Bats: https://github.com/shellspec/shellspec

# License

MIT