#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function assert_str_val() {
	local str_var_name="$1"
	local expected_val="$2"

	echo "checking '$str_var_name'"
	[ "${!str_var_name}" == "$expected_val" ]
}

function check_string_values() {
	echo "checking string values"

	assert_str_val "ERR_ARGV_NEEDED" "args are needed" || exit_err_test_fail
	assert_str_val "ERR_ARGV_EXTRA" "excessive args (please remove)" || exit_err_test_fail
	assert_str_val "ERR_ARGV_ARG" "invalid arg" || exit_err_test_fail

	assert_str_val "DOCKERFILE_TARGET_TESTING" "testing" || exit_err_test_fail
	assert_str_val "DOCKERFILE_TARGET_PACKAGING" "packaging" || exit_err_test_fail
	assert_str_val "DOCKER_IMG_WORKDIR_PATH" "/usagef_code" || exit_err_test_fail
	assert_str_val "DOCKER_IMG_NAME_PREFIX" "usagef" || exit_err_test_fail
	assert_str_val "DOCKER_IMG_NAME_TESTING" "${DOCKER_IMG_NAME_PREFIX}-${DOCKERFILE_TARGET_TESTING}:1" || exit_err_test_fail
	assert_str_val "DOCKER_IMG_NAME_PACKAGING" "${DOCKER_IMG_NAME_PREFIX}-${DOCKERFILE_TARGET_PACKAGING}:1" || exit_err_test_fail

	assert_str_val "DIR_BUILD_NAME" "build" || exit_err_test_fail
	assert_str_val "DIR_BUILD" "${DIR_BUILD_NAME}" || exit_err_test_fail
	assert_str_val "DIR_SRC_NAME" "src" || exit_err_test_fail
	assert_str_val "DIR_SRC" "${DIR_SRC_NAME}" || exit_err_test_fail
	assert_str_val "DIR_TOOLS_NAME" "tools" || exit_err_test_fail
	assert_str_val "DIR_TOOLS" "${DIR_TOOLS_NAME}" || exit_err_test_fail
	assert_str_val "DIR_TOOLS_TOOLCHAINS" "${DIR_TOOLS}/toolchains" || exit_err_test_fail
	assert_str_val "DIR_TOOLS_SHELL_TESTING" "${DIR_TOOLS}/shell/testing" || exit_err_test_fail
	assert_str_val "DIR_TESTS_NAME" "tests" || exit_err_test_fail
	assert_str_val "DIR_TESTS" "${DIR_TESTS_NAME}" || exit_err_test_fail
	assert_str_val "DIR_TESTS_MISC" "${DIR_TESTS}/misc" || exit_err_test_fail
	assert_str_val "DIR_TESTS_OUTPUT" "${DIR_TESTS}/output" || exit_err_test_fail
	assert_str_val "DIR_TESTS_TMP" "${DIR_TESTS}/tmp" || exit_err_test_fail
	assert_str_val "DIR_TESTS_OUTPUT_EXPECTED" "${DIR_TESTS_OUTPUT}/expected" || exit_err_test_fail

	assert_str_val "REGEX_USAGEF_VERSION" '^[0-9]+\.[0-9]+\.[0-9]+$' || exit_err_test_fail

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
