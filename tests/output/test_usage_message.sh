#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function test_output() {
	local argv="$1"
	local path_input
	local path_output
	local exit_code
	local exit_code_diff

	echo "testing output of argv \"${argv}\""

	path_input="${DIR_TESTS_OUTPUT_EXPECTED}/usage_message.txt"
	path_output="$(get_temp_path "usage-message")" || exit_err
	build_usagef >/dev/null || exit_err_test_fail

	# shellcheck disable=SC2086 # reason: args need to separated
	"$DIR_BUILD"/$argv >"$path_output"

	exit_code="$?"

	diff "$path_output" "$path_input"
	exit_code_diff="$?"

	rm "$path_output"
	[ "$exit_code" -eq 1 ] || exit_err_test_fail
	[ "$exit_code_diff" -eq 0 ] || exit_err_test_fail
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
	check_sourced_functions_testing || exit_err
}

function run_tests() {
	test_output "usagef"
}

function main() {
	check_sources
	run_tests
	echo "all usagef output is as expected"
}

main
