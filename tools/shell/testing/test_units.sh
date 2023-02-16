#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/testing/common/functions.sh

function run_tests() {
	local path
	build_usagef_testing || exit_err
	for path in $(list_unit_tests_paths); do
		./"$path" || exit_err_test_fail
	done
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_functions_testing || exit_err
}

function main() {
	check_sources
	run_tests
}

main
