#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function check_string_values() {
	echo "checking string values"

	[ "$ERR_ARGV_NEEDED" == "args are needed" ] || exit_err_test_fail
	[ "$ERR_ARGV_EXTRA" == "excessive args (please remove)" ] || exit_err_test_fail
	[ "$ERR_ARGV_ARG" == "invalid arg" ] || exit_err_test_fail

	[ "$DOCKER_IMG_WORKDIR_PATH" == "/usagef_code" ] || exit_err_test_fail
	[ "$DOCKER_IMG_NAME_PREFIX" == "usagef" ] || exit_err_test_fail
	[ "$DOCKER_IMG_NAME_TESTING" == "${DOCKER_IMG_NAME_PREFIX}-testing:1" ] || exit_err_test_fail

	[ "$DIR_BUILD_NAME" == "build" ] || exit_err_test_fail
	[ "$DIR_BUILD" == "${DIR_BUILD_NAME}" ] || exit_err_test_fail
	[ "$DIR_SRC_NAME" == "src" ] || exit_err_test_fail
	[ "$DIR_SRC" == "${DIR_SRC_NAME}" ] || exit_err_test_fail
	[ "$DIR_TOOLS_NAME" == "tools" ] || exit_err_test_fail
	[ "$DIR_TOOLS" == "${DIR_TOOLS_NAME}" ] || exit_err_test_fail
	[ "$DIR_TOOLS_SHELL_TESTING" == "${DIR_TOOLS}/shell/testing" ] || exit_err_test_fail
	[ "$DIR_TESTS_NAME" == "tests" ] || exit_err_test_fail
	[ "$DIR_TESTS" == "${DIR_TESTS_NAME}" ] || exit_err_test_fail
	[ "$DIR_TESTS_MISC" == "${DIR_TESTS}/misc" ] || exit_err_test_fail
	[ "$DIR_TESTS_OUTPUT" == "${DIR_TESTS}/output" ] || exit_err_test_fail
	[ "$DIR_TESTS_TMP" == "${DIR_TESTS}/tmp" ] || exit_err_test_fail
	[ "$DIR_TESTS_OUTPUT_EXPECTED" == "${DIR_TESTS_OUTPUT}/expected" ] || exit_err_test_fail

	[ "$REGEX_USAGEF_VERSION" == '^[0-9]+\.[0-9]+\.[0-9]+$' ] || exit_err_test_fail

	echo "all string values are as expected"
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
	check_sourced_functions_testing || exit_err
}

function main() {
	check_sources
	check_string_values
}

main
